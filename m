Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61619 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab2JKMva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 08:51:30 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so2242957wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2012 05:51:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121011113359.GD22640@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
	<50733D66.5020600@gmx.net>
	<20121009111830.GC31743@campbell-lange.net>
	<CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
	<20121010221107.GA19266@campbell-lange.net>
	<CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
	<20121011113359.GD22640@campbell-lange.net>
Date: Thu, 11 Oct 2012 14:51:28 +0200
Message-ID: <CAOcd+r3E=vhtHwenmHbqV_i3FN5e4rK0x+CkOOHz3WHKVAQi1A@mail.gmail.com>
Subject: Re: btrfs receive to subdirectory
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=e0cb4e43d237a429da04cbc80719
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--e0cb4e43d237a429da04cbc80719
Content-Type: text/plain; charset=ISO-8859-1

Hi Rory,
all your tests work perfectly for me (really, I swear:)), with exact
same mount points and subvol/snap/dir names.
Just to make that the patch some how did not get messed up in the
mail, I attach it.

Can you pls post the output of "cat /proc/mounts" and "mount" (if
you're willing to debug this further).

Other than that, I will probably need to see the contents of your
source subvol (at least file names, not necessarily the content). So
if you can expose it, can you perhaps do something like:
tree -A --inodes --noreport -s /bkp/subvol
and also
tree -A --inodes --noreport -s /mnt
before you start the test (I assume that two subvolumes at /mnt are
empty, right).

However, I doubt the contents will really help, because it seems to
fail very early, even before it starts processing the commands.

Thanks,
Alex.


On Thu, Oct 11, 2012 at 1:33 PM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:
> On 11/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
>> I am using the latest code from Chris's repo (
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git),
>> which has been updated recently (latest commit
>> 91d9eec1ff044394f2b98ee7fcb76713dd33b994).
>> Do you think you can try the following patch on top of this commit? (I
>> made another small fix).
>
> I had to fix the line wrapping, but your patch applies fine now.
>
>> Basically, the idea is that the path that you give to "btrfs receive"
>> should be the destination directory, in which the received subvolume
>> will be created. And this directory should be somewhere under a mount
>> point, where destination btrfs is mounted (it can also be the same as
>> the mount point, but not above it). Does this make sense?
>> Also it should not matter where the sent subvolume resided in the
>> source fs, and, if this is a diff-send, where you have received the
>> parent snapshot to (as long as it is on/under the same mount point).
>
> I don't think the receive pathing works. Please note below the following issues:
>     [aa] ERROR: open snapdir/subvol_20121011_1214 failed. No such file or directory
>     [bb] ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory
>     [cc] ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory
>
> I tested this with the following:
>
>     send mount point /bkp
>     receive mount point /mnt
>
> The 'send' mount point has the following structure:
>
>     root@orchard:/bkp# ls
>     > snaps  subvol
>     (subvol a btrfs subvolume, snaps a directory for holding snapshots)
>
> I then made a directory and two subvolumes in /mnt to receive 'sends':
>
>     root@orchard:/bkp# ls /mnt
>     > arbitrary_subvol  snapdir  subvol
>
> I applied your patch to progs 91d9eec1, then did the following rooted in /bkp:
>
>     1. Create snapshots
>
>     root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/subvol_20121011_1214
>     > Create a readonly snapshot of 'subvol' in 'snaps/subvol_20121011_1214'
>
>     root@orchard:/bkp# mutt -f subvol/INBOX
>     > 1573 kept, 39 deleted.
>
>     root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/subvol_20121011_1216
>     > Create a readonly snapshot of 'subvol' in 'snaps/subvol_20121011_1216'
>
>     2. Send base snapshots to /mnt/{snapdir,arbitrary_subvol,subvol}
>
>     root@orchard:/bkp# btrfs send snaps/subvol_20121011_1214 | btrfs receive /mnt/snapdir
>     > At subvol snaps/subvol_20121011_1214
>     > At subvol subvol_20121011_1214
>
>     root@orchard:/bkp# btrfs send snaps/subvol_20121011_1214 | btrfs receive /mnt/arbitrary_subvol
>     > At subvol snaps/subvol_20121011_1214
>     > At subvol subvol_20121011_1214
>
>     root@orchard:/bkp# btrfs send snaps/subvol_20121011_1214 | btrfs receive /mnt/subvol
>     > At subvol snaps/subvol_20121011_1214
>     > At subvol subvol_20121011_1214
>
>     3. Send incremental changes
>
>     root@orchard:/bkp# btrfs send -p snaps/subvol_20121011_1214
>                        snaps/subvol_20121011_1216/ | btrfs receive /mnt/snapdir
>     At subvol snaps/subvol_20121011_1216/
>     At snapshot subvol_20121011_1216
>     ERROR: open snapdir/subvol_20121011_1214 failed. No such file or directory [aa]
>
>     root@orchard:/bkp# btrfs send -p snaps/subvol_20121011_1214
>                              snaps/subvol_20121011_1216/ | btrfs receive /mnt/arbitrary_subvol
>     At subvol snaps/subvol_20121011_1216/
>     At snapshot subvol_20121011_1216
>     ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory [bb]
>
>     root@orchard:/bkp# btrfs send -p snaps/subvol_20121011_1214
>                              snaps/subvol_20121011_1216/ | btrfs receive /mnt/subvol
>     At subvol snaps/subvol_20121011_1216/
>     At snapshot subvol_20121011_1216
>     ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory [cc]
>
>
>     root@orchard:/bkp# btrfs subvolume list /bkp
>     ID 256 gen 9 top level 5 path subvol
>     ID 260 gen 7 top level 5 path snaps/subvol_20121011_1214
>     ID 261 gen 9 top level 5 path snaps/subvol_20121011_1216
>
>     root@orchard:/bkp# btrfs subvolume list /mnt
>     ID 301 gen 66 top level 5 path arbitrary_subvol
>     ID 302 gen 69 top level 5 path subvol
>     ID 303 gen 66 top level 5 path snapdir/subvol_20121011_1214
>     ID 304 gen 69 top level 5 path arbitrary_subvol/subvol_20121011_1214
>     ID 305 gen 72 top level 5 path subvol/subvol_20121011_1214
>
>
>
> --
> Rory Campbell-Lange
> rory@campbell-lange.net

