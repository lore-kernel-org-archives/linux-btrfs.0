From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 08:30:31 -0400
Message-ID: <AANLkTikJ4Du-NjvvKo3_Nn00EWUekxn7xHJ-zpGZUfio@mail.gmail.com>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Francis Galiegue <fgaliegue@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just to tell you one of my use case, I do compilations of OpenWRT on a
Btrfs filesystem, when I snapshot, I only snapshot the subvolume where
all the sources are instead of the whole root filesystem, and when I
need a snapshot of the root for backup purposes, only the root without
all the snapshot (which are used to compile for different models of
embedded devices) is snapshotted, which probably reduces the overhead
(I can't tell for sure) and makes deletion instantaneous, the cleaner
just wipes behind the subvolume remove command.

On Thu, Oct 7, 2010 at 7:39 AM, Francis Galiegue <fgaliegue@gmail.com> =
wrote:
> I have difficulties grabbing these two concepts.
>
> As far as I can tell, a snapshot is an instant, synchronized,
> photography of the filesystem at a given point in time; a subvolume i=
s
> a "subroot" to a btrfs filesystem.
>
> While I fully understand (and use) the purpose of snapshots, I don't
> quite fathom the use case for subvolumes, apart from btrfs-convert...
> Why has btrfs grown such a feature in the first place? Can someone
> give me a use case for them?
>
> --
> Francis Galiegue, fgaliegue@gmail.com
> "It seems obvious [...] that at least some 'business intelligence'
> tools invest so much intelligence on the business side that they have
> nothing left for generating SQL queries" (St=E9phane Faroult, in "The
> Art of SQL", ISBN 0-596-00894-5)
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
