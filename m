Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA39C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22BF120672
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgVUw3u+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22BF120672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439794AbeKXASv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 19:18:51 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44364 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410046AbeKXASv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 19:18:51 -0500
Received: by mail-yb1-f195.google.com with SMTP id p144-v6so4736154yba.11;
        Fri, 23 Nov 2018 05:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1geM/2lGOW9Zu83ASfzXwW5k/7qiOyJ8IWTFggEH6KQ=;
        b=KgVUw3u+/ZDc4jhwkIz6m0mJbtq5jFwHydVF4cCuQznXuOcJCwAgC7NNPDtdDmySls
         jtY5UhsRf42ZPjgSMGG1bCINFU/ODa7cNre+rHOLXQ2gqP8e6b2Plw3Ik/ecWQO/rrtn
         wo61E6WxCayIefHu5n9hU1uO5dUZyyA/JoPjYD/mOS6rAiEN+KOy5H1AxGND67yUWh7W
         Fb6lVMap76oqYrM04rGSQv1ZNHjiTlRETNzBNPKTutjgSCtu6AhZLtRZrUTnYkB/Nbtv
         S1PtiRV4hFF2pkCavQSV2OdXZQzsWPs/h8OMFSIAUOoMMuAvLdgf43ridAsw0SBexORI
         X9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1geM/2lGOW9Zu83ASfzXwW5k/7qiOyJ8IWTFggEH6KQ=;
        b=CaCAKVhmknIqYFbKmCulqVLMh2G0n9/pgoXqZHYuE3zH7GsvhmxJqyGdL62w2UBKDj
         Kii1tZ2w/hwcSCDw3cwt9l3eEyS1esj4tyzjrrkI3BgP5a6URUGjeV1sJPU+9CgKU5lc
         3CRCibR7/j0N/5Df6f/1d4Mp65bZhrNSjhvSl7Zwvy59Gn7e7c9mZPoYTekbXBqmbIwt
         vBbtOAod4Qisj5DnZCesbM/pFsaUZaDVYmED9E5bcMQHuGInUKswReXMLlxHKD8XsJxo
         5W23I9lDXeMvQjqIeLvMiyPaB5nG/p0nvwdlbzcJY91/Upjz3J5UKqvbIzv1UA7Loc1n
         EHEg==
X-Gm-Message-State: AA+aEWY8DEhNAGvoh7EYXHPZboXBxXFRpgQPzglP3Gu+7ADhIAyFn+bQ
        2x/3IAuj1+b3njlihr4CKq2zERplvMn3VtMkmEQ=
X-Google-Smtp-Source: AFSGD/VJzXbe9r+jCCayfILFV+Xpzg2SysS4HNn30sKH2CK1R3+kY8qiDSzR4sr7ruPZbM/ZBXiBXPEYUPdAgI+/Zfw=
X-Received: by 2002:a25:5955:: with SMTP id n82-v6mr15949541ybb.337.1542980077013;
 Fri, 23 Nov 2018 05:34:37 -0800 (PST)
MIME-Version: 1.0
References: <20181114174344.17530-1-amir73il@gmail.com> <20181114174344.17530-2-amir73il@gmail.com>
 <20181120113206.GG8842@quack2.suse.cz> <CAOQ4uxiX6UymHGs2TpFaOT6FpLx5SuapRGTe6S1_+Vwa89tH0g@mail.gmail.com>
 <20181121125154.GA28182@quack2.suse.cz> <CAOQ4uxjz8BC4XKufaySVFTVDw5TNZiHxkFqd5jD=Y9BP0KhJbQ@mail.gmail.com>
 <20181122095219.GB9840@quack2.suse.cz> <CAOQ4uxj2CJKz-nE=mOeXA36R_Hip8pmPYENRqZ87TMQ+bp2qVg@mail.gmail.com>
 <20181122132640.GB14186@quack2.suse.cz> <CAOQ4uxhhFG1qNt1wYjJfUefc9xjHnw6ux2-JiVzd4N1J+Dd2Sg@mail.gmail.com>
 <20181123125206.GC31877@quack2.suse.cz>
