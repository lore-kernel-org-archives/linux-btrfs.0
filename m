From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs-progs: new integration branch out
Date: Wed, 12 Oct 2011 23:52:35 +0700
Message-ID: <CAG1y0scXYR65qUVN1wkRYpUMV1E7DC=Kbf31L2hA-uWGN+BqaQ@mail.gmail.com>
References: <20111012123411.GC21931@carfax.org.uk>
	<CAG1y0sdm17RGcqVRakE6355iicsSmQ9vF23Kw9h5jm+7C22Fyw@mail.gmail.com>
	<CAKcLGm_KAaumCLY+aO4suh=J6tcY85ktSMhAxq+av0G1gDw6+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_KAaumCLY+aO4suh=J6tcY85ktSMhAxq+av0G1gDw6+w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 11:50 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Wed, Oct 12, 2011 at 10:22 AM, Fajar A. Nugraha <list@fajar.net> w=
rote:

>> I noticed that "btrfs subvolume snapshot" is now broken. It keeps on
>> saying "Invalid arguments for subvolume snapshot".
>>
>> Further checking shows it's caused by
>>
>> commit f71210f87e0c684d8c76dfa2e19ea86256fc3d1f
>> Author: Andreas Philipp <philipp.andreas@gmail.com>
>> Date: =A0 Thu Aug 11 08:45:40 2011 +0200
>>
>> =A0 =A0check number of args for btrfs sub snap correctly

>
> It looks like there have been two patches that touched on this issue,
> and they conflicted with one-another.
>
> Arne Jansen's "btrfs-progs: add qgroup commands" patch added a "optin=
d
> =3D 1;" line, where optind was defaulting to zero before.
>
> This conflicted with Hugo Mills"fix incorrect argument checking for
> "btrfs sub snap -r"" patch.
>
> So it looks like "(argc - optind !=3D 2)" is now correct.
>

Ah, that explains it then. Thanks.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
