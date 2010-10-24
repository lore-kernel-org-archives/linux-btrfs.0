From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Determine if a given fs is a btrfs fs
Date: Sun, 24 Oct 2010 17:32:39 -0400
Message-ID: <AANLkTikB06jNR-QmkXjWWFE6fO=cTZvEDFbY5V98Pu6g@mail.gmail.com>
References: <20101024202410.GA2830@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101024202410.GA2830@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

Here are some cues...
p4 jerome # file -s /dev/mapper/vgP4RAID5-openwrt
/dev/mapper/vgP4RAID5-openwrt: symbolic link to `../dm-22'
p4 jerome # file -s /dev/dm-22
/dev/dm-22: BTRFS Filesystem (label "p4-openwrt", sectorsize 4096,
nodesize 4096, leafsize 4096)
p4 jerome # btrfs device scan /dev/dm-22
Scanning for Btrfs filesystems in '/dev/dm-22'
p4 jerome # echo $?
0
p4 jerome # btrfs device scan /dev/sda
Scanning for Btrfs filesystems in '/dev/sda'
ERROR: unable to scan the device '/dev/sda'
p4 jerome # echo $?
11
p4 jerome # blkid | grep btrfs
/dev/mapper/vgP4RAID5-openwrt: LABEL=3D"p4-openwrt"
UUID=3D"9a68f4cc-4bda-4cdb-9726-481b340f742c"
UUID_SUB=3D"37bfc8b8-c8aa-415e-bbb3-cbb50cca2ab7" TYPE=3D"btrfs"
p4 jerome #


On Sun, Oct 24, 2010 at 4:24 PM, Felix Blanke <felixblanke@gmail.com> w=
rote:
> Hi,
>
> I've some btrfs fs which are encrypted with loopaes.
>
> I decrypt them in a script during bootup. Now I want to determine if =
the decrypted fs
> is a btrfs fs. If not I missspelled the password and I can handle tha=
t error in my
> script.
>
>
> Thanks for any help!
>
>
> Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
