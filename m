Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AAAC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 12:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8528820672
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 12:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8528820672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504424AbeKWXgN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 18:36:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:39038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403778AbeKWXgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 18:36:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4F2BAEC0;
        Fri, 23 Nov 2018 12:52:06 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2ECA31E0D96; Fri, 23 Nov 2018 13:52:06 +0100 (CET)
Date:   Fri, 23 Nov 2018 13:52:06 +0100
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Btrfs and fanotify filesystem watches
Message-ID: <20181123125206.GC31877@quack2.suse.cz>
References: <20181114174344.17530-1-amir73il@gmail.com>
 <20181114174344.17530-2-amir73il@gmail.com>
 <20181120113206.GG8842@quack2.suse.cz>
 <CAOQ4uxiX6UymHGs2TpFaOT6FpLx5SuapRGTe6S1_+Vwa89tH0g@mail.gmail.com>
 <20181121125154.GA28182@quack2.suse.cz>
 <CAOQ4uxjz8BC4XKufaySVFTVDw5TNZiHxkFqd5jD=Y9BP0KhJbQ@mail.gmail.com>
 <20181122095219.GB9840@quack2.suse.cz>
 <CAOQ4uxj2CJKz-nE=mOeXA36R_Hip8pmPYENRqZ87TMQ+bp2qVg@mail.gmail.com>
 <20181122132640.GB14186@quack2.suse.cz>
 <CAOQ4uxhhFG1qNt1wYjJfUefc9xjHnw6ux2-JiVzd4N1J+Dd2Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhhFG1qNt1wYjJfUefc9xjHnw6ux2-JiVzd4N1J+Dd2Sg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Changed subject to better match what we discuss and added btrfs list to CC.

On Thu 22-11-18 17:18:25, Amir Goldstein wrote:
> On Thu, Nov 22, 2018 at 3:26 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Thu 22-11-18 14:36:35, Amir Goldstein wrote:
> > > > > Regardless, IIUC, btrfs_statfs() returns an fsid which is associated with
> > > > > the single super block struct, so all dentries in all subvolumes will
> > > > > return the same fsid: btrfs_sb(dentry->d_sb)->fsid.
> > > >
> > > > This is not true AFAICT. Looking at btrfs_statfs() I can see:
> > > >
> > > >         buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
> > > >         buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
> > > >         /* Mask in the root object ID too, to disambiguate subvols */
> > > >         buf->f_fsid.val[0] ^=
> > > >                 BTRFS_I(d_inode(dentry))->root->root_key.objectid >> 32;
> > > >         buf->f_fsid.val[1] ^=
> > > >                 BTRFS_I(d_inode(dentry))->root->root_key.objectid;
> > > >
> > > > So subvolume root is xored into the FSID. Thus dentries from different
> > > > subvolumes are going to return different fsids...
> > > >
> > >
> > > Right... how could I have missed that :-/
> > >
> > > I do not want to bring back FSNOTIFY_EVENT_DENTRY just for that
> > > and I saw how many flaws you pointed to in $SUBJECT patch.
> > > Instead, I will use:
> > > statfs_by_dentry(d_find_any_alias(inode) ?: inode->i_sb->sb_root,...
> >
> > So what about my proposal to store fsid in the notification mark when it is
> > created and then use it when that mark results in event being generated?
> > When mark is created, we have full path available, so getting proper fsid
> > is trivial. Furthermore if the behavior is documented like that, it is
> > fairly easy for userspace to track fsids it should care about and translate
> > them to proper file descriptors for open_by_handle().
> >
> > This would get rid of statfs() on every event creation (which I don't like
> > much) and also avoids these problems "how to get fsid for inode". What do
> > you think?
> >
> 
> That's interesting. I like the simplicity.
> What happens when there are 2 btrfs subvols /subvol1 /subvol2
> and the application obviously doesn't know about this and does:
> fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM, ... /subvol1);
> statfs("/subvol1",...);
> fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM, ... /subvol2);
> statfs("/subvol2",...);
> 
> Now the second fanotify_mark() call just updates the existing super block
> mark mask, but does not change the fsid on the mark, so all events will have
> fsid of subvol1 that was stored when first creating the mark.

Yes.

> fanotify-watch application (for example) hashes the watches (paths) under
> /subvol2 by fid with fsid of subvol2, so events cannot get matched back to
> "watch" (i.e. path).

I agree this can be confusing... but with btrfs fanotify-watch will be
confused even with your current code, won't it? Because FAN_MARK_FILESYSTEM
on /subvol1 (with fsid A) is going to return also events on inodes from
/subvol2 (with fsid B). So your current code will return event with fsid B
which fanotify-watch has no way to match back and can get confused.

So currently application can get events with fsid it has never seen, with
the code as I suggest it can get "wrong" fsid. That is confusing but still
somewhat better?

The core of the problem is that btrfs does not have "the superblock
identifier" that would correspond to FAN_MARK_FILESYSTEM scope of events
that we could use.

> And when trying to open_by_handle fid with fhandle from /subvol2
> using mount_fd of /subvol1, I suppose we can either get ESTALE
> or a disconnected dentry, because object from /subvol2 cannot
> have a path inside /subvol1....

So open_by_handle() should work fine even if we get mount_fd of /subvol1
and handle for inode on /subvol2. mount_fd in open_by_handle() is really
only used to get the superblock and that is the same.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
