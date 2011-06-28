From: "Kamble, Nitin A" <nitin.a.kamble@intel.com>
Subject: [Patch] make btrfs cross compilation friendly
Date: Tue, 28 Jun 2011 12:11:35 -0700
Message-ID: <9DA5872FEF993D41B7173F58FCF6BE94DE0A2B8A@orsmsx504.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_9DA5872FEF993D41B7173F58FCF6BE94DE0A2B8Aorsmsx504amrcor_"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--_002_9DA5872FEF993D41B7173F58FCF6BE94DE0A2B8Aorsmsx504amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Attached is a patch to fix a cross compilation issue I observed with btrfs-=
tools.=20

Signed-Off-By: Nitin A Kamble <nitin.a.kamble@intel.com>

Nitin A Kamble
Yocto Project=20
www.yoctoproject.org



Avoid these kinds of errors while doing cross build:

| ccache i586-poky-linux-gcc -march=3Di586 --sysroot=3D/disk0/pokybuild/bui=
ld0/tmp/sysroots/qemux86 -Wp,-MMD,./.btrfsctl.o.d,-MT,btrfsctl.o -Wall -D_F=
ILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -pipe -g -feliminate-unused-=
debug-types -c btrfsctl.c
| gcc -O2 -pipe -g -feliminate-unused-debug-types -o btrfsctl btrfsctl.o ct=
ree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-ite=
m.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o e=
xtent_io.o volumes.o utils.o btrfs-list.o -Wl,-O1  -Wl,--as-needed -luuid
| /usr/bin/ld: i386 architecture of input file `btrfsctl.o' is incompatible=
 with i386:x86-64 output
| /usr/bin/ld: i386 architecture of input file `ctree.o' is incompatible wi=
th i386:x86-64 output

Index: git/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- git.orig/Makefile
+++ git/Makefile
@@ -38,53 +38,53 @@ version:
 	bash version.sh
=20
 btrfs: $(objects) btrfs.o btrfs_cmds.o
-	gcc $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o \
+	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o \
 		$(objects) $(LDFLAGS) $(LIBS)
=20
 btrfsctl: $(objects) btrfsctl.o
-	gcc $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
=20
 btrfs-vol: $(objects) btrfs-vol.o
-	gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
=20
 btrfs-show: $(objects) btrfs-show.o
-	gcc $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
=20
 btrfsck: $(objects) btrfsck.o
-	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
=20
 mkfs.btrfs: $(objects) mkfs.o
-	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
=20
 btrfs-debug-tree: $(objects) debug-tree.o
-	gcc $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LI=
BS)
+	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(=
LIBS)
=20
 btrfs-zero-log: $(objects) btrfs-zero-log.o
-	gcc $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(=
LIBS)
+	$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) =
$(LIBS)
=20
 btrfs-select-super: $(objects) btrfs-select-super.o
-	gcc $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDF=
LAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(L=
DFLAGS) $(LIBS)
=20
 btrfstune: $(objects) btrfstune.o
-	gcc $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
=20
 btrfs-map-logical: $(objects) btrfs-map-logical.o
-	gcc $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLA=
GS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDF=
LAGS) $(LIBS)
=20
 btrfs-image: $(objects) btrfs-image.o
-	gcc $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDF=
LAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(L=
DFLAGS) $(LIBS)
=20
 dir-test: $(objects) dir-test.o
-	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
=20
 quick-test: $(objects) quick-test.o
-	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
=20
 convert: $(objects) convert.o
