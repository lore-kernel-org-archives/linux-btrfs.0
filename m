Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F44FC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 189202081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="LCMyg8ja"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 189202081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbeKBAcN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:32:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36137 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbeKBAcM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2018 20:32:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24-v6so895793plq.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 08:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G+ZupBhHO0hyHApMkIMy2BQbT3gaLKIl0KCx2uAPDeY=;
        b=LCMyg8jaNJ7N9yAZod7K/rQQR/5HebSACJGKSklD1/hIrwB77lDvxUbMFcjvl12yZy
         gBA1P6czjm7odkCJ28FoQ1mnCz958jsZ0UKj7cb7Hj6il2MBXjBh8OM4mLNlGzSQqNDu
         dYk+pxNgC2fsxMA/qS7F1sJdBgkCep+kVm6//vqDe3JTdgEbl0cXP2qowVYdte6p7CMp
         FNQxJH8oV863FJv/+6um8ObgsYAky8o10CyOosOX6SGDdin6SsDu/OpSaNJcQLB9Mo5m
         hM6GgOfyBe0/2SGWujF0vuayAOg7cEQ+whT/qx0kypTXeZPB735JzR92FvCsovc+2kCe
         sWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G+ZupBhHO0hyHApMkIMy2BQbT3gaLKIl0KCx2uAPDeY=;
        b=BwvUIzjhngCRSgGUTQKhk6Zsl3u2rOr7xWEGGFJ/o4C2tGYXbr+wsuK9LApcGUU54j
         dxdGn/qVWeli1K6JwTYUZkNoHVS3g9Hb2qz+BzusI7H3hxvSMgKPTt7nYt6bNOz01k9Y
         raHghNw2qnp/mJaxxg1iOF2j6jFgTtWMa293XSkkeR2ybUW+cROp1ulMJt1aEjV7XowY
         SFEPAzNikogQAC13rbvj2mRwav6HfZC4ZQb4TjkhgkQ6gdvDUTg4bXnOFSO0AU5mKv2t
         rtwQb+INZJQjBerw/hbVbkhn6glKAk6E74Vm+M1Q19Hu54m2+R5hWdcpQfzRlhYHJ+AN
         BsBw==
X-Gm-Message-State: AGRZ1gKGDS9PJqAirPmYz2rpwjf0P3dCzc3waEaPrZyVNixr3l7Rhvfp
        gA3Zfsj8UoYi6TLvR/DaMADpwQ==
X-Google-Smtp-Source: AJdET5eyx6Tkfzykq9XxzR5Vl1JfKzzaMpsvsrJmbGYy66PQ78MrajT2LQtXZBlPXvEUaSdbGr0sqA==
X-Received: by 2002:a17:902:ac86:: with SMTP id h6-v6mr7890108plr.174.1541086126003;
        Thu, 01 Nov 2018 08:28:46 -0700 (PDT)
Received: from vader ([2601:602:8800:a9a9:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id v4-v6sm2266946pff.9.2018.11.01.08.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Nov 2018 08:28:45 -0700 (PDT)
Date:   Thu, 1 Nov 2018 08:28:42 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181101152842.GC18005@vader>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz>
 <20181101152229.GN9136@twin.jikos.cz>
 <20181101152425.GB18005@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101152425.GB18005@vader>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 08:24:25AM -0700, Omar Sandoval wrote:
> On Thu, Nov 01, 2018 at 04:22:29PM +0100, David Sterba wrote:
> > On Thu, Nov 01, 2018 at 04:08:32PM +0100, David Sterba wrote:
> > > On Thu, Nov 01, 2018 at 01:31:18PM +0000, Chris Mason wrote:
> > > > On 1 Nov 2018, at 6:15, David Sterba wrote:
> > > > 
> > > > > On Wed, Oct 31, 2018 at 10:06:08AM -0700, Omar Sandoval wrote:
> > > > >> From: Omar Sandoval <osandov@fb.com>
> > > > >>
> > > > >> There's a race between close_ctree() and cleaner_kthread().
> > > > >> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> > > > >> sees it set, but this is racy; the cleaner might have already checked
> > > > >> the bit and could be cleaning stuff. In particular, if it deletes 
> > > > >> unused
> > > > >> block groups, it will create delayed iputs for the free space cache
> > > > >> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> > > > >> longer running delayed iputs after a commit. Therefore, if the 
> > > > >> cleaner
> > > > >> creates more delayed iputs after delayed iputs are run in
> > > > >> btrfs_commit_super(), we will leak inodes on unmount and get a busy
> > > > >> inode crash from the VFS.
> > > > >>
> > > > >> Fix it by parking the cleaner
> > > > >
> > > > > Ouch, that's IMO wrong way to fix it. The bug is on a higher level,
> > > > > we're missing a commit or clean up data structures. Messing with state
> > > > > of a thread would be the last thing I'd try after proving that it's 
> > > > > not
> > > > > possible to fix in the logic of btrfs itself.
> > > > >
> > > > > The shutdown sequence in close_tree is quite tricky and we've had bugs
> > > > > there. The interdependencies of thread and data structures and other
> > > > > subsystems cannot have loops that could not find an ordering that will
> > > > > not leak something.
> > > > >
> > > > > It's not a big problem if some step is done more than once, like
> > > > > committing or cleaning up some other structures if we know that
> > > > > it could create new.
> > > > 
> > > > The problem is the cleaner thread needs to be told to stop doing new 
> > > > work, and we need to wait for the work it's already doing to be 
> > > > finished.  We're getting "stop doing new work" already because the 
> > > > cleaner thread checks to see if the FS is closing, but we don't have a 
> > > > way today to wait for him to finish what he's already doing.
> > > > 
> > > > kthread_park() is basically the same as adding another mutex or 
> > > > synchronization point.  I'm not sure how we could change close_tree() or 
> > > > the final commit to pick this up more effectively?
> > > 
> > > The idea is:
> > > 
> > > cleaner                                     close_ctree thread
> > > 
> > >                                             tell cleaner to stop
> > > 					    wait
> > > start work
> > > if should_stop, then exit
> > >                                             cleaner is stopped
> > > 
> > > [does not run: finish work]
> > > [does not run: loop]
> > >                                             pick up the work or make
> > > 					    sure there's nothing in
> > > 					    progress anymore
> > > 
> > > 
> > > A simplified version in code:
> > > 
> > >   set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
> > > 
> > >   wait for defrag - could be started from cleaner but next iteration will
> > > 		    see the fs closed and will not continue
> > > 
> > >   kthread_stop(transaction_kthread)
> > > 
> > >   kthread_stop(cleaner_kthread)
> > > 
> > >   /* next, everything that could be left from cleaner should be finished */
> > > 
> > >   btrfs_delete_unused_bgs();
> > >   assert there are no defrags
> > >   assert there are no delayed iputs
> > >   commit if necessary
> > > 
> > > IOW the unused block groups are removed from close_ctree too early,
> > > moving that after the threads stop AND makins sure that it does not need
> > > either of them should work.
> > > 
> > > The "AND" above is not currently implemented as btrfs_delete_unused_bgs
> > > calls plain btrfs_end_transaction that wakes up transaction ktread, so
> > > there would need to be an argument passed to tell it to do full commit.
> > 
> > Not perfect, relies on the fact that wake_up_process(thread) on a stopped
> > thread is a no-op,
> 
> How is that? kthread_stop() frees the task struct, so wake_up_process()
> would be a use-after-free.

(Indirectly, through the kthread calling do_exit() -> do_task_dead() ->
being put in the scheduler)
