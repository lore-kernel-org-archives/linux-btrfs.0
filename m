Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B674C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2958E2081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="BJTBVuNd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2958E2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbeKBA0q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:26:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41475 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbeKBA0q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2018 20:26:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id p16-v6so2957162plr.8
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W9ff05aT6Ayg/QkWua/59MeRsCsGTqxHzyAQUzPwLfg=;
        b=BJTBVuNdLWpqcmNg/wxfBf3M8SklblZPzQXUc9sQMQRwBhsvTCv+Qgqi/HkQ9/7z21
         HpFKzCt5WhKXUv7bhGWmHGqtbOICVRRYUsQYPRHYifcUKJLbnEyNa39uSXT+bYfCjBy7
         zvsSulGE4xBXg6vx1qiGY0GMEd43IX+eG08X2BzgpbKnS1QvpgK1IXXyOLigFj7FJ6oB
         VeJkuCas3CsYG9wE6L/vlkOQ4OeRBTCGozFeLeFMkrRF7J/J3hMwNFRP5YXto3bnS1+V
         qCl0gck9iVZYXczDrfP7UXBtLXz2wCigvL1DsnH8wlVXe4rsWHCXqOlNJv62WneWhagn
         yZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W9ff05aT6Ayg/QkWua/59MeRsCsGTqxHzyAQUzPwLfg=;
        b=RoA5I4oMBk18yAW+t44yAX7oXPes2RE1VFqZ0BuEU6CrsdekzWrVDreVaFK+0tZH6n
         7FBCttQIXX9KB4g6SSI59v3Dmd9+0l091/h6TpwXUBxDymciarKk5eCqSOt5DFvsQgW3
         Ox4fL+W+Z4pjDDuW8QK7ZgAjeaGdK/XjCCtj6L9ft2bdPY//Q5yzD2+1zPvot1na5rpq
         UKNH0nI5FxEo1m+biPlWDxjNnHqJxNq3M+d4C0q/xB8YW+szGBrVF19bgOlX2OzXYZJ/
         LwAYejOyXPR9HwuOc/TFCOFCU2ueyUBlbI0NPVHQoy4acNWTjN0aZz6LQRFV83kPIWj/
         9JJw==
X-Gm-Message-State: AGRZ1gJ1RatAJQhKGpiZ35hsSoYFV1bI1qQEMqGWc7oTMEsvK15Ac1Zv
        FffuXhsXTwcavDoaBIJEL+Bv4w==
X-Google-Smtp-Source: AJdET5caUOQNG8WzdDK+GwqBibqwe0kYTXTBKUKXvODDRNetZgkmSvjfD187jsbzDMqwtzs45Fg/IQ==
X-Received: by 2002:a17:902:380c:: with SMTP id l12-v6mr8071236plc.37.1541085800546;
        Thu, 01 Nov 2018 08:23:20 -0700 (PDT)
Received: from vader ([2601:602:8800:a9a9:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id b2-v6sm6651167pgh.85.2018.11.01.08.23.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Nov 2018 08:23:20 -0700 (PDT)
Date:   Thu, 1 Nov 2018 08:23:17 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181101152317.GA18005@vader>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101150831.GM9136@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 04:08:32PM +0100, David Sterba wrote:
> On Thu, Nov 01, 2018 at 01:31:18PM +0000, Chris Mason wrote:
> > On 1 Nov 2018, at 6:15, David Sterba wrote:
> > 
> > > On Wed, Oct 31, 2018 at 10:06:08AM -0700, Omar Sandoval wrote:
> > >> From: Omar Sandoval <osandov@fb.com>
> > >>
> > >> There's a race between close_ctree() and cleaner_kthread().
> > >> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> > >> sees it set, but this is racy; the cleaner might have already checked
> > >> the bit and could be cleaning stuff. In particular, if it deletes 
> > >> unused
> > >> block groups, it will create delayed iputs for the free space cache
> > >> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> > >> longer running delayed iputs after a commit. Therefore, if the 
> > >> cleaner
> > >> creates more delayed iputs after delayed iputs are run in
> > >> btrfs_commit_super(), we will leak inodes on unmount and get a busy
> > >> inode crash from the VFS.
> > >>
> > >> Fix it by parking the cleaner
> > >
> > > Ouch, that's IMO wrong way to fix it. The bug is on a higher level,
> > > we're missing a commit or clean up data structures. Messing with state
> > > of a thread would be the last thing I'd try after proving that it's 
> > > not
> > > possible to fix in the logic of btrfs itself.
> > >
> > > The shutdown sequence in close_tree is quite tricky and we've had bugs
> > > there. The interdependencies of thread and data structures and other
> > > subsystems cannot have loops that could not find an ordering that will
> > > not leak something.
> > >
> > > It's not a big problem if some step is done more than once, like
> > > committing or cleaning up some other structures if we know that
> > > it could create new.
> > 
> > The problem is the cleaner thread needs to be told to stop doing new 
> > work, and we need to wait for the work it's already doing to be 
> > finished.  We're getting "stop doing new work" already because the 
> > cleaner thread checks to see if the FS is closing, but we don't have a 
> > way today to wait for him to finish what he's already doing.
> > 
> > kthread_park() is basically the same as adding another mutex or 
> > synchronization point.  I'm not sure how we could change close_tree() or 
> > the final commit to pick this up more effectively?
> 
> The idea is:
> 
> cleaner                                     close_ctree thread
> 
>                                             tell cleaner to stop
> 					    wait
> start work
> if should_stop, then exit
>                                             cleaner is stopped
> 
> [does not run: finish work]
> [does not run: loop]
>                                             pick up the work or make
> 					    sure there's nothing in
> 					    progress anymore
> 
> 
> A simplified version in code:
> 
>   set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
> 
>   wait for defrag - could be started from cleaner but next iteration will
> 		    see the fs closed and will not continue
> 
>   kthread_stop(transaction_kthread)
> 
>   kthread_stop(cleaner_kthread)
> 
>   /* next, everything that could be left from cleaner should be finished */
> 
>   btrfs_delete_unused_bgs();
>   assert there are no defrags
>   assert there are no delayed iputs
>   commit if necessary
> 
> IOW the unused block groups are removed from close_ctree too early,
> moving that after the threads stop AND makins sure that it does not need
> either of them should work.
> 
> The "AND" above is not currently implemented as btrfs_delete_unused_bgs
> calls plain btrfs_end_transaction that wakes up transaction ktread, so
> there would need to be an argument passed to tell it to do full commit.

It's too fragile to run around in the filesystem with these threads
freed. We can probably make it now, but I'm worried that we'll add
another wakeup somewhere and blow up.
