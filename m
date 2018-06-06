Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbeFFMKE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 08:10:04 -0400
Date: Wed, 6 Jun 2018 14:07:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
Message-ID: <20180606120717.GE3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
 <20180605140721.GB3539@twin.jikos.cz>
 <144fe2e2-5506-6290-3f19-f1cdfba1490c@gmx.com>
 <20180605142406.GD3539@twin.jikos.cz>
 <a12decb3-6f08-91f8-cc58-e5b18b9aa520@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a12decb3-6f08-91f8-cc58-e5b18b9aa520@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 05:30:18PM +0300, Nikolay Borisov wrote:
> On  5.06.2018 17:24, David Sterba wrote:
> > On Tue, Jun 05, 2018 at 10:14:51PM +0800, Qu Wenruo wrote:
> >>> and then the whole callchain of copy_nocow_pages continues.
> >>
> >> Understood.
> >> I could go this method.
> >>
> >> However I'm a little concerned about such "if (0 &&" usage.
> >>
> >> Although with gcc 8.1 it works without any warning, it still looks
> >> pretty strange, as compiler could one day detect such dead branch and
> >> find copy_nocow_pages() is never used.
> > 
> > I've checked that this does not produce any warnings, gcc 7.3.1. The
> > condition looks strange but does what we want. The whole series will be
> > in 4.18, the first patch in stable versions. If gcc does not warn today,
> > it will not in the future in any of the versions.
> 
> WOuld it be possible to then take Qu's patch which deletes a lot of code
> for 4.19?

Of course, the deletion part will follow, we just need to split it so
the patches do not cause backporting conflicts.  Reading what I wrote
above, it's not clearl but it was the intention.
