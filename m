Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35066 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbcAXADQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 19:03:16 -0500
Received: by mail-io0-f170.google.com with SMTP id 77so120993474ioc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 16:03:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160123214127.GA601@fox.wireless.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
	<pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
	<20160123214127.GA601@fox.wireless.rit.edu>
Date: Sat, 23 Jan 2016 17:03:15 -0700
Message-ID: <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 23, 2016 at 2:41 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> On Fri, Jan 22, 2016 at 10:54:58AM +0000, Duncan wrote:
>> And since you do have the raid1 creation kernel info there too, I can
>> tell you that yes, a number of filesystem features are now default that
>> weren't, back on kernel 3.10, including I believe 16k node size (the
>> default back then was 4k, tho 16k was an available option, just not the
>> default).  I'm quite sure that was before skinny metadata by default, as
>> well.  Whether the newer features are worth the additional hassle of
>> doing the new mkfs.btrfs and copy, as opposed to the more straightforward
>> btrfs replace, is up to you, but yes, the defaults are slightly different
>> now, so you have that additional information to consider when choosing
>> your upgrade method. =:^)
>
> Thanks Duncan, Austin, and Chris. I think my plan is going to be to do
> btrfs replace on the disks, and try to enable skinny extents with
> btrfstune. I'm not really concerned about the node size, as from what I
> can tell it's just a slight performance bump.
>
> Question about btrfstune: It seems to only operate on unmounted
> partitions. If I want to enable skinny extents on my raid1, do I need to
> run btrfstune on both drives, or just one?

Just one, it would be applied to the whole fs.

> And I'm assuming it will just
> apply to newly-allocated extents, so I should enable it before I start
> the replace, correct?

I do not expect replication to change the extent format. The replace
(or add then delete) operation isn't allocating new extents, it's just
copying them as-is in the chunks that contain them. So I don't think
it matters when you do it.

Just make sure you have backups before, during, and after all of this,
which should be the case no matter Btrfs or not. Mixed extent types
should work fine, but who knows you could get into an edge case at a
later time for all anyone knows. Looks like skinny extent became
default in btrfs-progs 3.18.

-- 
Chris Murphy
