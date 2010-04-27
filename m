From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] btrfs, udev and btrfs
Date: Tue, 27 Apr 2010 17:32:47 +0200
Message-ID: <w2yac3eb2511004270832v7971c482s16a951db57832540@mail.gmail.com>
References: <201004162048.14463.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201004162048.14463.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 16, 2010 at 20:48, Goffredo Baroncelli <kreijack@gmail.com>=
 wrote:
> Instead the first option has the disadvantage to need to be used for =
every new
> device.
> From this observation I write a udev rule which scan the new block de=
vices,
> excluding floppy and cdrom.
>
> Below my udev rule
>
> =C2=A0$ cat /etc/udev/rules.d/60-btrfs.rules
>
> =C2=A0# ghigo 15/04/2010
>
> =C2=A0ACTION!=3D"add|change", GOTO=3D"btrfs_scan_end"
> =C2=A0SUBSYSTEM!=3D"block", GOTO=3D"btrfs_scan_end"
> =C2=A0KERNEL!=3D"sd[!0-9]*|hd[!0-9]*", GOTO=3D"btrfs_scan_end"
>
> =C2=A0IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"

Udev needs to do this already anyway. People are not encouraged to
call this in their own rule files again. Just make sure you place the
rule after the existing standard call that always comes with udev. The
btrfs rules can just depend on the variable set in the environment.
Also there are more devices than sd* which could have a btrfs volume,
but this is also covered by the standard udev call to blkid.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
