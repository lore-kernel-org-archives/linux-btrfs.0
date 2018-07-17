Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728330AbeGQNGE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 09:06:04 -0400
Date: Tue, 17 Jul 2018 14:33:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
Message-ID: <20180717123329.GX3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com>
 <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
 <20180716131622.GI3126@twin.jikos.cz>
 <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 09:57:43PM +0800, Qu Wenruo wrote:
> >>> -EUCLEAN ?
> >>
> >> Either works for me.
> > 
> > That's not just a cosmetic change, there's a semantic difference between
> > the error codes, I maybe make that more explicit and not expect that this
> > is obvious.
> > 
> > ENOENT does not make much sense in this context, the caller (mount in
> > this case) cannot do anything about a code that says 'some internal
> > structure not found'.
> 
> The point here is, if every self-checker should only return -EUCLEAN, it
> won't really indicate what's going wrong, except points to some
> self-checker (and such self-checkers are growing larger than our
> expectation already).
> 
> My practice here is, put some human readable and meaningful error
> message. No matter what we choose to return, the error message should
> tell us what's going wrong.
> 
> In this case, I don't really care the return value. If it's explicitly
> needed to return -EUCLEAN, I could make all existing checker (from
> tree-checker to chunk/bg/dev-extent checker) to return -EUCLEAN if
> anything is wrong (and save several "ret = -EUCLEAN" lines).
> The return value doesn't really have much meaning nowadays, it's the
> error message important now.

Ok, I see what you mean. The message is important as it's otherwise
almost impossible to find where exactly the mount fails.

The error messages perhaps fall into several categories:

1) transient errors, some failure that happens before the filesystem state
   is fully examined

this is namely ENOMEM, or EINTR eg. returned by kthread_run

maybe also a failure on a multi-device filesystem when the devices
haven't been scanned yet

2) clearly some corruption/consistency condtion, with enough information
   available to decide

like a missing tree, most of the tree-checker would fall into this
category

3) same as the previous one, but thre's some extenal condition preventing
   a full check

that's eg. a real EIO after reading a tree block


The error code are IMO important to see how severe the problems are and
what's the expected solution. 2 is for 'check', 3 may need degraded
mount, 1 needs maybe more time to mount again.

With the error messages in place, 2 can be completely covered by
EUCLEAN. I briefly skimmed a few call paths and think that the 3
categories should be enough, but I'm also expecting some exceptions that
can be decided case by case.

The error codes are now not consistent, lots of EUCLEAN are historically
EIO, but before we start cleaning that up we should have at least some
guidelines. Please let me know what you think.
