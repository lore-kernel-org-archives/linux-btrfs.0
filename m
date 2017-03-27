Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38931 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbdC0R4T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:56:19 -0400
Date: Mon, 27 Mar 2017 19:55:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/7] convert: rollback rework
Message-ID: <20170327175525.GS4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
 <20170314115506.GT14605@twin.jikos.cz>
 <20170314115554.GU14605@twin.jikos.cz>
 <01347a96-33eb-f028-fb09-08f44fdfc945@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01347a96-33eb-f028-fb09-08f44fdfc945@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 08:35:06AM +0800, Qu Wenruo wrote:
> At 03/14/2017 07:55 PM, David Sterba wrote:
> > On Tue, Mar 14, 2017 at 12:55:06PM +0100, David Sterba wrote:
> >> On Tue, Mar 14, 2017 at 04:05:02PM +0800, Qu Wenruo wrote:
> >>> v2:
> >>>   Abstract the original code to read out data in one btrfs file to
> >>>   btrfs_read_file().
> >>>   Use simple_range and btrfs_reserved_ranges[] to cleanup open code.
> >>> v3:
> >>>   Rebased to v4.10.
> >>>   Squash modification in later commits to their previous owner.
> >>>   Fix a converity report, which doesn't exit when an error is found in
> >>>   check_convert_image()
> >>>   Fix a lot of check scripts warning
> >>
> >> I did not mention that explicitly under v2, but the series has been
> >> merged to devel so incremental changes should be sent from now on.
> 
> Sorry, but IIRC it's recommended to base the code to latest 
> stable/release branch, so I rebase them all to v4.10 code base.

This applies to unmerged patchsets. Once it's in devel I do not intend
to remove it (unless there's something serious).

> (Last time you said basing code upon devel is quite a bad behavior and 
> makes merging painful)

This depends if your patchset builds on top of any changes in devel or
not. If not, any base branch should do (master, or devel). Moving a
patchset based on devel to a new rebased devel head is something I do
regularly. I do occasinally want to rebase devel, so the patch history
stays clean and we don't pile up fixups on fixups. What is not a good
practice is basing patchset on a 'next' branch of any sort. This usually
serves as a preview and any patch can disappear between two next
snapshots.

> And yes, it's quite a pain to rebase them. I totally understand the pain 
> during the v4.9.1->v4.10 rebase.
> 
> >> I
> >> went through the patches almost line by line and fixed things here and
> >> there. The patchset-to-patchset diff is not large (attached).
> 
> Sorry for the trouble and thanks for the effort.
> 
> But I'm afraid it may still happen time by time.

Of course, that's expected.

> As you already see, we have several pending big patchset for btrfs-progs.
> (Lowmem mode repair, offline scrub, and maybe some other things)
> 
> So to save your time, could you info us before merging large patchset 

If only I knew that myself :) but I'll try.

> and provide a base commit for us to rebase for you?

For big or intrusive patchsets it should be better to start on top of
master, as it's never rebased. Sometimes rebasing on top of devel
succeeds with minor conflicts, that's more like a bonus for the next
cycle if the patchset does not get merged.
