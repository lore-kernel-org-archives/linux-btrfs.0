From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: btrfsck: unresolved ref root
Date: Fri, 2 Dec 2011 18:13:51 +0400
Message-ID: <CANvN+emO8sfR+ETOYXWXKQA_e=0_zYTTJo=sg+tVX5G9axmy1A@mail.gmail.com>
References: <4ED89A25.4000207@jan-o-sch.net> <CANvN+enynzy=y3-vXDNHB4oFBjBZOTxwx9AvB+suoRkCsDwcwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANvN+enynzy=y3-vXDNHB4oFBjBZOTxwx9AvB+suoRkCsDwcwQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just curious, would the observed behavior change if one modifies head i=
n any
way between snap and umount?

Regards,
Andrey

>
> 02.12.2011 13:28 =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=
=D0=B5=D0=BB=D1=8C "Jan Schmidt" <list.btrfs@jan-o-sch.net>
> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
>
>
> While hunting another bug, I got distracted by btrfsck error output,
> which is reproducible as simple as creating a snapshot. Either btrfsc=
k
> is strange or subvolume snapsnot does something wrong.
>
> # mkfs.btrfs /dev/sdo
> # mount /dev/sdo /mnt/scratch/
> # umount /mnt/scratch/
> # btrfsck /dev/sdo
>
> -> everything ok
>
> # mount /dev/sdo /mnt/scratch/
> # btrfs subvol snap /mnt/scratch/ /mnt/scratch/snap1
> # umount /mnt/scratch
> # btrfsck /dev/sdo
> fs tree 257 refs 2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unresolved ref root 257 dir 256 index 2 na=
melen 5 name snap1
> error 600
> [...]
>
> Tested with current for-linus and most current btrfsck. I also have
> older filesystems with snapshots I never used on btrfsck before, they
> also show the "unresolved ref" error.
>
> From a quick look at the btrfsck code, this complaint means that btrf=
sck
> is looking for two BTRFS_ROOT_REF_KEY and BTRFS_ROOT_BACKREF_KEY each=
 in
> the tree of tree roots. However there's only one of each (as I would
> expect):
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0item 4 key (FS_TREE ROOT_REF 257) itemoff =
3238 itemsize 23
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0root ref key d=
irid 256 sequence 2 name snap1
> ...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0item 12 key (257 ROOT_BACKREF 5) itemoff 2=
315 itemsize 23
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0root backref k=
ey dirid 256 sequence 2 name snap1
>
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
