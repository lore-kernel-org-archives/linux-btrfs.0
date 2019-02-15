Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F1CC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 23:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0C0920836
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 23:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394163AbfBOXLO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 18:11:14 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48168 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389943AbfBOXLO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 18:11:14 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id CEAD022175D; Fri, 15 Feb 2019 18:11:12 -0500 (EST)
Date:   Fri, 15 Feb 2019 18:11:10 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     Brian B <brian@sd85.net>, linux-btrfs@vger.kernel.org
Subject: Re: Better distribution of RAID1 data?
Message-ID: <20190215231026.GE9995@hungrycats.org>
References: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
 <91c2c290-5796-3f18-804e-0c19ae17f1db@gmail.com>
 <20190215195035.GD9995@hungrycats.org>
 <43af782e-4648-5758-9e3f-9e94e81310f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <43af782e-4648-5758-9e3f-9e94e81310f3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 02:55:13PM -0500, Austin S. Hemmelgarn wrote:
> On 2019-02-15 14:50, Zygo Blaxell wrote:
> > On Fri, Feb 15, 2019 at 11:54:57AM -0500, Austin S. Hemmelgarn wrote:
> > > On 2019-02-15 10:40, Brian B wrote:
> > > > It looks like the btrfs code currently uses the total space available on
> > > > a disk to determine where it should place the two copies of a file in
> > > > RAID1 mode.  Wouldn't it make more sense to use the _percentage_ of free
> > > > space instead of the number of free bytes?
> > > > 
> > > > For example, I have two disks in my array that are 8 TB, plus an
> > > > assortment of 3,4, and 1 TB disks.  With the current allocation code,
> > > > btrfs will use my two 8 TB drives exclusively until I've written 4 TB of
> > > > files, then it will start using the 4 TB disks, then eventually the 3,
> > > > and finally the 1 TB disks.  If the code used a percentage figure
> > > > instead, it would spread the allocations much more evenly across the
> > > > drives, ideally spreading load and reducing drive wear.
> > 
> > Spreading load should make all the drives wear at the same rate (or a rate
> > proportional to size).  That would be a gain for the big disks but a
> > loss for the smaller ones.
> > 
> > > > Is there a reason this is done this way, or is it just something that
> > > > hasn't had time for development?
> > > It's simple to implement, easy to verify, runs fast, produces optimal or
> > > near optimal space usage in pretty much all cases, and is highly
> > > deterministic.
> > > 
> > > Using percentages reduces the simplicity, ease of verification, and speed
> > > (division is still slow on most CPU's, and you need division for
> > > percentages), and is likely to not be as deterministic (both because the
> > 
> > A few integer divides _per GB of writes_ is not going to matter.
> > raid5 profile does a 64-bit modulus operation on every stripe to locate
> > parity blocks.
> It really depends on the system in question, and division is just the _easy_
> bit to point at being slower.  Doing this right will likely need FP work,
> which would make chunk allocations rather painfully slow.

It still doesn't matter.  Chunk allocations don't happen very often,
so anything faster than an Arduino should be able to keep up.
You could spend milliseconds on each one (and probably do, just for
the IO required to update the device/block group trees).
