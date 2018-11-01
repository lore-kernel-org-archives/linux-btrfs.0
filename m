Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0F5C6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A0882081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A0882081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbeKBAcW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:32:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:46600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727950AbeKBAcW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 20:32:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51258AC90;
        Thu,  1 Nov 2018 15:28:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A7906DAAFC; Thu,  1 Nov 2018 16:28:17 +0100 (CET)
Date:   Thu, 1 Nov 2018 16:28:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181101152817.GO9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz>
 <20181101152317.GA18005@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101152317.GA18005@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 08:23:17AM -0700, Omar Sandoval wrote:
> On Thu, Nov 01, 2018 at 04:08:32PM +0100, David Sterba wrote:
> > On Thu, Nov 01, 2018 at 01:31:18PM +0000, Chris Mason wrote:
> > > On 1 Nov 2018, at 6:15, David Sterba wrote:
> > > 
> > > > On Wed, Oct 31, 2018 at 10:06:08AM -0700, Omar Sandoval wrote:
> > > >> From: Omar Sandoval <osandov@fb.com>
> > > >>
> > > >> There's a race between close_ctree() and cleaner_kthread().
> > > >> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> > > >> sees it set, but this is racy; the cleaner might have already checked
> > > >> the bit and could be cleaning stuff. In particular, if it deletes 
> > > >> unused
> > > >> block groups, it will create delayed iputs for the free space cache
> > > >> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> > > >> longer running delayed iputs after a commit. Therefore, if the 
> > > >> cleaner
> > > >> creates more delayed iputs after delayed iputs are run in
> > > >> btrfs_commit_super(), we will leak inodes on unmount and get a busy
> > > >> inode crash from the VFS.
> > > >>
> > > >> Fix it by parking the cleaner
> > > >
> > > > Ouch, that's IMO wrong way to fix it. The bug is on a higher level,
> > > > we're missing a commit or clean up data structures. Messing with state
> > > > of a thread would be the last thing I'd try after proving that it's 
> > > > not
> > > > possible to fix in the logic of btrfs itself.
> > > >
> > > > The shutdown sequence in close_tree is quite tricky and we've had bugs
> > > > there. The interdependencies of thread and data structures and other
> > > > subsystems cannot have loops that could not find an ordering that will
> > > > not leak something.
> > > >
> > > > It's not a big problem if some step is done more than once, like
> > > > committing or cleaning up some other structures if we know that
> > > > it could create new.
> > > 
> > > The problem is the cleaner thread needs to be told to stop doing new 
> > > work, and we need to wait for the work it's already doing to be 
> > > finished.  We're getting "stop doing new work" already because the 
> > > cleaner thread checks to see if the FS is closing, but we don't have a 
> > > way today to wait for him to finish what he's already doing.
> > > 
> > > kthread_park() is basically the same as adding another mutex or 
> > > synchronization point.  I'm not sure how we could change close_tree() or 
> > > the final commit to pick this up more effectively?
> > 
> > The idea is:
> > 
> > cleaner                                     close_ctree thread
> > 
> >                                             tell cleaner to stop
> > 					    wait
> > start work
> > if should_stop, then exit
> >                                             cleaner is stopped
> > 
> > [does not run: finish work]
> > [does not run: loop]
> >                                             pick up the work or make
> > 					    sure there's nothing in
> > 					    progress anymore
> > 
> > 
> > A simplified version in code:
> > 
> >   set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
> > 
> >   wait for defrag - could be started from cleaner but next iteration will
> > 		    see the fs closed and will not continue
> > 
> >   kthread_stop(transaction_kthread)
> > 
> >   kthread_stop(cleaner_kthread)
> > 
> >   /* next, everything that could be left from cleaner should be finished */
> > 
> >   btrfs_delete_unused_bgs();
> >   assert there are no defrags
> >   assert there are no delayed iputs
> >   commit if necessary
> > 
> > IOW the unused block groups are removed from close_ctree too early,
> > moving that after the threads stop AND makins sure that it does not need
> > either of them should work.
> > 
> > The "AND" above is not currently implemented as btrfs_delete_unused_bgs
> > calls plain btrfs_end_transaction that wakes up transaction ktread, so
> > there would need to be an argument passed to tell it to do full commit.
> 
> It's too fragile to run around in the filesystem with these threads
> freed. We can probably make it now, but I'm worried that we'll add
> another wakeup somewhere and blow up.

So functions that are called from close_ctree will be careful to either
not wake up or check before trying to wake them up. We can also wrap the
wakeups like

wake_up_cleaner(fs_info) {
	if (!fs_info->state & CLOSING)
		wake_up_process(cleaner_kthread)
	else
		BUG_ON
}

Same for kthread.
