From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: v0.19-35-g1b444cd btrfsck says snapshots have errors
Date: Fri, 21 Jan 2011 09:15:49 +0800
Message-ID: <AANLkTi=7aDgTUtRB3nyLsVvdQzkYHA6iQueN9Dv-4wFm@mail.gmail.com>
References: <20110120225256.GA4161@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Ian! D. Allen" <idallen@idallen.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110120225256.GA4161@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 21, 2011 at 6:52 AM, Ian! D. Allen <idallen@idallen.ca> wro=
te:
> Still getting btrfsck errors with this:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unsta=
ble.git
>
> # ./btrfstest.sh
> Using /mnt/sdb1 /dev/sdb1 on /dev/sdb
> + mkfs.btrfs -L BTRFStest /dev/sdb1
>
> WARNING! - Btrfs v0.19-35-g1b444cd IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>
> fs created label BTRFStest on /dev/sdb1
> =A0 =A0 =A0 =A0nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00G=
B
> Btrfs v0.19-35-g1b444cd
> + mount -o noatime /dev/sdb1 /mnt/sdb1
> + btrfs subvolume snapshot /mnt/sdb1 /mnt/sdb1/snap1
> Create a snapshot of '/mnt/sdb1' in '/mnt/sdb1/snap1'
> + btrfs subvolume snapshot /mnt/sdb1/snap1 /mnt/sdb1/snap2
> Create a snapshot of '/mnt/sdb1/snap1' in '/mnt/sdb1/snap2'
> + btrfs subvolume snapshot /mnt/sdb1/snap2 /mnt/sdb1/snap3
> Create a snapshot of '/mnt/sdb1/snap2' in '/mnt/sdb1/snap3'
> + btrfs subvolume snapshot /mnt/sdb1/snap3 /mnt/sdb1/snap4
> Create a snapshot of '/mnt/sdb1/snap3' in '/mnt/sdb1/snap4'
> + btrfs subvolume snapshot /mnt/sdb1/snap4 /mnt/sdb1/snap5
> Create a snapshot of '/mnt/sdb1/snap4' in '/mnt/sdb1/snap5'
> + umount /dev/sdb1
> + btrfsck /dev/sdb1
> fs tree 256 refs 6
> =A0 =A0 =A0 =A0unresolved ref root 256 dir 256 index 2 namelen 5 name=
 snap1 error 600
> =A0 =A0 =A0 =A0unresolved ref root 257 dir 256 index 2 namelen 5 name=
 snap1 error 600
> =A0 =A0 =A0 =A0unresolved ref root 258 dir 256 index 2 namelen 5 name=
 snap1 error 600
> =A0 =A0 =A0 =A0unresolved ref root 259 dir 256 index 2 namelen 5 name=
 snap1 error 600
> =A0 =A0 =A0 =A0unresolved ref root 260 dir 256 index 2 namelen 5 name=
 snap1 error 600
> found 49152 bytes used err is 1
> total csum bytes: 0
> total tree bytes: 49152
> total fs tree bytes: 28672
> btree space waste bytes: 39360
> file data blocks allocated: 0
> =A0referenced 0
> Btrfs v0.19-35-g1b444cd
>
>

These is caused by a design flaw, you can safely ignore them.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
