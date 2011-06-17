#ifndef WSOCKET_H
#define WSOCKET_H
/*=========================================================================*\
* Socket compatibilization module for Win32
* LuaSocket toolkit
*
* RCS ID: $Id: wsocket.h,v 1.2 2003/06/26 18:47:49 diego Exp $
\*=========================================================================*/

/*=========================================================================*\
* WinSock include files
\*=========================================================================*/
#include <winsock.h>

typedef int socklen_t;
typedef int ssize_t;
typedef SOCKET t_sock;
typedef t_sock *p_sock;

#define SOCK_INVALID (INVALID_SOCKET)

#endif /* WSOCKET_H */
