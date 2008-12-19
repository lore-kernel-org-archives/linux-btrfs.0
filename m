From: devzero@web.de
Subject: Re: weird bash autocomplete issue
Date: Fri, 19 Dec 2008 01:59:52 +0100
Message-ID: <548462911@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> I see the same issue on x86 32 bit, with the additional __llseek()
> between the getdents64(), and the last entry returned by readdir
> ignored.

confirmed - it`s readdir which assumes 32bit.

attached is a sample program which shows the issue on my system.

if compiled with -D_FILE_OFFSET_BITS=3D64", the problem goes away.

old posting from around 2001:

>http://sourceware.org/ml/libc-alpha/2001-01/msg00216.html
>
>This is why everybody will have to compile programs with
>_FILE_OFFSET_BITS=3D64.  Did you ever notice that all GNU programs
>already do this?

as 32bit systems can use 64bit filesystems, i think btrfs is correct an=
d bash is wrong,=20
as it isn`t LFS aware. i think all 32bit stuff should be LFS aware, now=
adays.

to be exact, it`s not bash but readline library which comes with bash.
bash configure script correctly checks for _FILE_OFFSET_BITS value, but=
 readline configure script doesn`t.
this explains why i could not reproduce the issue when i build bash wit=
hout readline support.

does it make sense to file a ticket at novell bugzilla ?

regards
roland


linux:/btrfs # ls -ltr
total 13
drwxrwxrwx 1 root root     0 Dec 16 22:44 test
drwxrwxrwx 1 root root  1056 Dec 17 01:10 linux-2.6.27.8-1
drwxr-xr-x 1 root root     0 Dec 17 22:53 abc
drwxr-xr-x 1 root root     0 Dec 19 00:48 bcd
-rw-r--r-- 1 root root   443 Dec 19 01:15 example.c
-rwxr-xr-x 1 root root 10962 Dec 19 01:15 a.out

linux:/btrfs # ./a.out
=2E
=2E.
linux-2.6.27.8-1
test
abc
bcd
example.c
readdir: Value too large for defined data type


regards
roland



#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

int main( int argc, char *argv[] ) {
    DIR *pDIR;
    struct dirent *pDirEnt;

    pDIR =3D opendir(".");

    pDirEnt =3D readdir( pDIR );

    while ( pDirEnt !=3D NULL ) {
        printf( "%s\n", pDirEnt->d_name );
        pDirEnt =3D readdir( pDIR );
        if (errno) perror("readdir");

    }

    closedir( pDIR );

}
____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger geh=F6rt?=20
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3D3123

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
