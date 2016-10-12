Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:37167 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755922AbcJLT4H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 15:56:07 -0400
Date: Wed, 12 Oct 2016 21:55:28 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012195528.GB4800@angband.pl>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
 <20161012171936.GD26140@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161012171936.GD26140@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 01:19:37PM -0400, Zygo Blaxell wrote:
> On Wed, Oct 12, 2016 at 01:48:58PM +0800, Qu Wenruo wrote:
> > In fact, the _concept_ to solve such RMW behavior is quite simple:
> > 
> > Make sector size equal to stripe length. (Or vice versa if you like)
> > 
> > Although the implementation will be more complex, people like Chandan are
> > already working on sub page size sector size support.
> 
> So...metadata blocks would be 256K on the 5-disk RAID5 example above,
> and any file smaller than 256K would be stored inline?  Ouch.  That would
> also imply the compressed extent size limit (currently 128K) has to become
> much larger.
> 
> I had been thinking that we could inject "plug" extents to fill up
> RAID5 stripes.  This lets us keep the 4K block size for allocations,
> but at commit (or delalloc) time we would fill up any gaps in new RAID
> stripes to prevent them from being modified.  As the real data is deleted
> from the RAID stripes, it would be replaced by "plug" extents to keep any
> new data from being allocated in the stripe.  When the stripe consists
> entirely of "plug" extents, the plug extent would be deleted, allowing
> the stripe to be allocated again.  The "plug" data would be zero for
> the purposes of parity reconstruction, regardless of what's on the disk.
> Balance would just throw the plug extents away (no need to relocate them).

Your idea sounds good, but there's one problem: most real users don't
balance.  Ever.  Contrary to the tribal wisdom here, this actually works
fine, unless you had a pathologic load skewed to either data or metadata on
the first write then fill the disk to near-capacity with a load skewed the
other way.

Most usage patterns produce a mix of transient and persistent data (and at
write time you don't know which file is which), meaning that with time every
stripe will contain a smidge of cold data plus a fill of plug extents.

Thus, while the plug extents idea doesn't suffer from problems of big
sectors you just mentioned, we'd need some kind of auto-balance.

-- 
A MAP07 (Dead Simple) raspberry tincture recipe: 0.5l 95% alcohol, 1kg
raspberries, 0.4kg sugar; put into a big jar for 1 month.  Filter out and
throw away the fruits (can dump them into a cake, etc), let the drink age
at least 3-6 months.