-	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(=
LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err =
$(LDFLAGS) $(LIBS)
=20
 ioctl-test: $(objects) ioctl-test.o
-	gcc $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
=20
 manpages:
 	cd man; make

--_002_9DA5872FEF993D41B7173F58FCF6BE94DE0A2B8Aorsmsx504amrcor_
Content-Type: application/octet-stream; name="fix_use_of_gcc.patch"
Content-Description: fix_use_of_gcc.patch
Content-Disposition: attachment; filename="fix_use_of_gcc.patch"; size=4178;
	creation-date="Tue, 28 Jun 2011 12:06:23 GMT";
	modification-date="Fri, 24 Jun 2011 08:26:46 GMT"
Content-Transfer-Encoding: base64

Tml0aW4gQSBLYW1ibGUgPG5pdGluLmEua2FtYmxlQGludGVsLmNvbT4gMjAxMS8wNi8wOQpVcHN0
cmVhbVN0YXR1czogUGVuZGluZwoKQXZvaWQgdGhlc2Uga2luZHMgb2YgZXJyb3JzIHdoaWxlIGRv
aW5nIGNyb3NzIGJ1aWxkOgoKfCBjY2FjaGUgaTU4Ni1wb2t5LWxpbnV4LWdjYyAtbWFyY2g9aTU4
NiAtLXN5c3Jvb3Q9L2Rpc2swL3Bva3lidWlsZC9idWlsZDAvdG1wL3N5c3Jvb3RzL3FlbXV4ODYg
LVdwLC1NTUQsLi8uYnRyZnNjdGwuby5kLC1NVCxidHJmc2N0bC5vIC1XYWxsIC1EX0ZJTEVfT0ZG
U0VUX0JJVFM9NjQgLURfRk9SVElGWV9TT1VSQ0U9MiAtTzIgLXBpcGUgLWcgLWZlbGltaW5hdGUt
dW51c2VkLWRlYnVnLXR5cGVzIC1jIGJ0cmZzY3RsLmMKfCBnY2MgLU8yIC1waXBlIC1nIC1mZWxp
bWluYXRlLXVudXNlZC1kZWJ1Zy10eXBlcyAtbyBidHJmc2N0bCBidHJmc2N0bC5vIGN0cmVlLm8g
ZGlzay1pby5vIHJhZGl4LXRyZWUubyBleHRlbnQtdHJlZS5vIHByaW50LXRyZWUubyByb290LXRy
ZWUubyBkaXItaXRlbS5vIGZpbGUtaXRlbS5vIGlub2RlLWl0ZW0ubyBpbm9kZS1tYXAubyBjcmMz
MmMubyByYnRyZWUubyBleHRlbnQtY2FjaGUubyBleHRlbnRfaW8ubyB2b2x1bWVzLm8gdXRpbHMu
byBidHJmcy1saXN0Lm8gLVdsLC1PMSAgLVdsLC0tYXMtbmVlZGVkIC1sdXVpZAp8IC91c3IvYmlu
L2xkOiBpMzg2IGFyY2hpdGVjdHVyZSBvZiBpbnB1dCBmaWxlIGBidHJmc2N0bC5vJyBpcyBpbmNv
bXBhdGlibGUgd2l0aCBpMzg2Ong4Ni02NCBvdXRwdXQKfCAvdXNyL2Jpbi9sZDogaTM4NiBhcmNo
aXRlY3R1cmUgb2YgaW5wdXQgZmlsZSBgY3RyZWUubycgaXMgaW5jb21wYXRpYmxlIHdpdGggaTM4
Njp4ODYtNjQgb3V0cHV0CgpJbmRleDogZ2l0L01ha2VmaWxlCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGdpdC5v
cmlnL01ha2VmaWxlCisrKyBnaXQvTWFrZWZpbGUKQEAgLTM4LDUzICszOCw1MyBAQCB2ZXJzaW9u
OgogCWJhc2ggdmVyc2lvbi5zaAogCiBidHJmczogJChvYmplY3RzKSBidHJmcy5vIGJ0cmZzX2Nt
ZHMubwotCWdjYyAkKENGTEFHUykgLW8gYnRyZnMgYnRyZnMubyBidHJmc19jbWRzLm8gXAorCSQo
Q0MpICQoQ0ZMQUdTKSAtbyBidHJmcyBidHJmcy5vIGJ0cmZzX2NtZHMubyBcCiAJCSQob2JqZWN0
cykgJChMREZMQUdTKSAkKExJQlMpCiAKIGJ0cmZzY3RsOiAkKG9iamVjdHMpIGJ0cmZzY3RsLm8K
LQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzY3RsIGJ0cmZzY3RsLm8gJChvYmplY3RzKSAkKExERkxB
R1MpICQoTElCUykKKwkkKENDKSAkKENGTEFHUykgLW8gYnRyZnNjdGwgYnRyZnNjdGwubyAkKG9i
amVjdHMpICQoTERGTEFHUykgJChMSUJTKQogCiBidHJmcy12b2w6ICQob2JqZWN0cykgYnRyZnMt
dm9sLm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzLXZvbCBidHJmcy12b2wubyAkKG9iamVjdHMp
ICQoTERGTEFHUykgJChMSUJTKQorCSQoQ0MpICQoQ0ZMQUdTKSAtbyBidHJmcy12b2wgYnRyZnMt
dm9sLm8gJChvYmplY3RzKSAkKExERkxBR1MpICQoTElCUykKIAogYnRyZnMtc2hvdzogJChvYmpl
Y3RzKSBidHJmcy1zaG93Lm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzLXNob3cgYnRyZnMtc2hv
dy5vICQob2JqZWN0cykgJChMREZMQUdTKSAkKExJQlMpCisJJChDQykgJChDRkxBR1MpIC1vIGJ0
cmZzLXNob3cgYnRyZnMtc2hvdy5vICQob2JqZWN0cykgJChMREZMQUdTKSAkKExJQlMpCiAKIGJ0
cmZzY2s6ICQob2JqZWN0cykgYnRyZnNjay5vCi0JZ2NjICQoQ0ZMQUdTKSAtbyBidHJmc2NrIGJ0
cmZzY2subyAkKG9iamVjdHMpICQoTERGTEFHUykgJChMSUJTKQorCSQoQ0MpICQoQ0ZMQUdTKSAt
byBidHJmc2NrIGJ0cmZzY2subyAkKG9iamVjdHMpICQoTERGTEFHUykgJChMSUJTKQogCiBta2Zz
LmJ0cmZzOiAkKG9iamVjdHMpIG1rZnMubwotCWdjYyAkKENGTEFHUykgLW8gbWtmcy5idHJmcyAk
KG9iamVjdHMpIG1rZnMubyAkKExERkxBR1MpICQoTElCUykKKwkkKENDKSAkKENGTEFHUykgLW8g
bWtmcy5idHJmcyAkKG9iamVjdHMpIG1rZnMubyAkKExERkxBR1MpICQoTElCUykKIAogYnRyZnMt
ZGVidWctdHJlZTogJChvYmplY3RzKSBkZWJ1Zy10cmVlLm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0
cmZzLWRlYnVnLXRyZWUgJChvYmplY3RzKSBkZWJ1Zy10cmVlLm8gJChMREZMQUdTKSAkKExJQlMp
CisJJChDQykgJChDRkxBR1MpIC1vIGJ0cmZzLWRlYnVnLXRyZWUgJChvYmplY3RzKSBkZWJ1Zy10
cmVlLm8gJChMREZMQUdTKSAkKExJQlMpCiAKIGJ0cmZzLXplcm8tbG9nOiAkKG9iamVjdHMpIGJ0
cmZzLXplcm8tbG9nLm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzLXplcm8tbG9nICQob2JqZWN0
cykgYnRyZnMtemVyby1sb2cubyAkKExERkxBR1MpICQoTElCUykKKwkkKENDKSAkKENGTEFHUykg
LW8gYnRyZnMtemVyby1sb2cgJChvYmplY3RzKSBidHJmcy16ZXJvLWxvZy5vICQoTERGTEFHUykg
JChMSUJTKQogCiBidHJmcy1zZWxlY3Qtc3VwZXI6ICQob2JqZWN0cykgYnRyZnMtc2VsZWN0LXN1
cGVyLm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzLXNlbGVjdC1zdXBlciAkKG9iamVjdHMpIGJ0
cmZzLXNlbGVjdC1zdXBlci5vICQoTERGTEFHUykgJChMSUJTKQorCSQoQ0MpICQoQ0ZMQUdTKSAt
byBidHJmcy1zZWxlY3Qtc3VwZXIgJChvYmplY3RzKSBidHJmcy1zZWxlY3Qtc3VwZXIubyAkKExE
RkxBR1MpICQoTElCUykKIAogYnRyZnN0dW5lOiAkKG9iamVjdHMpIGJ0cmZzdHVuZS5vCi0JZ2Nj
ICQoQ0ZMQUdTKSAtbyBidHJmc3R1bmUgJChvYmplY3RzKSBidHJmc3R1bmUubyAkKExERkxBR1Mp
ICQoTElCUykKKwkkKENDKSAkKENGTEFHUykgLW8gYnRyZnN0dW5lICQob2JqZWN0cykgYnRyZnN0
dW5lLm8gJChMREZMQUdTKSAkKExJQlMpCiAKIGJ0cmZzLW1hcC1sb2dpY2FsOiAkKG9iamVjdHMp
IGJ0cmZzLW1hcC1sb2dpY2FsLm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzLW1hcC1sb2dpY2Fs
ICQob2JqZWN0cykgYnRyZnMtbWFwLWxvZ2ljYWwubyAkKExERkxBR1MpICQoTElCUykKKwkkKEND
KSAkKENGTEFHUykgLW8gYnRyZnMtbWFwLWxvZ2ljYWwgJChvYmplY3RzKSBidHJmcy1tYXAtbG9n
aWNhbC5vICQoTERGTEFHUykgJChMSUJTKQogCiBidHJmcy1pbWFnZTogJChvYmplY3RzKSBidHJm
cy1pbWFnZS5vCi0JZ2NjICQoQ0ZMQUdTKSAtbyBidHJmcy1pbWFnZSAkKG9iamVjdHMpIGJ0cmZz
LWltYWdlLm8gLWxwdGhyZWFkIC1seiAkKExERkxBR1MpICQoTElCUykKKwkkKENDKSAkKENGTEFH
UykgLW8gYnRyZnMtaW1hZ2UgJChvYmplY3RzKSBidHJmcy1pbWFnZS5vIC1scHRocmVhZCAtbHog
JChMREZMQUdTKSAkKExJQlMpCiAKIGRpci10ZXN0OiAkKG9iamVjdHMpIGRpci10ZXN0Lm8KLQln
Y2MgJChDRkxBR1MpIC1vIGRpci10ZXN0ICQob2JqZWN0cykgZGlyLXRlc3QubyAkKExERkxBR1Mp
ICQoTElCUykKKwkkKENDKSAkKENGTEFHUykgLW8gZGlyLXRlc3QgJChvYmplY3RzKSBkaXItdGVz
dC5vICQoTERGTEFHUykgJChMSUJTKQogCiBxdWljay10ZXN0OiAkKG9iamVjdHMpIHF1aWNrLXRl
c3QubwotCWdjYyAkKENGTEFHUykgLW8gcXVpY2stdGVzdCAkKG9iamVjdHMpIHF1aWNrLXRlc3Qu
byAkKExERkxBR1MpICQoTElCUykKKwkkKENDKSAkKENGTEFHUykgLW8gcXVpY2stdGVzdCAkKG9i
amVjdHMpIHF1aWNrLXRlc3QubyAkKExERkxBR1MpICQoTElCUykKIAogY29udmVydDogJChvYmpl
Y3RzKSBjb252ZXJ0Lm8KLQlnY2MgJChDRkxBR1MpIC1vIGJ0cmZzLWNvbnZlcnQgJChvYmplY3Rz
KSBjb252ZXJ0Lm8gLWxleHQyZnMgLWxjb21fZXJyICQoTERGTEFHUykgJChMSUJTKQorCSQoQ0Mp
ICQoQ0ZMQUdTKSAtbyBidHJmcy1jb252ZXJ0ICQob2JqZWN0cykgY29udmVydC5vIC1sZXh0MmZz
IC1sY29tX2VyciAkKExERkxBR1MpICQoTElCUykKIAogaW9jdGwtdGVzdDogJChvYmplY3RzKSBp
b2N0bC10ZXN0Lm8KLQlnY2MgJChDRkxBR1MpIC1vIGlvY3RsLXRlc3QgJChvYmplY3RzKSBpb2N0
bC10ZXN0Lm8gJChMREZMQUdTKSAkKExJQlMpCisJJChDQykgJChDRkxBR1MpIC1vIGlvY3RsLXRl
c3QgJChvYmplY3RzKSBpb2N0bC10ZXN0Lm8gJChMREZMQUdTKSAkKExJQlMpCiAKIG1hbnBhZ2Vz
OgogCWNkIG1hbjsgbWFrZQo=

--_002_9DA5872FEF993D41B7173F58FCF6BE94DE0A2B8Aorsmsx504amrcor_--
