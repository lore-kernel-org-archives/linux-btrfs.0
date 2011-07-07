From: "Yulin, Denis" <delin@eridan.la>
Subject: btrfs: open_ctree failed
Date: Thu, 7 Jul 2011 13:20:38 +0400
Message-ID: <CAPXeO6Rx5EJRf4iVUwp64BQSEsJ8Kps5ebJM8dmbrnnCrYuveg@mail.gmail.com>
References: <CAPXeO6QbDxyoqYRhXxMGvc9JYQ6TZrTF7MwCNg-xdU-MgCQU3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPXeO6QbDxyoqYRhXxMGvc9JYQ6TZrTF7MwCNg-xdU-MgCQU3w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,=C2=A0just=C2=A0apologize for=C2=A0my English.
In=C2=A0a=C2=A0nice,=C2=A0warm evening,=C2=A0turn off the=C2=A0electric=
ity,=C2=A0and=C2=A0my router=C2=A0with
btrfs on root,=C2=A0broke=C2=A0..
I removed the image of a partition (10G), I will now rearrange the
system is probably on ext4 ..

Start the discussion -=C2=A0http://www.linux.org.ru/forum/general/64658=
51
OS=C2=A0during the fall=C2=A0- Debian=C2=A06 (2.6.39=C2=A0kernel=C2=A0f=
rom=C2=A0sid),=C2=A0mounted
filesystem=C2=A0with parameters=C2=A0compression=3Dlzo
btfs-progs v0.19 from git.
btrfs-show - all ok;
=46S is the LVM;

root@sysresccd /root % mount -t btrfs -o compress=3Dlzo /dev/mapper/nas=
-root /re
mount: wrong fs type, bad option, bad superblock on /dev/mapper/nas-roo=
t,
=C2=A0 =C2=A0 =C2=A0 =C2=A0missing codepage or helper program, or other=
 error
=C2=A0 =C2=A0 =C2=A0 =C2=A0In some cases useful info is found in syslog=
 - try
=C2=A0 =C2=A0 =C2=A0 =C2=A0dmesg | tail =C2=A0or so
root@sysresccd /root % dmesg | tail
[ 3821.972350] parent transid verify failed on 3807195136 wanted 5412 f=
ound 5414
[ 3821.972364] parent transid verify failed on 3807195136 wanted 5412 f=
ound 5414
[ 3821.979182] btrfs: open_ctree failed
[ 6298.660270] device label root devid 1 transid 12174 /dev/mapper/nas-=
root
[ 6298.660657] btrfs: use lzo compression
[ 6298.662878] parent transid verify failed on 3807195136 wanted 5412 f=
ound 5414
[ 6298.663321] parent transid verify failed on 3807195136 wanted 5412 f=
ound 5414
[ 6298.663584] parent transid verify failed on 3807195136 wanted 5412 f=
ound 5414
[ 6298.663595] parent transid verify failed on 3807195136 wanted 5412 f=
ound 5414
[ 6298.669180] btrfs: open_ctree failed
root@sysresccd /root % btrfsck /dev/nas/root
parent transid verify failed on 3807195136 wanted 5412 found 5414
parent transid verify failed on 3807195136 wanted 5412 found 5414
parent transid verify failed on 3807195136 wanted 5412 found 5414
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'=
 failed.
zsh: abort =C2=A0 =C2=A0 =C2=A0btrfsck /dev/nas/root
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
