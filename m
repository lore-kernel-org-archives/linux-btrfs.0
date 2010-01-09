From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: snapshot/subvolume removal
Date: Sun, 10 Jan 2010 00:01:48 +0200
Message-ID: <4B48FCCC.9050004@cs.bgu.ac.il>
References: <4B43AC9B.5030109@cs.bgu.ac.il> <4B43D9AB.1090606@jp.fujitsu.com> <4B444AD5.1060501@cs.bgu.ac.il> <4B46ECBA.2030402@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B46ECBA.2030402@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

TARUISI Hiroaki wrote:
> For now, subvolumes and snapshots look like just directories.
> If you want to distinguish them, there's only an unusual way,
> that is, analyzing with btrfs-debug-tree.
>
> I posted patches for listing snapshots/subvolumes two months ago,
> and Josef Bacik posted its bugfix patch. This feature may be
> delivered in sooner or later.
> If you want to try it now, check these URLs.
>   http://patchwork.kernel.org/patch/60923/raw/
>   http://patchwork.kernel.org/patch/60920/raw/
>   http://patchwork.kernel.org/patch/67332/raw/
>   
Thanks for pointing me all the needed patched, the btrfsctl -l is
working for me fine.
> Patches and requests are welcome.
>   
Currently btrfsctl -l show only which directories are
snapshots/subvolumes, it would be nice if it would also show
a hierarchy of snapshots i.e. from which subvolume/snapshot a specific
snapshot was taken from.

For example:

/ # cd /.btrfs
/.btrfs #  btrfsctl -l /.btrfs
   Base path = /.btrfs/
   No.     Tree ID      Subvolume Relative Path
    1          275      rootfs-old/
    2          277      rootfs/
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs # btrfsctl -S subvol0 .
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #  btrfsctl -l /.btrfs/
   Base path = /.btrfs/
   No.     Tree ID      Subvolume Relative Path
    1          275      rootfs-old/
    2          277      rootfs/
    3          279      subvol0/
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs # btrfsctl -s subvol0-snap subvol0
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs # btrfsctl -s subvol0/subvol1-snap subvol0
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs # btrfsctl -s subvol1-snap-snap subvol0/subvol1-snap
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #  btrfsctl -l /.btrfs/
   Base path = /.btrfs/
   No.     Tree ID      Subvolume Relative Path
    1          275      rootfs-old/
    2          277      rootfs/
    3          279      subvol0/
    4          281      subvol0/subvol1-snap/
    5          280      subvol0-snap/
    6          282      subvol1-snap-snap/
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/ .btrfs #                   

It would be nice if it would possible to show the youngest snapshot
ancestor  - something like this:

 /.btrfs #  btrfsctl -l /.btrfs/
   Base path = /.btrfs/
   No.     Tree ID      Subvolume Relative Path       Snapshot Ancestor
    1          275      rootfs-old/                                  none
    2          277      rootfs/                                        
rootfs-old/
    3          279      subvol0/                                      none
    4          281      subvol0/subvol1-snap/                subvol0/
    5          280      subvol0-snap/                              subvol0/
    6          282      subvol1-snap-snap/                    
subvol0/subvol1-snap/
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #  btrfsctl -D subvol1-snap subvol0
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #  btrfsctl -l .
   Base path = /.btrfs/
   No.     Tree ID      Subvolume Relative Path    Snapshot Ancestor
    1          275      rootfs-old/                                none
    2          277      rootfs/                                      
rootfs-old/
    3          279      subvol0/                                    none
    4          280      subvol0-snap/                           subvol0/
    5          282      subvol1-snap-snap/                   subvol0/
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #  btrfsctl -D subvol0 .
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #  btrfsctl -l .
   Base path = /.btrfs/
   No.     Tree ID      Subvolume Relative Path     Snapshot Origin
    1          275      rootfs-old/                                  none
    2          277      rootfs/                                       
rootfs-old/
    3          280      subvol0-snap/                            none
    4          282      subvol1-snap-snap/                    none
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
/.btrfs #          

Thanks
Alex
