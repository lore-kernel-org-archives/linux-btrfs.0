From: Kenneth Lakin <kennethlakin@gmail.com>
Subject: Reproducible kernel BUG while using VirtualBox:
Date: Wed, 29 Dec 2010 13:51:49 -0800
Message-ID: <4D1BAD75.1060602@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020508070003090908020805"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020508070003090908020805
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

All,

I believe that I can pretty reliably reproduce the BUG mentioned in the
attached dmesg output. (This doesn't mean that you can, but I'll detail
what I've done here.) [This BUG is the same one that I reported last night.]

1) Create a 2 GB dynamically expanding disk.
2) Attach it to a VirtualBox machine.
3) Start the Kubuntu install process.
4) Wait until the virtual disk grows to around ~850MB. (This happens
when the install process is in the "installing packages" phase.)
5) Notice that that progress bar hasn't moved in a little while.
6) Record the BUG info from dmesg.
7) Wait around a little while more until the Kubuntu install mentions
that it has encountered an error.
8) Reboot your physical machine to kill the VirtualBox instance that now
won't shut down, but isn't actually using any CPU time. [Using xkill on
this instance results in the zombie VirtualBox process that's stuck in
IO-wait that I reported last night.]

Note that dd'ing 1GB of data to a file on disk (from /dev/zero or
/dev/urandom) does not cause an error, so this doesn't seem to be a disk
fullness thing.

More information about my machine:
I once mounted the filesystem in question with the space_cache option.
All free space numbers here are from *before* I dd'd 1GB of data onto disk.

$ btrfs fi df /
Data: total=71.23GB, used=68.16GB
System, DUP: total=8.00MB, used=24.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=4.75GB, used=2.26GB

$ df -h /
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/campstovevg-root
                       81G   73G  3.4G  96% /
$ mount | grep btrfs
/dev/mapper/campstovevg-root on / type btrfs (rw,relatime,ssd)

$ uname -a
Linux campstove 2.6.36+ #5 SMP PREEMPT Mon Dec 20 09:28:14 PST 2010 i686
Intel(R) Core(TM) Duo CPU L2400 @ 1.66GHz GenuineIntel GNU/Linux

~/btrfs-unstable $ git log -n1 | head -n3
commit 83a50de97fe96aca82389e061862ed760ece2283
Author: Chris Mason <chris.mason@oracle.com>
Date:   Mon Dec 13 15:06:46 2010 -0500

~/btrfs-progs-unstable $ git log -n1 | head -n3
commit 1b444cd2e6ab8dcafdd47dbaeaae369dd1517c17
Author: Chris Mason <chris.mason@oracle.com>
Date:   Wed Oct 6 09:53:38 2010 -0400


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJNG610AAoJEIsblWe5kJ+jNP0IAIUfHtBts4L5Ym5xGrBBOR/7
ujBNVTQlWp/8jkEQOoHa8zrrSdnA9i4ijwOFHZQ3t5zvMYhw5PmtIVuMVEjFN0kx
ItuB0ClCOT+NA8rlwpWrrMWUlHxD+I8fH4QVEP2DZ8n8fJ9jj3ULZTBRBhBcvpeA
Yr5RoxBRN9jd1PZkx4RQ/mk0mv3h0Qv+BTese7EvsEbzeOFVYA94g6SQnY+qtVeH
b374E85R6cQYmlYQqVlrIvTj3NivUIG6js5Bs9oKwv/jN2BRK/1To5U26OwNWV/S
kbQn6fB6StTnJjteWZe8wRiUtWs7WHVAMKjqDd500+RScgsmGTWgjC3MySGnNlY=
=J5zb
-----END PGP SIGNATURE-----

--------------020508070003090908020805
Content-Type: text/plain;
 name="dmesgReport101229.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesgReport101229.txt"

