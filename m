From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: real free space on btrfs volume (performance impact)
Date: Tue, 10 Jan 2012 12:40:03 -0600
Message-ID: <CAKcLGm9BX+QyoCj=vQyTBx_Nm=_b34J6VPHBjspfioWCPzZmFA@mail.gmail.com>
References: <4F0C4788.50806@pantheon.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Michal Suba <michal.suba@pantheon.sk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0C4788.50806@pantheon.sk>
List-ID: <linux-btrfs.vger.kernel.org>

2012/1/10 Michal Suba <michal.suba@pantheon.sk>:
> Hello
>
> =A0we are currently investigating performance issue on system runing =
above
> btrs filesystem. Is it possible, that performance is impacted by lack=
 of
> free space? Also, how to get info about real free space on btrfs volu=
me?
>
> # btrfs-show /dev/sdb1
> Label: opt =A0uuid: 28a55827-e677-47a9-98d5-d31eb3d71436
> =A0 =A0Total devices 1 FS bytes used 167.83GB
> =A0 =A0devid =A0 =A01 size 240.00GB used *229.25GB* path /dev/sdb1
>
> Btrfs Btrfs v0.19
>
> # btrfs filesystem df /opt
> Data: total=3D213.23GB, used=3D165.26GB
> System, DUP: total=3D8.00MB, used=3D40.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D8.00GB, used=3D2.57GB
>
> # df -h /opt
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/sdb1 =A0 =A0 =A0 =A0 =A0 =A0 240G =A0171G =A0 59G =A075% /opt
>
> How come that there is difference detween btrfs-show and df .. 40GB I=
s the
> space really usead or can I claim it back? (there are no snapshots)
>
> # btrfs subvolume list /opt
> #
>

The btrfs-show command is being deprecated.  It's output can be easy
to misunderstand, but it probably won't be corrected since it's going
away at some point.

Basically, what this is telling you is that 229.25GB is "committed"
(213.23GB Data + 2 x8.00GB Metadata (because it's duplicated) + 2 x
8.00MB System.

However, all the "committed" space is not being used (which is clearer
in the 'btrfs filesystem df' command).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
