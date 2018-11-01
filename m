Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA790C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 915682081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="etnKWfh5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 915682081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbeKBA1z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:27:55 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42172 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbeKBA1y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2018 20:27:54 -0400
Received: by mail-pl1-f196.google.com with SMTP id t6-v6so9090669plo.9
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t3cbIVDC7zik/rHAnC6TAYIM3cEuj53Q1oDoBMYHY+w=;
        b=etnKWfh57tyfHjT4PpromZhRTNho5iu/SqdcwTPmjA1Q47KCC4hM+ytOOz2JpQbvj6
         vu+qPho+GkMFgPB9k2Yue8cSydDYJ1ZnEOX5fOhAKQQuLnOGkr2igQJg8nX6fR8hS25Y
         NkcxzPNpGLHigMXbuRn27bLTQxWW3fdjr28KJZxhxbni2rqENG1OS+OhY8AGJwhJunGv
         m9egzZvQHyjksgSSeeBKjtiSBGenyQmgpOqlLGJPQu9lC7h3nR+aYfmWYYT7mdRClKFb
         iogFdSfDuI2yMa+UkrgOG9mI7OSYMu8v5P+olFxNsP1roNQw3WKESyk7bsvcdf/0HKHN
         Cd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t3cbIVDC7zik/rHAnC6TAYIM3cEuj53Q1oDoBMYHY+w=;
        b=VeF+RPVAXgydltL7fxuuWngusA5IN7uD0Vv0poAYVe/ulKJwMjJ+YB/nNpoq4g0bE7
         fjPI96zKOBJalhHmNSCiLP35dnFPnSeo0bOefpWIl9qi8w0/rqyae1lmPIstj04FUQwy
         wcwku5IuQBGRQbHnVXCljmiV7c8lEN3qelipl7cytWgbEODu9Y91mjAe6VgGQNS2UDGF
         EHpOmi8rtqjaU0Z8HS8GsddnQPe6idkBC9HDvwvyFpGhm6VUKA2BYcRlbG1zOlfrLIrN
         r8KIcUortKTSQsz57MCcBk8Pgm8xmuBSe4x+lppGzwT6bLQWaZUhjp0JAUu3DAVoBR01
         LH9w==
X-Gm-Message-State: AGRZ1gJK+8hWmld6etd8Blh6U4LgEgLriLGokaQC1yZ/gPAl7plvnxtn
        u9J1illsAvBfdLgG/VWW7/agSf/eyMM=
X-Google-Smtp-Source: AJdET5fF6C2TN/zdkwrUY48eLDamA69stMmZ/WZeFlh6KfASg36ZqCpsN5Zlfl52msy+x3lfYzp4PQ==
X-Received: by 2002:a17:902:b03:: with SMTP id 3-v6mr8090826plq.233.1541085868936;
        Thu, 01 Nov 2018 08:24:28 -0700 (PDT)
Received: from vader ([2601:602:8800:a9a9:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id r5-v6sm44908229pgi.64.2018.11.01.08.24.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Nov 2018 08:24:28 -0700 (PDT)
Date:   Thu, 1 Nov 2018 08:24:25 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181101152425.GB18005@vader>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz>
 <20181101152229.GN9136@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101152229.GN9136@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 04:22:29PM +0100, David Sterba wrote:
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
> Not perfect, relies on the fact that wake_up_process(thread) on a stopped
> thread is a no-op,

How is that? kthread_stop() frees the task struct, so wake_up_process()
would be a use-after-free.
