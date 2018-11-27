Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B05EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE842086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFE842086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbeK0Tc4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:32:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:38156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729260AbeK0Tc4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:32:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B02FABA1;
        Tue, 27 Nov 2018 08:35:47 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 904531E07EB; Tue, 27 Nov 2018 09:35:46 +0100 (CET)
Date:   Tue, 27 Nov 2018 09:35:46 +0100
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and fanotify filesystem watches
Message-ID: <20181127083546.GB14128@quack2.suse.cz>
References: <CAOQ4uxiX6UymHGs2TpFaOT6FpLx5SuapRGTe6S1_+Vwa89tH0g@mail.gmail.com>
 <20181121125154.GA28182@quack2.suse.cz>
 <CAOQ4uxjz8BC4XKufaySVFTVDw5TNZiHxkFqd5jD=Y9BP0KhJbQ@mail.gmail.com>
 <20181122095219.GB9840@quack2.suse.cz>
 <CAOQ4uxj2CJKz-nE=mOeXA36R_Hip8pmPYENRqZ87TMQ+bp2qVg@mail.gmail.com>
 <20181122132640.GB14186@quack2.suse.cz>
 <CAOQ4uxhhFG1qNt1wYjJfUefc9xjHnw6ux2-JiVzd4N1J+Dd2Sg@mail.gmail.com>
 <20181123125206.GC31877@quack2.suse.cz>
 <CAOQ4uxjt2+BECu60aisZs_D6pgHK3VbBjju6hzmvG=Ls88UqUA@mail.gmail.com>
 <CAOQ4uxhX8pKJTk7LetsR=jdpe8hDAM-qLR+FtQ_DgDjayuJW6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhX8pKJTk7LetsR=jdpe8hDAM-qLR+FtQ_DgDjayuJW6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri 23-11-18 19:53:11, Amir Goldstein wrote:
> On Fri, Nov 23, 2018 at 3:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > So open_by_handle() should work fine even if we get mount_fd of /subvol1
> > > and handle for inode on /subvol2. mount_fd in open_by_handle() is really
> > > only used to get the superblock and that is the same.
> >
> > I don't think it will work fine.
> > do_handle_to_path() will compose a path from /subvol1 mnt and dentry from
> > /subvol2. This may resolve to a full path that does not really exist,
> > so application
> > cannot match it to anything that is can use name_to_handle_at() to identify.
> >
> > The whole thing just sounds too messy. At the very least we need more time
> > to communicate with btrfs developers and figure this out, so I am going to
> > go with -EXDEV for any attempt to set *any* mark on a group with
> > FAN_REPORT_FID if fsid of fanotify_mark() path argument is different
> > from fsid of path->dentry->d_sb->s_root.
> >
> > We can relax that later if we figure out a better way.
> >
> > BTW, I am also going to go with -ENODEV for zero fsid (e.g. tmpfs).
> > tmpfs can be easily fixed to have non zero fsid if filesystem watch on tmpfs is
> > important.
> >
> 
> Well, this is interesting... I have implemented the -EXDEV logic and it
> works as expected. I can set a filesystem global watch on the main
> btrfs mount and not allowed to set a global watch on a subvolume.
> 
> The interesting part is that the global watch on the main btrfs volume
> more useful than I though it would be. The file handles reported by the
> main volume global watch are resolved to correct paths in the main volume.
> I guess this is because a btrfs subvolume looks like a directory tree
> in the global
> namespace to vfs. See below.
> 
> So I will continue based on this working POC:
> https://github.com/amir73il/linux/commits/fanotify_fid
> 
> Note that in the POC, fsid is cached in mark connector as you suggested.
> It is still buggy, but my prototype always decodes file handles from the first
> path argument given to the program, so it just goes to show that by getting
> fsid of the main btrfs volume, the application will be able to properly decode
> file handles and resolve correct paths.
> 
> The bottom line is that btrfs will have the full functionality of super block
> monitoring with no ability to watch (or ignore) a single subvolume
> (unless by using a mount mark).

Sounds good. I'll check the new version of your series.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