WzQ3MzgzLjI5NjY1NF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50
ZXIgZGVyZWZlcmVuY2UgYXQgKG51bGwpCls0NzM4My4yOTY3NDFdIElQOiBbPGMwMTIyMmRl
Pl0ga21hcF9hdG9taWNfcHJvdCsweDE5LzB4YmQKWzQ3MzgzLjI5NjgwNF0gKnBkZSA9IDAw
MDAwMDAwIApbNDczODMuMjk2ODM5XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAgCls0
NzM4My4yOTY4OTJdIGxhc3Qgc3lzZnMgZmlsZTogL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUv
Y3B1MS9jYWNoZS9pbmRleDIvc2hhcmVkX2NwdV9tYXAKWzQ3MzgzLjI5Njk3MF0gTW9kdWxl
cyBsaW5rZWQgaW46IHNreTIgYWVzX2k1ODYgYWVzX2dlbmVyaWMgZmJjb24gdGlsZWJsaXQg
Zm9udCBiaXRibGl0IHNvZnRjdXJzb3IgbmZzZCBsb2NrZCBuZnNfYWNsIGF1dGhfcnBjZ3Nz
IGlwdjYgc3VucnBjIGNvcmV0ZW1wIHNuZF9zZXFfb3NzIHNuZF9zZXFfbWlkaV9ldmVudCBz
bmRfc2VxIHNuZF9wY21fb3NzIHNjbyBibmVwIHNuZF9taXhlcl9vc3MgYmluZm10X21pc2Mg
dmJveG5ldGFkcCB2Ym94bmV0Zmx0IHZib3hkcnYgc25kX3VzYl9hdWRpbyBzbmRfdXNibWlk
aV9saWIgc25kX3Jhd21pZGkgc25kX3NlcV9kZXZpY2UgdXNic2VyaWFsIHJmY29tbSBsMmNh
cCBoY2lfdWFydCBmdXNlIGNwdWZyZXFfcG93ZXJzYXZlIGNwdWZyZXFfdXNlcnNwYWNlIGNw
dWZyZXFfc3RhdHMgY3B1ZnJlcV9jb25zZXJ2YXRpdmUgYWNwaV9jcHVmcmVxIG1wZXJmIHR1
biBhcmM0IGVjYiBpd2wzOTQ1IGk5MTUgaXdsY29yZSBzbmRfaGRhX2NvZGVjX2lkdCBtYWM4
MDIxMSBzbmRfaGRhX2ludGVsIGRybV9rbXNfaGVscGVyIHNuZF9oZGFfY29kZWMgZHJtIHNu
ZF9od2RlcCBzbmRfcGNtIGNmZzgwMjExIHBwZGV2IGJ0dXNiIHNuZF90aW1lciBpMmNfYWxn
b19iaXQgcGFycG9ydF9wYyBibHVldG9vdGggcGFuYXNvbmljX2xhcHRvcCBjZmJjb3B5YXJl
YSB2aWRlbyBzbmQgcHJvY2Vzc29yIHRwbV9pbmZpbmVvbiBjb250YWluZXIgcGFycG9ydCBz
ZyB0aGVybWFsIHJma2lsbCBiYXR0ZXJ5IGNmYmltZ2JsdCBiYWNrbGlnaHQgaTJjX2k4MDEg
b3V0cHV0IGFjIGNmYmZpbGxyZWN0IHNuZF9wYWdlX2FsbG9jIHRoZXJtYWxfc3lzIHBjc3Br
ciBidXR0b24gbW1jX2Jsb2NrIHBjbWNpYSBzZGhjaV9wY2kgc2RoY2kgeWVudGFfc29ja2V0
IGZpcmV3aXJlX29oY2kgcGNtY2lhX3JzcmMgbW1jX2NvcmUgZmlyZXdpcmVfY29yZSBwY21j
aWFfY29yZSBkbV9tb2QgW2xhc3QgdW5sb2FkZWQ6IG1pY3JvY29kZV0KWzQ3MzgzLjI5NzAw
OV0gCls0NzM4My4yOTcwMDldIFBpZDogOTQ2NCwgY29tbTogVmlydHVhbEJveCBOb3QgdGFp
bnRlZCAyLjYuMzYrICM1IENGMzAtMS9DRi0zMEMzUEFaQk0KWzQ3MzgzLjI5NzAwOV0gRUlQ
OiAwMDYwOls8YzAxMjIyZGU+XSBFRkxBR1M6IDAwMDEwMjAyIENQVTogMQpbNDczODMuMjk3
MDA5XSBFSVAgaXMgYXQga21hcF9hdG9taWNfcHJvdCsweDE5LzB4YmQKWzQ3MzgzLjI5NzAw
OV0gRUFYOiAwMDAwMDAwMCBFQlg6IGRkYjIyMDAwIEVDWDogMDAwMDAxNjMgRURYOiAwMDAw
MDAwMwpbNDczODMuMjk3MDA5XSBFU0k6IDAwMDAxMDAwIEVESTogMDAwMDAwMDAgRUJQOiBk
ZGIyMmRkOCBFU1A6IGRkYjIyZGM4Cls0NzM4My4yOTcwMDldICBEUzogMDA3YiBFUzogMDA3
YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbNDczODMuMjk3MDA5XSBQcm9jZXNzIFZp
cnR1YWxCb3ggKHBpZDogOTQ2NCwgdGk9ZGRiMjIwMDAgdGFzaz1mNzA4Y2E0MCB0YXNrLnRp
PWRkYjIyMDAwKQpbNDczODMuMjk3MDA5XSBTdGFjazoKWzQ3MzgzLjI5NzAwOV0gIDNjNTFi
MTYzIGRkYjIyZWE4IDAwMDAxMDAwIDAwMDAwMDAwIGRkYjIyZGUwIGMwMTIyMzk1IGRkYjIy
ZGY0IGMwMTk0MjZiCls0NzM4My4yOTcwMDldIDwwPiAwMDAwMDIwMCAwMDAwMTAwMCAwMDAw
MDAwMCBkZGIyMmUxOCBjMDQwYTFhZSAwMDAwMDIwMCAwMDA5NmUwMCAwMDAwMDA5NwpbNDcz
ODMuMjk3MDA5XSA8MD4gMDAwMDEwMDAgMDAwOTcwMDAgZGRiMjJlYTggYzE3YzA4MDAgZGRi
MjJlY2MgYzA0MGE3ZGIgYzE3YzA0MDAgZGRiMjJlYTgKWzQ3MzgzLjI5NzAwOV0gQ2FsbCBU
cmFjZToKWzQ3MzgzLjI5NzAwOV0gIFs8YzAxMjIzOTU+XSA/IGttYXBfYXRvbWljKzB4MTMv
MHgxNQpbNDczODMuMjk3MDA5XSAgWzxjMDE5NDI2Yj5dID8gaW92X2l0ZXJfY29weV9mcm9t
X3VzZXJfYXRvbWljKzB4M2YvMHg4NQpbNDczODMuMjk3MDA5XSAgWzxjMDQwYTFhZT5dID8g
YnRyZnNfY29weV9mcm9tX3VzZXIuY2xvbmUuOSsweDVhLzB4YTIKWzQ3MzgzLjI5NzAwOV0g
IFs8YzA0MGE3ZGI+XSA/IGJ0cmZzX2ZpbGVfYWlvX3dyaXRlKzB4NGQwLzB4N2UyCls0NzM4
My4yOTcwMDldICBbPGMwMWU5MmU4Pl0gPyBhaW9fcndfdmVjdF9yZXRyeSsweDZkLzB4MTNi
Cls0NzM4My4yOTcwMDldICBbPGMwMWU5OWZlPl0gPyBfX2Fpb19nZXRfcmVxKzB4MWYvMHhm
MgpbNDczODMuMjk3MDA5XSAgWzxjMDQwYTMwYj5dID8gYnRyZnNfZmlsZV9haW9fd3JpdGUr
MHgwLzB4N2UyCls0NzM4My4yOTcwMDldICBbPGMwMWU5MjdiPl0gPyBhaW9fcndfdmVjdF9y
ZXRyeSsweDAvMHgxM2IKWzQ3MzgzLjI5NzAwOV0gIFs8YzAxZTllMjg+XSA/IGFpb19ydW5f
aW9jYisweDY3LzB4ZjcKWzQ3MzgzLjI5NzAwOV0gIFs8YzAxZWFiZWY+XSA/IGRvX2lvX3N1
Ym1pdCsweDQzZS8weDYwMgpbNDczODMuMjk3MDA5XSAgWzxjMDFlYWRjYj5dID8gc3lzX2lv
X3N1Ym1pdCsweDE4LzB4MWEKWzQ3MzgzLjI5NzAwOV0gIFs8YzAxMDI5MWY+XSA/IHN5c2Vu
dGVyX2RvX2NhbGwrMHgxMi8weDI4Cls0NzM4My4yOTcwMDldICBbPGMwNjEwMDAwPl0gPyBz
bGFiX2NwdXVwX2NhbGxiYWNrKzB4OTQvMHhmMApbNDczODMuMjk3MDA5XSBDb2RlOiA0OCAx
NCA4YiA0MCAwOCBhOCAwOCA3NCAwNSBlOCBmMyBlZSA0ZSAwMCA1YiA1ZSA1ZCBjMyA1NSA4
OSBlNSA1NyA1NiA1MyA4MyBlYyAwNCAwZiAxZiA0NCAwMCAwMCA4OSBlMyA4MSBlMyAwMCBm
MCBmZiBmZiBmZiA0MyAxNCA8OGI+IDE4IGMxIGViIDFlIGMxIGUzIDBhIDhkIGIzIDgwIGNl
IDhjIGMwIDJiIGIzIDBjIGQyIDhjIGMwIDgxIApbNDczODMuMjk3MDA5XSBFSVA6IFs8YzAx
MjIyZGU+XSBrbWFwX2F0b21pY19wcm90KzB4MTkvMHhiZCBTUzpFU1AgMDA2ODpkZGIyMmRj
OApbNDczODMuMjk3MDA5XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWzQ3MzgzLjMxNDI0N10g
LS0tWyBlbmQgdHJhY2UgMWRkM2ZhYWE5ZWE0NGE0NCBdLS0tCls0NzM4My4zMTQzMDBdIG5v
dGU6IFZpcnR1YWxCb3hbOTQ2NF0gZXhpdGVkIHdpdGggcHJlZW1wdF9jb3VudCAyCg==
--------------020508070003090908020805
Content-Type: application/pgp-signature;
 name="dmesgReport101229.txt.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesgReport101229.txt.sig"

iQEcBAABAgAGBQJNG610AAoJEIsblWe5kJ+jyoUH/26oNVs4C4mNCehHvQyk+maajTyAPvVa
S7YhIeG64aCzScJY2rILuBS0twhKnI0wvgdUDdFhL1tca0J+rE8HCnlTgtdU/uxDs7y8l1Ow
wUzV2bv083jkUReOjSSn7Ctd8RJIVmv1p+WRJyRU7E4dtqv9n7X6x+Bm3tiPgdOnD9+5fM+/
ug2jGCsVeV76ZeXFYmzBuRCNQZo8XbN/ml/IWMuyHSvz5zezip0MQjt1wKo2Ty2sqT64OS7l
M18oB7vwszBD00NeY1GOZBp4sLc+jqCoHgh27+6rrWCywfM1D/QM3b2hnyk89POwRLpXLU5y
fVKUS1Ux9mhLmz6Sg53rIUM=
--------------020508070003090908020805--
