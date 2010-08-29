From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: btrfs-progs: error in manage
Date: Sun, 29 Aug 2010 20:38:21 +0200
Message-ID: <4C7AA91D.3040003@gmail.com>
References: <201002122001.09898.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002122001.09898.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi,

On the man page for the btrfs command balance is listed as a
subcommand under device instead of file system.

Kind Regards,
Andreas

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..bd73dc0 100644
- --- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -21,12 +21,12 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max
<filesystem>\fP
 .PP
+\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+.PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
- -\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
- -.PP
 \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
@@ -143,7 +143,7 @@ Show the btrfs filesystem with some additional
info. If no UUID or label is
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP

- -\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJMeqkcAAoJEJIcBJ3+XkgiRmcP/1RlZw+aJeVwAdhXzrYpoEY5
g7YFjH+o8RnC8sXnb35lDQq/uQ0Kk5VWkNOfhN+G9ZCMcEkA9uRP7rgUTc9OjRmL
0rTOytD/PsPCV8nhy5vJ5krO8lzQA9ChX3BOwmVXumfdl1SMSPjaw/Cp/AK3IP3K
6fCTefT7A5tOSFvTa5b4AdNj+mIn60MwF7d8on0J7OJgzhdw4ZIoQNApJ3hnldYE
kUAbfthO4jlvibEWG+wk5FEeGxkTKthZK5y/4R5PdnutWwY9f0XG5WQsJuPS7qB6
Tzz+EtxRSmTwsDJxt8RKr4k8NH+UOlZQg9VcNvdTAJaP6wkrZi39uRL7zH6bIjfh
9D+Fty2zzvMsXVORrdfL35wHKcx1xH491msn5U925ej9OU9j/tV/rYr/wSDMG3AW
GILKKzuT+9Xsgs5cYpG2ENdIeDI1kEoa/ZdYIyxSSEuo9DXb8+BsOces2kr+a1Fl
NSPIm7vQaIxcY09H9sexyEWz1IC2GnKLbMz8AuOkbNEpxbIYcuPgTdnPZrRY7xbW
K//hf3uDxkxxQ44/24hgK9o9DkVDS37nzHN7mtoGTyvDg1o4RksnFwQGZluAfShi
vfBulYqGkH50HWO25t66XholaQ1WSs4MuUb47/wNO5AocbeAezJB3WvZ+I9zLkWS
kZxFmJKvHkHwj34FxxXb
=OxAs
-----END PGP SIGNATURE-----

