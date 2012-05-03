From: "Yo'av Moshe" <bjesus@gmail.com>
Subject: Can't mount
Date: Thu, 3 May 2012 15:18:01 +0000
Message-ID: <CAPAyKowHusQXh-BzvgQRBL8=82yTgP+marcdVq8wLtSxuoCyvQ@mail.gmail.com>
References: <CAPAyKow8hk5kzAkkTG=nmOMpnhjx3cjM_-uLGNVmNWXNc+1j=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPAyKow8hk5kzAkkTG=nmOMpnhjx3cjM_-uLGNVmNWXNc+1j=g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

When I try to mount my Btrfs filesystem it fails and this shows up on dmesg:

device fsid 97727502-a678-4ed1-a96c-409b852d76bf devid 1 transid
135714 /dev/sda4
btrfs: enabling auto recoveryparent transid verify failed on
216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
btrfs: open_ctree failed

Using the latest btrfs-progs, btrfsck and btrfs-debug-tree gives this:

parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
Ignoring transid failure
btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
`!(path->slots[0] == 0)' failed.

I also couldn't find anything valid using btrfs-select-super.

This is find-root's output:
http://pastebin.com/KycgzhaP

Is there anything else I can try?

I'm using kernel 3.2 on Ubuntu 12.04.

Thanks in advance,
Yo'av