--e0cb4e43d237a429da04cbc80719
Content-Type: application/octet-stream; name="rory.patch"
Content-Disposition: attachment; filename="rory.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h85v2lwt0

ZGlmZiAtLWdpdCBhL2NtZHMtcmVjZWl2ZS5jIGIvY21kcy1yZWNlaXZlLmMKaW5kZXggYThiZTZm
YS4uNmI3Y2YxMiAxMDA2NDQKLS0tIGEvY21kcy1yZWNlaXZlLmMKKysrIGIvY21kcy1yZWNlaXZl
LmMKQEAgLTUyLDExICs1MiwxMyBAQCBzdGF0aWMgaW50IGdfdmVyYm9zZSA9IDA7CiBzdHJ1Y3Qg
YnRyZnNfcmVjZWl2ZQogewogCWludCBtbnRfZmQ7CisJaW50IGRlc3RfZGlyX2ZkOwogCiAJaW50
IHdyaXRlX2ZkOwogCWNoYXIgKndyaXRlX3BhdGg7CiAKIAljaGFyICpyb290X3BhdGg7CisJY2hh
ciAqZGVzdF9kaXJfcGF0aDsgLyogcmVsYXRpdmUgdG8gcm9vdF9wYXRoICovCiAJY2hhciAqZnVs
bF9zdWJ2b2xfcGF0aDsKIAogCXN0cnVjdCBzdWJ2b2xfaW5mbyAqY3VyX3N1YnZvbDsKQEAgLTE1
MCw4ICsxNTIsMTEgQEAgc3RhdGljIGludCBwcm9jZXNzX3N1YnZvbChjb25zdCBjaGFyICpwYXRo
LCBjb25zdCB1OCAqdXVpZCwgdTY0IGN0cmFuc2lkLAogCXItPmN1cl9zdWJ2b2wgPSBjYWxsb2Mo
MSwgc2l6ZW9mKCpyLT5jdXJfc3Vidm9sKSk7CiAJci0+cGFyZW50X3N1YnZvbCA9IE5VTEw7CiAK
LQlyLT5jdXJfc3Vidm9sLT5wYXRoID0gc3RyZHVwKHBhdGgpOwotCXItPmZ1bGxfc3Vidm9sX3Bh
dGggPSBwYXRoX2NhdChyLT5yb290X3BhdGgsIHBhdGgpOworCWlmIChzdHJsZW4oci0+ZGVzdF9k
aXJfcGF0aCkgPT0gMCkKKwkJci0+Y3VyX3N1YnZvbC0+cGF0aCA9IHN0cmR1cChwYXRoKTsKKwll
bHNlCisJCXItPmN1cl9zdWJ2b2wtPnBhdGggPSBwYXRoX2NhdChyLT5kZXN0X2Rpcl9wYXRoLCBw
YXRoKTsKKwlyLT5mdWxsX3N1YnZvbF9wYXRoID0gcGF0aF9jYXQzKHItPnJvb3RfcGF0aCwgci0+
ZGVzdF9kaXJfcGF0aCwgcGF0aCk7CiAKIAlmcHJpbnRmKHN0ZGVyciwgIkF0IHN1YnZvbCAlc1xu
IiwgcGF0aCk7CiAKQEAgLTE2Nyw3ICsxNzIsNyBAQCBzdGF0aWMgaW50IHByb2Nlc3Nfc3Vidm9s
KGNvbnN0IGNoYXIgKnBhdGgsIGNvbnN0IHU4ICp1dWlkLCB1NjQgY3RyYW5zaWQsCiAKIAltZW1z
ZXQoJmFyZ3NfdjEsIDAsIHNpemVvZihhcmdzX3YxKSk7CiAJc3RyY3B5KGFyZ3NfdjEubmFtZSwg
cGF0aCk7Ci0JcmV0ID0gaW9jdGwoci0+bW50X2ZkLCBCVFJGU19JT0NfU1VCVk9MX0NSRUFURSwg
JmFyZ3NfdjEpOworCXJldCA9IGlvY3RsKHItPmRlc3RfZGlyX2ZkLCBCVFJGU19JT0NfU1VCVk9M
X0NSRUFURSwgJmFyZ3NfdjEpOwogCWlmIChyZXQgPCAwKSB7CiAJCXJldCA9IC1lcnJubzsKIAkJ
ZnByaW50ZihzdGRlcnIsICJFUlJPUjogY3JlYXRpbmcgc3Vidm9sdW1lICVzIGZhaWxlZC4gIgpA
QCAtMTk1LDggKzIwMCwxMSBAQCBzdGF0aWMgaW50IHByb2Nlc3Nfc25hcHNob3QoY29uc3QgY2hh
ciAqcGF0aCwgY29uc3QgdTggKnV1aWQsIHU2NCBjdHJhbnNpZCwKIAlyLT5jdXJfc3Vidm9sID0g
Y2FsbG9jKDEsIHNpemVvZigqci0+Y3VyX3N1YnZvbCkpOwogCXItPnBhcmVudF9zdWJ2b2wgPSBO
VUxMOwogCi0Jci0+Y3VyX3N1YnZvbC0+cGF0aCA9IHN0cmR1cChwYXRoKTsKLQlyLT5mdWxsX3N1
YnZvbF9wYXRoID0gcGF0aF9jYXQoci0+cm9vdF9wYXRoLCBwYXRoKTsKKwlpZiAoc3RybGVuKHIt
PmRlc3RfZGlyX3BhdGgpID09IDApCisJCXItPmN1cl9zdWJ2b2wtPnBhdGggPSBzdHJkdXAocGF0
aCk7CisJZWxzZQorCQlyLT5jdXJfc3Vidm9sLT5wYXRoID0gcGF0aF9jYXQoci0+ZGVzdF9kaXJf
cGF0aCwgcGF0aCk7CisJci0+ZnVsbF9zdWJ2b2xfcGF0aCA9IHBhdGhfY2F0MyhyLT5yb290X3Bh
dGgsIHItPmRlc3RfZGlyX3BhdGgsIHBhdGgpOwogCiAJZnByaW50ZihzdGRlcnIsICJBdCBzbmFw
c2hvdCAlc1xuIiwgcGF0aCk7CiAKQEAgLTI0Myw3ICsyNTEsNyBAQCBzdGF0aWMgaW50IHByb2Nl
c3Nfc25hcHNob3QoY29uc3QgY2hhciAqcGF0aCwgY29uc3QgdTggKnV1aWQsIHU2NCBjdHJhbnNp
ZCwKIAkJZ290byBvdXQ7CiAJfQogCi0JcmV0ID0gaW9jdGwoci0+bW50X2ZkLCBCVFJGU19JT0Nf
U05BUF9DUkVBVEVfVjIsICZhcmdzX3YyKTsKKwlyZXQgPSBpb2N0bChyLT5kZXN0X2Rpcl9mZCwg
QlRSRlNfSU9DX1NOQVBfQ1JFQVRFX1YyLCAmYXJnc192Mik7CiAJY2xvc2UoYXJnc192Mi5mZCk7
CiAJaWYgKHJldCA8IDApIHsKIAkJcmV0ID0gLWVycm5vOwpAQCAtNzkwLDE3ICs3OTgsNDggQEAg
c3RydWN0IGJ0cmZzX3NlbmRfb3BzIHNlbmRfb3BzID0gewogaW50IGRvX3JlY2VpdmUoc3RydWN0
IGJ0cmZzX3JlY2VpdmUgKnIsIGNvbnN0IGNoYXIgKnRvbW50LCBpbnQgcl9mZCkKIHsKIAlpbnQg
cmV0OworCWNoYXIgKmRlc3RfZGlyX2Z1bGxfcGF0aDsKIAlpbnQgZW5kID0gMDsKIAotCXItPnJv
b3RfcGF0aCA9IHN0cmR1cCh0b21udCk7Ci0Jci0+bW50X2ZkID0gb3Blbih0b21udCwgT19SRE9O
TFkgfCBPX05PQVRJTUUpOworCWRlc3RfZGlyX2Z1bGxfcGF0aCA9IHJlYWxwYXRoKHRvbW50LCBO
VUxMKTsKKwlpZiAoIWRlc3RfZGlyX2Z1bGxfcGF0aCkgeworCQlyZXQgPSAtZXJybm87CisJCWZw
cmludGYoc3RkZXJyLCAiRVJST1I6IHJlYWxwYXRoKCVzKSBmYWlsZWQuICVzXG4iLCB0b21udCwK
KwkJCQlzdHJlcnJvcigtcmV0KSk7CisJCWdvdG8gb3V0OworCX0KKwlyLT5kZXN0X2Rpcl9mZCA9
IG9wZW4oZGVzdF9kaXJfZnVsbF9wYXRoLCBPX1JET05MWSB8IE9fTk9BVElNRSk7CisJaWYgKHIt
PmRlc3RfZGlyX2ZkIDwgMCkgeworCQlyZXQgPSAtZXJybm87CisJCWZwcmludGYoc3RkZXJyLCAi
RVJST1I6IGZhaWxlZCB0byBvcGVuIGRlc3RpbmF0aW9uIGRpcmVjdG9yeSAlcy4gJXNcbiIsIAor
CQkJICAgIGRlc3RfZGlyX2Z1bGxfcGF0aCwgc3RyZXJyb3IoLXJldCkpOworCQlnb3RvIG91dDsK
Kwl9CisKKwlyZXQgPSBmaW5kX21vdW50X3Jvb3QoZGVzdF9kaXJfZnVsbF9wYXRoLCAmci0+cm9v
dF9wYXRoKTsKKwlpZiAocmV0IDwgMCkgeworCQlyZXQgPSAtRUlOVkFMOworCQlmcHJpbnRmKHN0
ZGVyciwgIkVSUk9SOiBmYWlsZWQgdG8gZGV0ZXJtaW5lIG1vdW50IHBvaW50ICIKKwkJCQkiZm9y
ICVzXG4iLCBkZXN0X2Rpcl9mdWxsX3BhdGgpOworCQlnb3RvIG91dDsKKwl9CisJci0+bW50X2Zk
ID0gb3BlbihyLT5yb290X3BhdGgsIE9fUkRPTkxZIHwgT19OT0FUSU1FKTsKIAlpZiAoci0+bW50
X2ZkIDwgMCkgewogCQlyZXQgPSAtZXJybm87Ci0JCWZwcmludGYoc3RkZXJyLCAiRVJST1I6IGZh
aWxlZCB0byBvcGVuICVzLiAlc1xuIiwgdG9tbnQsCisJCWZwcmludGYoc3RkZXJyLCAiRVJST1I6
IGZhaWxlZCB0byBvcGVuICVzLiAlc1xuIiwgci0+cm9vdF9wYXRoLAogCQkJCXN0cmVycm9yKC1y
ZXQpKTsKIAkJZ290byBvdXQ7CiAJfQogCisJLyoKKwkgKiBmaW5kX21vdW50X3Jvb3QgcmV0dXJu
cyBhIHJvb3RfcGF0aCB0aGF0IGlzIGEgc3VicGF0aCBvZiAKKwkgKiBkZXN0X2Rpcl9mdWxsX3Bh
dGguIE5vdyBnZXQgdGhlIG90aGVyIHBhcnQgb2Ygcm9vdF9wYXRoLAorCSAqIHdoaWNoIGlzIHRo
ZSBkZXN0aW5hdGlvbiBkaXIgcmVsYXRpdmUgdG8gcm9vdF9wYXRoLgorCSAqLworCXItPmRlc3Rf
ZGlyX3BhdGggPSBkZXN0X2Rpcl9mdWxsX3BhdGggKyBzdHJsZW4oci0+cm9vdF9wYXRoKTsKKwlp
ZiAoci0+ZGVzdF9kaXJfcGF0aFswXSA9PSAnLycpCisJCXItPmRlc3RfZGlyX3BhdGgrKzsKKwog
CXJldCA9IHN1YnZvbF91dWlkX3NlYXJjaF9pbml0KHItPm1udF9mZCwgJnItPnN1cyk7CiAJaWYg
KHJldCA8IDApCiAJCXJldHVybiByZXQ7CmRpZmYgLS1naXQgYS9zZW5kLXV0aWxzLmggYi9zZW5k
LXV0aWxzLmgKaW5kZXggZGE0MDdlYi4uYTNlMDM4YiAxMDA2NDQKLS0tIGEvc2VuZC11dGlscy5o
CisrKyBiL3NlbmQtdXRpbHMuaApAQCAtNjUsNSArNjUsNiBAQCB2b2lkIHN1YnZvbF91dWlkX3Nl
YXJjaF9hZGQoc3RydWN0IHN1YnZvbF91dWlkX3NlYXJjaCAqcywKIGNoYXIgKnBhdGhfY2F0KGNv
bnN0IGNoYXIgKnAxLCBjb25zdCBjaGFyICpwMik7CiBjaGFyICpwYXRoX2NhdDMoY29uc3QgY2hh
ciAqcDEsIGNvbnN0IGNoYXIgKnAyLCBjb25zdCBjaGFyICpwMyk7CiAKK2ludCBmaW5kX21vdW50
X3Jvb3QoY29uc3QgY2hhciAqcGF0aCwgY2hhciAqKm1vdW50X3Jvb3QpOwogCiAjZW5kaWYgLyog
U0VORF9VVElMU19IXyAqLwo=
--e0cb4e43d237a429da04cbc80719--
