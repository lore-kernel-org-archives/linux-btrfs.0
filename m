Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19139 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751250AbbHTGDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 02:03:51 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Jonathan Panozzo'" <jonp@lime-technology.com>
CC: "'Chris Murphy'" <lists@colorremedies.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com> <CAJCQCtSVn7BSYY=Ofq6OsKfHyv_PTKGOg7uP=tUC4XTNQ42v0w@mail.gmail.com> <01e901d0dafe$0e6cbce0$2b4636a0$@cn.fujitsu.com> <540B3004-C250-4C21-9E53-C38E20258DA9@lime-technology.com>
In-Reply-To: <540B3004-C250-4C21-9E53-C38E20258DA9@lime-technology.com>
Subject: RE: Questions on use of NOCOW impact to subvolumes and snapshots
Date: Thu, 20 Aug 2015 14:03:05 +0800
Message-ID: <020401d0db0d$e1accb40$a50661c0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Jonathan Panozzo

> -----Original Message-----
> From: Jonathan Panozzo [mailto:jonp@lime-technology.com]
> Sent: Thursday, August 20, 2015 12:41 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: Chris Murphy <lists@colorremedies.com>; Btrfs BTRFS
> <linux-btrfs@vger.kernel.org>
> Subject: Re: Questions on use of NOCOW impact to subvolumes and snapshots
> 
> Zhao,
> 
> Thank you for your response.  Two quick follow-up questions:
> 
> 1:  What happens on an unrecoverable data error case?  Does the volume
> get put into read-only mode?
> 
Only report some information as: "recover failed".

> 2:  Out of curiosity, why is data checksumming tied to COW?
> 
To ensure that the checksum for data is either valid or not exist.

Thanks
Zhaolei

> - Jon
> 
> > On Aug 19, 2015, at 11:09 PM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> >
> > Hi, Jonathan Panozzo,
> >
> >> -----Original Message-----
> >> From: linux-btrfs-owner@vger.kernel.org
> >> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Chris Murphy
> >> Sent: Thursday, August 20, 2015 9:56 AM
> >> To: Jonathan Panozzo <jonp@lime-technology.com>; Btrfs BTRFS
> >> <linux-btrfs@vger.kernel.org>
> >> Subject: Re: Questions on use of NOCOW impact to subvolumes and
> >> snapshots
> >>
> >> On Wed, Aug 19, 2015 at 6:44 PM, Jonathan Panozzo
> >> <jonp@lime-technology.com> wrote:
> >>> Hello btrfs mailing list!
> >>>
> >>> I have a two questions regarding the use of the NOCOW bit and how
> >>> this
> >> affects scrub and snapshots.
> >>>
> >>> Question 1:  If I apply the NOCOW attribute to a file or directory,
> >>> how does
> >> that affect my ability to run btrfs scrub?
> >>
> >> nodatacow includes nodatasum and no compression. So it means these
> >> files are presently immune from scrub check and repair so long as
> >> it's based on checksums.
> >>
> > In nodatasum case, scrub only try to fix data with io-error.
> >
> >> I don't know if raid56 scrub compares to parity and recomputes parity
> >> (assumes data is correct), absent checksums, which would be similar
> >> to how md raid 56 does it.
> >>
> > For raid56 with no datasum, in current code:
> > For data strip: If have io error: try to get right data from parity,
> > and writeback For parity strip: check is the parity match data, and
> > try to recovery
> >
> > Thanks
> > Zhaolei
> >
> >>
> >>> Question 2:  If I apply the NOCOW attribute recursively to a btrfs
> >>> subvolume I create,
> >>
> >> There's no such thing as recursive application of this xattr to files.
> >> Recursivity would only apply to directories (and probably nested
> >> subvolumes but I haven't tested it).
> >>
> >>
> >>> then take a snapshot of that subvolume, make changes to the files in
> >>> the
> >> snapshot, and then make changes to the files in the subvolume, does
> >> this cause data in the snapshot to be corrupted?  It doesn’t appear
> >> so, but I’m confused how it’s not if COW has been disabled using the
> NOCOW bit.
> >>
> >> http://www.spinics.net/lists/linux-btrfs/msg31342.html
> >>
> >> Any changes to a snapshot nocow file are cow. Any additional changes
> >> to those extents are nocow until those extents are likewise snapshot
> >> (by the file being reflink copied or subvolume is snapshot). So if
> >> the change to an extent will only affect a particular instance of a
> >> nocow file, the write is overwrite (nocow). If it's a shared extent,
> >> then the write is cow, and that extent is (initially) not shared and thus
> additional writes are nocow.
> >>
> >>
> >> --
> >> Chris Murphy
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

