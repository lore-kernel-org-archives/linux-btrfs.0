From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Btrfs and raw zvol-like partition
Date: Sun, 12 Apr 2009 17:13:47 +0400
Message-ID: <2a31deca0904120613s56d8570pc1403284afcac094@mail.gmail.com>
References: <49E197BC.40703@enix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: sw@enix.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49E197BC.40703@enix.org>
List-ID: <linux-btrfs.vger.kernel.org>

zvol (interface) does not just  'export raw device' but rather
implements volume  abstraction and integrates volume management into
file-system.

Regards,
Andrey



On Sun, Apr 12, 2009 at 11:26 AM, S=C3=A9bastien Wacquiez <sw@enix.org>=
 wrote:
> Hi,
>
> A nice feature is ZFS is the "ZVOL" layer, that permit you to export
> (directly) a raw device from your zfs pool of disc, with the benefit =
of
> powerful (growing!) snapshot and easy raid management from zfs. It's
> particulary usefull when you use it with virtual server, allowing you=
 to
> centralize all your backup problematic, etc
>
> Does btrfs plan to support this kind of feature ? (please, don't tell=
 me
> that lvm do, lvm just sucks when you make a snapshot of your disk, an=
d lack
> of the "growing", commit, rollback, diffsend feature).
>
> Thanks !
>
>
> S=C3=A9bastien Wacquiez
>
> PS : see http://opensolaris.org/os/community/zfs/source/zfstour.png i=
f you
> don't know what zvol do.
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
