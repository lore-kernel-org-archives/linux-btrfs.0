Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448C8C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61F32080A
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ND0o3/br"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D61F32080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbeKABeK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 21:34:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36455 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729561AbeKABeK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 21:34:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id y11-v6so7552209plt.3
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 09:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=k7nvJhhlsfkqruQIyH3nCerp/4qjKlfTnbbgS7lbwCU=;
        b=ND0o3/brAz8vZTaEKlFFzONeZgPOo1TV9l72mywmgKsSk6YDLv47KPb3Zxnnf+XoB0
         8p+3e/1nDq9wyvdCXl4Dr6T4EeHmbp+pbAzKLVpFkf1MpMShnFdTnwvzHL6bjaUTIHGB
         movTu3vvrFjA8ljnytRqyiXuIyzIV1ceIdaYGnjeTkQiH4i83GI72hHlM7tMWjJYdJFv
         5QtF5Mu11Y1pKRLrhk06X3iJXh3Kon9M3dfc+OkcG7S2la9JBRa+m7/QEDxXdgMtG4Cb
         OZK8EfVCmwd61CINL3coOOhVOPC6KGmSACzAgc0+7fpGOYQYpEttT23McM7PNgIXAwmI
         zwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=k7nvJhhlsfkqruQIyH3nCerp/4qjKlfTnbbgS7lbwCU=;
        b=NUuN8P3ajG18LKQnRUKwzMYkowIB0E47C2vwJoQ+dn3+l7uWgQVpUMJt/JOtUkvD5t
         6OAdMqwp/vouvf0GyqIyn/M8auYuPszme1uOGa2YPSyURLt1njDGNAluUAidl1o0Oplo
         JxsSg3f0Fh91ahATr7wnYHxq/IavR8/LREP1WWn93FEgJFcot5vxul3QIl+zttuDi+U5
         oc/JZL5zgr8sxqtkJNYyG7SLQYShZNOCfgHMoNn6jI8MvhIAo3Za3rgRceDzdhe6WQ8K
         SswXN72dKGAGHpGEhYOWsEy3226H6wA5fB4bs9RL+MakIzijWsCOyb/Lp3ytJV77Gcn2
         Jb5w==
X-Gm-Message-State: AGRZ1gJiW5hRpwaAuWbgWltcDXp8QNf17YYyi1Wfojg/1kHF20GAMEhQ
        bGVMQf7Fm9mLjIC8Pnz7ZUolghh25no=
X-Google-Smtp-Source: AJdET5djBqJkmUi+7t1HywlUE7Pop+PFLz6UDhseA26Mx/qzSeWAj7B7JwQNdRCProdssQs4MPhI7w==
X-Received: by 2002:a17:902:a50e:: with SMTP id s14-v6mr4171812plq.78.1541003724796;
        Wed, 31 Oct 2018 09:35:24 -0700 (PDT)
Received: from vader ([2620:10d:c090:180::1:deee])
        by smtp.gmail.com with ESMTPSA id s30-v6sm21193138pga.57.2018.10.31.09.35.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Oct 2018 09:35:24 -0700 (PDT)
Date:   Wed, 31 Oct 2018 09:35:22 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181031163522.GA8563@vader>
References: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
 <4817ac90-a79d-c258-96e1-f1108cfe7225@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4817ac90-a79d-c258-96e1-f1108cfe7225@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 10:43:02AM +0200, Nikolay Borisov wrote:
> 
> 
> On 31.10.18 г. 2:14 ч., Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > There's a race between close_ctree() and cleaner_kthread().
> > close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> > sees it set, but this is racy; the cleaner might have already checked
> > the bit and could be cleaning stuff. In particular, if it deletes unused
> > block groups, it will create delayed iputs for the free space cache
> > inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> > longer running delayed iputs after a commit. Therefore, if the cleaner
> > creates more delayed iputs after delayed iputs are run in
> > btrfs_commit_super(), we will leak inodes on unmount and get a busy
> > inode crash from the VFS.
> > 
> > Fix it by parking the cleaner before we actually close anything. Then,
> > any remaining delayed iputs will always be handled in
> > btrfs_commit_super(). This also ensures that the commit in close_ctree()
> > is really the last commit, so we can get rid of the commit in
> > cleaner_kthread().
> > 
> > Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > We found this with a stress test that our containers team runs. I'm
> > wondering if this same race could have caused any other issues other
> > than this new iput thing, but I couldn't identify any.
> > 
> >  fs/btrfs/disk-io.c | 40 +++++++---------------------------------
> >  1 file changed, 7 insertions(+), 33 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index b0ab41da91d1..7c17284ae3c2 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1664,9 +1664,8 @@ static int cleaner_kthread(void *arg)
> >  	struct btrfs_root *root = arg;
> >  	struct btrfs_fs_info *fs_info = root->fs_info;
> >  	int again;
> > -	struct btrfs_trans_handle *trans;
> >  
> > -	do {
> > +	while (1) {
> >  		again = 0;
> >  
> >  		/* Make the cleaner go to sleep early. */
> > @@ -1715,42 +1714,16 @@ static int cleaner_kthread(void *arg)
> >  		 */
> >  		btrfs_delete_unused_bgs(fs_info);
> >  sleep:
> > +		if (kthread_should_park())
> > +			kthread_parkme();
> > +		if (kthread_should_stop())
> > +			return 0;
> >  		if (!again) {
> >  			set_current_state(TASK_INTERRUPTIBLE);
> > -			if (!kthread_should_stop())
> > -				schedule();
> > +			schedule();
> >  			__set_current_state(TASK_RUNNING);
> >  		}
> > -	} while (!kthread_should_stop());
> > -
> > -	/*
> > -	 * Transaction kthread is stopped before us and wakes us up.
> > -	 * However we might have started a new transaction and COWed some
> > -	 * tree blocks when deleting unused block groups for example. So
> > -	 * make sure we commit the transaction we started to have a clean
> > -	 * shutdown when evicting the btree inode - if it has dirty pages
> > -	 * when we do the final iput() on it, eviction will trigger a
> > -	 * writeback for it which will fail with null pointer dereferences
> > -	 * since work queues and other resources were already released and
> > -	 * destroyed by the time the iput/eviction/writeback is made.
> > -	 */
> > -	trans = btrfs_attach_transaction(root);
> > -	if (IS_ERR(trans)) {
> > -		if (PTR_ERR(trans) != -ENOENT)
> > -			btrfs_err(fs_info,
> > -				  "cleaner transaction attach returned %ld",
> > -				  PTR_ERR(trans));
> > -	} else {
> > -		int ret;
> > -
> > -		ret = btrfs_commit_transaction(trans);
> > -		if (ret)
> > -			btrfs_err(fs_info,
> > -				  "cleaner open transaction commit returned %d",
> > -				  ret);
> >  	}
> > -
> > -	return 0;
> >  }
> >  
> >  static int transaction_kthread(void *arg)
> > @@ -3931,6 +3904,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
> >  	int ret;
> >  
> >  	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
> > +	kthread_park(fs_info->cleaner_kthread);
> 
> Can't you directly call kthread_stop here? When you park the thread it
> will sleep and then when you call kthread_stop that function will unpark
> the thread and the cleaner kthread will see KTHREAD_SHOULD_STOP bit and
> just return 0. So the from the moment the thread is parked until it's
> stopped it doesn't have a chance to do useful work.

kthread_stop() frees the task_struct, but we might still try to wake up
the cleaner kthread from somewhere (e.g., from the transaction kthread).
So we really need to keep the cleaner alive but not doing work.
