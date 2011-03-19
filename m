From: Viacheslav Dobromyslov <slavik.dobro@gmail.com>
Subject: Re: btrfs: open_ctree failed after power loss
Date: Sat, 19 Mar 2011 17:53:54 +1000
Message-ID: <AANLkTi=iERoyiz_J7BkXBR2YBiGS5=FPqv=FnqhEUviJ@mail.gmail.com>
References: <loom.20110205T071833-653@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110205T071833-653@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I've just updated kernel to 2.6.38. Now there are no troubles with
mounting after btrfsck and brtfs-select-super.
Thank you guys!

Sincerely,
Viacheslav Dobromyslov


On Sat, Feb 5, 2011 at 4:53 PM, Viacheslav Dobromyslov
<slavik.dobro@gmail.com> wrote:
>
> Hello, friends!
>
> I have some troubles with removable disk after powering off without u=
nmounting.
> 'btrfsck' and 'btrfs-select-super' didn't help.
>
> # uname -srvo
> Linux 2.6.37-gentoo #2 SMP PREEMPT Tue Jan 11 20:58:56 VLAT 2011 GNU/=
Linux
>
> Installed sys-fs/btrfs-progs-0.19-r2.
>
> # btrfs fi show
> failed to read /dev/sr0
> Label: none =A0uuid: acf790ef-13ba-4c08-b0d3-3ab9938b5b94
> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 9.97GB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 14.65GB used 14.65GB path /dev/sda=
4
>
> Label: none =A0uuid: 53b9ab33-8049-46e0-a90f-b601446abc79
> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 20.35GB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 150.00GB used 23.29GB path /dev/sd=
c2
>
> # mount -t btrfs /dev/sdc2 /mnt/
> mount: wrong fs type, bad option, bad superblock on /dev/sdc2,
> =A0 =A0 =A0 missing codepage or helper program, or other error
> =A0 =A0 =A0 In some cases useful info is found in syslog - try
> =A0 =A0 =A0 dmesg | tail =A0or so
>
> # dmesg
> device fsid e046498033abb953-79bc6a4401b60fa9 devid 1 transid 433 /de=
v/sdc2
> btrfs: open_ctree failed
>
> # btrfsck /dev/sdc2
> found 21851738112 bytes used err is 0
> total csum bytes: 21297140
> total tree bytes: 43466752
> total fs tree bytes: 17068032
> btree space waste bytes: 7526756
> file data blocks allocated: 21808271360
> =A0referenced 21808271360
> Btrfs Btrfs v0.19
>
> # btrfs-select-super -s 1 /dev/sdc2
> using SB copy 1, bytenr 67108864
>
> # btrfs-debug-tree /dev/sdc2
> root tree
> leaf 23651717120 items 12 free space 1987 generation 433 owner 1
> fs uuid 53b9ab33-8049-46e0-a90f-b601446abc79
> chunk uuid 461537d2-d586-4f0c-9469-09d8933bce0a
> =A0 =A0 =A0 =A0item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 3756 item=
size 239
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root data bytenr 23651721216 level 2 d=
irid 0 refs 1
>
> .....................................
>
> =A0 =A0 =A0 =A0item 30 key (12298 EXTENT_DATA 0) itemoff 1548 itemsiz=
e 53
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent data disk byte 22261157888 nr 1=
3418496
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent data offset 0 nr 13418496 ram 1=
3418496
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent compression 0
> data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0)
> leaf 29380608 items 2 free space 3773 generation 5 owner 184467440737=
09551607
> fs uuid 53b9ab33-8049-46e0-a90f-b601446abc79
> chunk uuid 461537d2-d586-4f0c-9469-09d8933bce0a
> =A0 =A0 =A0 =A0item 0 key (FIRST_CHUNK_TREE INODE_ITEM 0) itemoff 383=
5 itemsize 160
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode generation 4 size 0 block group =
0 mode 40555 links 1
> =A0 =A0 =A0 =A0item 1 key (FIRST_CHUNK_TREE INODE_REF 256) itemoff 38=
23 itemsize 12
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode ref index 0 namelen 2 name: ..
> total bytes 161067429888
> bytes used 21851738112
> uuid 53b9ab33-8049-46e0-a90f-b601446abc79
> Btrfs Btrfs v0.19
>
>
> I've already found similar trouble http://www.spinics.net/lists/linux=
-
> btrfs/msg07572.html . but that solution didn't help.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