In-Reply-To: <20181123125206.GC31877@quack2.suse.cz>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 23 Nov 2018 15:34:25 +0200
Message-ID: <CAOQ4uxjt2+BECu60aisZs_D6pgHK3VbBjju6hzmvG=Ls88UqUA@mail.gmail.com>
Subject: Re: Btrfs and fanotify filesystem watches
To:     Jan Kara <jack@suse.cz>
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 23, 2018 at 2:52 PM Jan Kara <jack@suse.cz> wrote:
>
> Changed subject to better match what we discuss and added btrfs list to CC.
>
> On Thu 22-11-18 17:18:25, Amir Goldstein wrote:
> > On Thu, Nov 22, 2018 at 3:26 PM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Thu 22-11-18 14:36:35, Amir Goldstein wrote:
> > > > > > Regardless, IIUC, btrfs_statfs() returns an fsid which is associated with
> > > > > > the single super block struct, so all dentries in all subvolumes will
> > > > > > return the same fsid: btrfs_sb(dentry->d_sb)->fsid.
> > > > >
> > > > > This is not true AFAICT. Looking at btrfs_statfs() I can see:
> > > > >
> > > > >         buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
> > > > >         buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
> > > > >         /* Mask in the root object ID too, to disambiguate subvols */
> > > > >         buf->f_fsid.val[0] ^=
> > > > >                 BTRFS_I(d_inode(dentry))->root->root_key.objectid >> 32;
> > > > >         buf->f_fsid.val[1] ^=
> > > > >                 BTRFS_I(d_inode(dentry))->root->root_key.objectid;
> > > > >
> > > > > So subvolume root is xored into the FSID. Thus dentries from different
> > > > > subvolumes are going to return different fsids...
> > > > >
> > > >
> > > > Right... how could I have missed that :-/
> > > >
> > > > I do not want to bring back FSNOTIFY_EVENT_DENTRY just for that
> > > > and I saw how many flaws you pointed to in $SUBJECT patch.
> > > > Instead, I will use:
> > > > statfs_by_dentry(d_find_any_alias(inode) ?: inode->i_sb->sb_root,...
> > >
> > > So what about my proposal to store fsid in the notification mark when it is
> > > created and then use it when that mark results in event being generated?
> > > When mark is created, we have full path available, so getting proper fsid
> > > is trivial. Furthermore if the behavior is documented like that, it is
> > > fairly easy for userspace to track fsids it should care about and translate
> > > them to proper file descriptors for open_by_handle().
> > >
> > > This would get rid of statfs() on every event creation (which I don't like
> > > much) and also avoids these problems "how to get fsid for inode". What do
> > > you think?
> > >
> >
> > That's interesting. I like the simplicity.
> > What happens when there are 2 btrfs subvols /subvol1 /subvol2
> > and the application obviously doesn't know about this and does:
> > fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM, ... /subvol1);
> > statfs("/subvol1",...);
> > fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM, ... /subvol2);
> > statfs("/subvol2",...);
> >
> > Now the second fanotify_mark() call just updates the existing super block
> > mark mask, but does not change the fsid on the mark, so all events will have
> > fsid of subvol1 that was stored when first creating the mark.
>
> Yes.
>
> > fanotify-watch application (for example) hashes the watches (paths) under
> > /subvol2 by fid with fsid of subvol2, so events cannot get matched back to
> > "watch" (i.e. path).
>
> I agree this can be confusing... but with btrfs fanotify-watch will be
> confused even with your current code, won't it? Because FAN_MARK_FILESYSTEM
> on /subvol1 (with fsid A) is going to return also events on inodes from
> /subvol2 (with fsid B). So your current code will return event with fsid B
> which fanotify-watch has no way to match back and can get confused.
>
> So currently application can get events with fsid it has never seen, with
> the code as I suggest it can get "wrong" fsid. That is confusing but still
> somewhat better?

It's not better IMO because the purpose of the fid in event is a unique key
that application can use to match a path it already indexed.
wrong fsid => no match.
Using open_by_handle_at() to resolve unknown fid is a limited solution
and I don't think it is going to work in this case (see below).

>
> The core of the problem is that btrfs does not have "the superblock
> identifier" that would correspond to FAN_MARK_FILESYSTEM scope of events
> that we could use.
>
> > And when trying to open_by_handle fid with fhandle from /subvol2
> > using mount_fd of /subvol1, I suppose we can either get ESTALE
> > or a disconnected dentry, because object from /subvol2 cannot
> > have a path inside /subvol1....
>
> So open_by_handle() should work fine even if we get mount_fd of /subvol1
> and handle for inode on /subvol2. mount_fd in open_by_handle() is really
> only used to get the superblock and that is the same.

I don't think it will work fine.
do_handle_to_path() will compose a path from /subvol1 mnt and dentry from
/subvol2. This may resolve to a full path that does not really exist,
so application
cannot match it to anything that is can use name_to_handle_at() to identify.

The whole thing just sounds too messy. At the very least we need more time
to communicate with btrfs developers and figure this out, so I am going to
go with -EXDEV for any attempt to set *any* mark on a group with
FAN_REPORT_FID if fsid of fanotify_mark() path argument is different
from fsid of path->dentry->d_sb->s_root.

We can relax that later if we figure out a better way.

BTW, I am also going to go with -ENODEV for zero fsid (e.g. tmpfs).
tmpfs can be easily fixed to have non zero fsid if filesystem watch on tmpfs is
important.

Thanks,
Amir.
