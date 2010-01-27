From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs fsck doesn't modify a thing, and btrfs can not balance
	any data on a new device
Date: Tue, 26 Jan 2010 21:30:58 -0500
Message-ID: <20100127023058.GE11767@dhcp231-156.rdu.redhat.com>
References: <61bf8f4f1001261316u36adbd6cvfeb9bfa0da196e13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: briaeros007 <briaeros007@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <61bf8f4f1001261316u36adbd6cvfeb9bfa0da196e13@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2010 at 10:16:42PM +0100, briaeros007 wrote:
> Hello,
>=20
> I have a btrfs volume on a two 1TB disk, and i've been trying to add =
a
> new (1.5 TB) to this volume. I've done btrfsctl -a /dev/sdb /mnt/btrf=
s
> without trouble, and btrfs-show see the third disk.
> But I've got segfault when I try to balance the data.
> And when a try a fsck, he do absolutely nothing. See the commands
> below (and the dmesg)
>=20
> So if you have any idea, or want to do any additionnal tests (other
> than throwing away data that are on theses disks, since, even if i
> know btrfs is under heavy developpment, id'like to keep some data and
> haven't the right device right now to do the transfer).
>=20
>=20
> Cordially.
>=20
>=20
> <root@oni:/home/alpha>
> zsh/3 2 # umount /mnt/btrfs
> umount: /mnt/btrfs: not mounted
> [mar. 10/01/26 20:07
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 3 [1] # btrfsck /dev/sdb
> failed to read /dev/sr0
> bad block 2064048422912
> bad block 924702326784
> leaf parent key incorrect 2026404634624
> bad block 2026404634624
> leaf parent key incorrect 2045515939840
> bad block 2045515939840
> owner ref check failed [924702326784 4096]
> owner ref check failed [2026404634624 4096]
> owner ref check failed [2045515939840 4096]
> owner ref check failed [2064048422912 4096]
> found 1884638785584 bytes used err is 1
> total csum bytes: 1836791604
> total tree bytes: 3778641920
> total fs tree bytes: 1484914688
> btree space waste bytes: 611092845
> file data blocks allocated: 1926324310016
> =A0referenced 1880273379328
> Btrfs v0.19-4-gab8fb4c
> [mar. 10/01/26 20:10
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 4 [1] # btrfsck /dev/sdb
> failed to read /dev/sr0
> bad block 2064048422912
> bad block 924702326784
> leaf parent key incorrect 2026404634624
> bad block 2026404634624
> leaf parent key incorrect 2045515939840
> bad block 2045515939840
> owner ref check failed [924702326784 4096]
> owner ref check failed [2026404634624 4096]
> owner ref check failed [2045515939840 4096]
> owner ref check failed [2064048422912 4096]
> found 1884638785584 bytes used err is 1
> total csum bytes: 1836791604
> total tree bytes: 3778641920
> total fs tree bytes: 1484914688
> btree space waste bytes: 611092845
> file data blocks allocated: 1926324310016
> =A0referenced 1880273379328
> Btrfs v0.19-4-gab8fb4c
> [mar. 10/01/26 20:20
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 5 [1] # mount /mnt/btrfs
> [mar. 10/01/26 21:38
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 6 # btrfs-show
> failed to read /dev/sr0
> Label: none=A0 uuid: 3e021a76-954e-4f54-86a0-fa3849e451c2
> =A0=A0=A0=A0=A0=A0=A0 Total devices 3 FS bytes used 1.71TB
> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 3 size 1.36TB used 3.99GB path /=
dev/sdb
> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 2 size 931.51GB used 930.01GB pa=
th /dev/sdc
> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 931.51GB used 929.00GB pa=
th /dev/sdd
>=20
> Btrfs v0.19-4-gab8fb4c
> [mar. 10/01/26 21:38
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 7 # btrfs-vol -b /mnt/btrfs
> zsh: segmentation fault=A0 btrfs-vol -b /mnt/btrfs
> [mar. 10/01/26 21:41
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 9 [139] #=A0 dmesg |grep BUG
> [ 6417.151192] kernel BUG at fs/btrfs/volumes.c:1746!
> [mar. 10/01/26 21:42
> CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
> <root@oni:/home/alpha>
> zsh/3 10 #
>=20
> my dmesg, from the warning, then the bug
>=20
> [ 6413.080969] btrfs: relocating block group 2917377507328 flags 9
> [ 6413.942527] btrfs: relocating block group 2914156281856 flags 9
> [ 6416.792048] btrfs csum failed ino 258 off 249937920 csum 374924638=
9
> private 2282873894
> [ 6416.798204] btrfs csum failed ino 258 off 249937920 csum 374924638=
9
> private 2282873894
> [ 6416.837809] btrfs csum failed ino 258 off 249937920 csum 374924638=
9
> private 2282873894
> [ 6416.841459] btrfs csum failed ino 258 off 249937920 csum 374924638=
9
> private 2282873894

CSUM failures.  Something is going horribly wrong.  Either one of the f=
ollowing

1) A bug
2) Bad memory
3) Something went wrong with the disk at some point

1 is hard to track down at this point, 3 is possible, but again hard to=
 prove.
So try running memtest86 on your system to rule out #2.  If the memory =
checks
out, reformat and try again.  If you keep having problems we'll try and=
 figure
out if its #1 or #3.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
