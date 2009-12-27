From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: btrfs-progs: New utility to swap subvolumes
Date: Sun, 27 Dec 2009 21:23:37 +0100
Message-ID: <200912272123.37585.kreijack@alice.it>
References: <4B32CF4D.90406@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Cc: linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B32CF4D.90406@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 24 December 2009, TARUISI Hiroaki wrote:
> New utility(btrfsrevert) added to swap subvolumes.
> 
> With this utility, a subvolume (Source Subvolume) takes place of
> another subvolume (Target Subvolume), and target subvolume goes
> under hidden directory(".old_trees") in filesystem root(fs tree,
> tree id=5), and its name is expanded with random UUID.


Hi Taruisi,

which is the supposed goal of this program ? If I understand correctly 
"btrfsrevert" renames subvolumes. But we can rename a subvolume using the mv 
command. So "btrfsrevert" may be simulated with a couple of 'mv' command:

# btrfsrevert -s vola-id -t volb-id /dev/sdX

is equivalent to

# mount /dev/sdX/ /mnt  	# only needed if the filesystem is un-mounted
# mkdir /mnt/.old_trees
# mv /mnt/volb /mnt/.old_trees/volb.<random-number>
# mv /mnt/vola /mnt/volb
# umount /mnt               

Is right ? And moreover btrfsrevert has the limit that the file-system shall 
not be mounted...

On the plus side of btrfsrevert, I can "swap" volumes without having the btrfs 
module loaded ...


BR
G.Baroncelli

> 
> This utility cannot operate mounted filesystem. This is only for
> unmounted device.
> And this utility also cannot operate filesystem root. For now,
> if we want to swap filesystem root, we can use btrfsctl with
> Josef Bacik's patch. I wonder which is better, integrating 'root swap'
> ioctl or not supporting 'root swap' as for this utility...
> 
> A patch follows this mail.
> 
> 
> man-page-like description and examples are as follows.
> 
> NAME
>        btrfsrevert - swap subvolumes.
> 
> SYNOPSIS
>        btrfsrevert -s source_subvolume -t target_subvolume device
> 
> OPTIONS
>        -s source subvolume
>             Specify subvolume number which replace target
>             subvolume.
>        -t target subvolume
>             Specify subvolume number which is replaced by
>             source subvolume.
> 
>        device
>             Specify target device which is not mounted.
> 
> SAMPLES
>        Consider two subvolumes 'target'(id=256) and 'source'(id=300)
>        exist in filesystem root.
>            / +
>              +- 'target' (id=256)
>              +- 'source' (id=300)
> 
>        In this case, following command swaps subvolume,
> 
>           # btrfsrevert -s 300 -t 256 /dev/hda1
> 
>        like this.
>            / +
>              +- 'target' (id=300)
>              |
>              +- '.old_tree'
>                  +- 'target_[random uuid]' (id=256)
> 
>             A subvolume(id:256) is replaced with a subvolume(id:300),
>             and replaced subvolume(id:256) goes to .old_trees directory.
> 
> Regards,
> taruisi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
