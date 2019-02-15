Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6058FC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A258222D0
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731567AbfBOTup convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:50:45 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33046 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbfBOTup (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 14:50:45 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 4E3EA221178; Fri, 15 Feb 2019 14:50:44 -0500 (EST)
Date:   Fri, 15 Feb 2019 14:50:43 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     Brian B <brian@sd85.net>, linux-btrfs@vger.kernel.org
Subject: Re: Better distribution of RAID1 data?
Message-ID: <20190215195035.GD9995@hungrycats.org>
References: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
 <91c2c290-5796-3f18-804e-0c19ae17f1db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <91c2c290-5796-3f18-804e-0c19ae17f1db@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 11:54:57AM -0500, Austin S. Hemmelgarn wrote:
> On 2019-02-15 10:40, Brian B wrote:
> > It looks like the btrfs code currently uses the total space available on
> > a disk to determine where it should place the two copies of a file in
> > RAID1 mode.  Wouldn't it make more sense to use the _percentage_ of free
> > space instead of the number of free bytes?
> > 
> > For example, I have two disks in my array that are 8 TB, plus an
> > assortment of 3,4, and 1 TB disks.  With the current allocation code,
> > btrfs will use my two 8 TB drives exclusively until I've written 4 TB of
> > files, then it will start using the 4 TB disks, then eventually the 3,
> > and finally the 1 TB disks.  If the code used a percentage figure
> > instead, it would spread the allocations much more evenly across the
> > drives, ideally spreading load and reducing drive wear.

Spreading load should make all the drives wear at the same rate (or a rate
proportional to size).  That would be a gain for the big disks but a
loss for the smaller ones.

> > Is there a reason this is done this way, or is it just something that
> > hasn't had time for development?
> It's simple to implement, easy to verify, runs fast, produces optimal or
> near optimal space usage in pretty much all cases, and is highly
> deterministic.
> 
> Using percentages reduces the simplicity, ease of verification, and speed
> (division is still slow on most CPU's, and you need division for
> percentages), and is likely to not be as deterministic (both because the

A few integer divides _per GB of writes_ is not going to matter.
raid5 profile does a 64-bit modulus operation on every stripe to locate
parity blocks.

> choice of first devices is harder when all are 100% empty, and because of
> potential rounding errors), and probably won't produce optimal layouts quite
> as reliably (you either need to get into floating-point math (which is to be
> avoided in the kernel whenever possible), or you end up with much more
> quantized disk selection).
> 
> I could see an adapted percentage method that preferentially spreads across
> disks whenever possible _possibly_ making sense once we can properly
> parallelize disk access in BTRFS, but until then I see no reason to change
> something that is already working reasonably well.
> 
> In your particular case, I'd actually suggest using something under BTRFS to
> merge the smaller disks to get as many devices as close to 8TB as possible.
> That should help spread load better.

That would change the distribution of risk.  The aggregated small disks
would have a higher failure rate (because they don't have redundancy and
there are more active components to fail) than the individual big drives.

Brian can go the other way:  use 'btrfs fi resize' to limit the size of
the large disks to match the size of the smaller disks, then resize the
bigger disks to the next size tier as the smaller disks become full.

I'm not sure _why_ you'd want to do this, though.  The practical gains on
any metric that I know of would be negligible.  Once there's enough data
on the filesystem, IO would be roughly distributed according to device
size no matter how the data was arranged.  In any case, you can easily
experiment with this now, and show us data to support your theory.  ;)

There is a possible gain on metadata placement (i.e. try to put metadata
on small SSDs while the data goes on big HDDs), but once the disks reach
equilibrium, metadata placement would revert to random.  If you want to
place metadata on SSD then it would be better to modify the code to do
that explicitly.
