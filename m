From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Btrfs and raw zvol-like partition
Date: Sun, 12 Apr 2009 23:54:53 +0400
Message-ID: <2a31deca0904121254h45d602f2u9a0a9f789b42be0f@mail.gmail.com>
References: <49E197BC.40703@enix.org> <2a31deca0904120613s56d8570pc1403284afcac094@mail.gmail.com>
	<49E233BD.8050700@enix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: sw@enix.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49E233BD.8050700@enix.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 12, 2009 at 10:32 PM, S=C3=A9bastien Wacquiez <sw@enix.org>=
 wrote:
> Andrey Kuzmin a =C3=A9crit :
>>
>> zvol (interface) does not just =C2=A0'export raw device' but rather
>> implements volume =C2=A0abstraction and integrates volume management=
 into
>> file-system.
>>
>
> Yep. I suck at writing english, thanks for pointing that out :)
>
> I surely mislead myself, but I think that the "volume management" of =
ZFS
> could be done with file.

Basically volume abstraction aims to provide a layer above raw device
implementing extra functionality not found with raw disk (e.g.,
fault-tolerance), expandability (one can add disks to a volume as
needed) and single point of control over a bunch of disks.

>
> Alloc on write ? Use sparse file. Resizing ? Append or truncate the f=
ile.
> Snapshot ? Snapshot the file. Another Volume ? An other file :)

Basically you're right and, for instance, (deprecated) opensolaris
user-spce iSCSI target supports exporting a regular zfs file to remote
clients as raw scsi block device. At the same time,  implementing a
'volume' on-top of a regular zfs file might be unsafe (file-system
makes some assumptions wrt I/O that are fine with raw devices below
real volume but do not necessarily hold for a regular file) .

>
> In fact, the two thinks that have to be done, for me, is :
> 1/ Optimise the different layer to bypass permission, acl, & co, and =
surely
> the way data is written.
> 2/ Be able to export those file directly as block device. (Allowing s=
ome
> more optimisation :) )
>
> It's why I called this feature "export raw device" (as in "export raw=
 file
> as block device"). As I say, it could be emulated with file and loopb=
ack,
> but it'll surely be slow ... So I wanna know if btrfs plan to have th=
ose
> type of optimization (and the user land tools to simplify it's manage=
ment).
>

That's a question to linux-btrfs@, I'm quite new to this one.

Regards,
Andrey
>
> Regards,
>
>
> S=C3=A9bastien Wacquiez
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
