From: cwillu <cwillu@cwillu.com>
Subject: Re: real free space on btrfs volume (performance impact)
Date: Tue, 10 Jan 2012 12:54:16 -0600
Message-ID: <CAE5mzvivL6NUVB5ARhWBLZrhBU_Yqf=h0+zXMPzYwHc6K+1V7A@mail.gmail.com>
References: <4F0C4788.50806@pantheon.sk>
	<CAKcLGm9BX+QyoCj=vQyTBx_Nm=_b34J6VPHBjspfioWCPzZmFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Michal Suba <michal.suba@pantheon.sk>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm9BX+QyoCj=vQyTBx_Nm=_b34J6VPHBjspfioWCPzZmFA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2012 at 12:40 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> 2012/1/10 Michal Suba <michal.suba@pantheon.sk>:
>> Hello
>>
>> =C2=A0we are currently investigating performance issue on system run=
ing above
>> btrs filesystem. Is it possible, that performance is impacted by lac=
k of
>> free space? Also, how to get info about real free space on btrfs vol=
ume?
>>
>> # btrfs-show /dev/sdb1
>> Label: opt =C2=A0uuid: 28a55827-e677-47a9-98d5-d31eb3d71436
>> =C2=A0 =C2=A0Total devices 1 FS bytes used 167.83GB
>> =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 240.00GB used *229.25GB* path=
 /dev/sdb1
>>
>> Btrfs Btrfs v0.19
>>
>> # btrfs filesystem df /opt
>> Data: total=3D213.23GB, used=3D165.26GB
>> System, DUP: total=3D8.00MB, used=3D40.00KB
>> System: total=3D4.00MB, used=3D0.00
>> Metadata, DUP: total=3D8.00GB, used=3D2.57GB
>>
>> # df -h /opt
>> Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Size =C2=A0Used =
Avail Use% Mounted on
>> /dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 240G =C2=A0171G =
=C2=A0 59G =C2=A075% /opt
>>
>> How come that there is difference detween btrfs-show and df .. 40GB =
Is the
>> space really usead or can I claim it back? (there are no snapshots)
>>
>> # btrfs subvolume list /opt
>> #
>>
>
> The btrfs-show command is being deprecated. =C2=A0It's output can be =
easy
> to misunderstand, but it probably won't be corrected since it's going
> away at some point.

The output of "btrfs fi show /dev/whatever" is identical, and isn't
going away afaik.  That said, it is easy to misinterpret, although
that's probably unavoidable while still actually presenting that
information.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
