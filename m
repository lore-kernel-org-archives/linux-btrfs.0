Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F77CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 05:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 213CE2082C
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 05:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DA3B6wlN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfCEFjl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 00:39:41 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44076 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfCEFjk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2019 00:39:40 -0500
Received: by mail-yw1-f68.google.com with SMTP id x21so6041029ywx.11;
        Mon, 04 Mar 2019 21:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h+BQNh1wOv+XIQtzaZ4SbvhChGkzN3mexQsBABC/4JE=;
        b=DA3B6wlNt0E7ScEa/Em4Qb0VSvhOkE/1VYZSVJCCZ8Z8AG0Uy+tMXdk0L3qTCHpaY/
         TZHmJbzqw/O7GnX3kz1ua/3Mvc/jycKKc12+C0nGHKZQUxgggPpLXPBGfaykIexewuiy
         ruHuqzaSBKSH/HpS75SgE+a3s+4K1cbf0sZZwlgh4kWjefdankJ3ZjZOR9h4rK56n9Vv
         xLi3MLCDg39G0DeWiR5FGfTy44wLzlJlwu++/OPaGgBHfUI5WIoEweW8U39jhPgLnyqW
         YlQhFwPJVxgF9n0RX+Ces0HRWV+CEFaWV+8SjixfrIMrugQuUhDo5KfLzhaiboHLhAng
         Gw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h+BQNh1wOv+XIQtzaZ4SbvhChGkzN3mexQsBABC/4JE=;
        b=on3vksHUmx3XRUxYVIVA+SiaFGKM9zHQ8OE4+VdoCpYFEtkDuGxUqK5/3POI0yqjXE
         z40iNJdlXyvL99ROalKwtixzURXxPmlWMvmERHmT91EkebluK3m2ifSlAbffJlrjJYK2
         +V7zK2yxRbDwCdmM6dzxeDUmNfbheGHSHzkytbVAI+FGSJbxXzKzwmSOAxmIQZ6MDn3d
         593JoKUIc/MLmjqya86BvWo8+BHNj8pQrUD3p4hwn57VA/zAVyfh+O3u51/qAFOUPuDO
         +1y8smvrCp+EyoVZJRvdTGbITEV8h37aOgv7NzXjryIhjnKkNTiPrLoyqyiHSWi2vY0l
         l/EA==
X-Gm-Message-State: APjAAAUM8h82+QCsyk9UwTSyNIm538pF5rt6eYiJH5UG35q5KVlo+cpK
        fB92V9r3ny47g1CYKtK3ymi3w3zf24tE1mf8j84=
X-Google-Smtp-Source: APXvYqzGFPGvuVVLpZP29Na92agTSZleG+NXEnLSdzmaS2ym/Kkml+Li31WnAzG8gfs1860KytxRDN8MPFYoCDvDyxU=
X-Received: by 2002:a81:1b4b:: with SMTP id b72mr16592662ywb.211.1551764379605;
 Mon, 04 Mar 2019 21:39:39 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard>
In-Reply-To: <20190305005020.GA26298@dastard>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 Mar 2019 07:39:28 +0200
Message-ID: <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Dave Chinner <david@fromorbit.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 5, 2019 at 2:50 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Mar 04, 2019 at 05:04:23PM +0200, Amir Goldstein wrote:
> > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > >
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Test that if we truncate a file to reduce its size, rename it and then
> > > fsync it, after a power failure the file has a correct size and name.
> > >
> >
> > I am not sure that ext4/xfs semantics guaranty anything about
> > persisting file name after fsync of file?...
>
> They do.  It's that pesky "strictly ordered metadata" thing I keep
> having to explain to people...
>
> i.e. if you fsync an inode, then you are persisting all the changes
> needed to reference that file and it's data. And so if there was a
> rename in the history of that file, then that is persisted, too.
> Which means that both the original and the new directory
> modifications are persisted, too.
>
> *POSIX* doesn't require this - it says that if you O_DSYNC data,
> then it also includes all the metadata needed to reference that
> data. So even if the data is there, POSIX doesn't define whether the
> rename is there or noti, just that you can get to the fsync'd data
> via either the old or new name. IOWs, POSIX allows the behaviour to
> be implementation specific.
>
> In this case, file systems with strictly ordered metadata will end
> up making the rename visible because the rename occurred before the
> truncate that the fsync() is persisting...
>

That is not what is happening in Filipe's test. Test has:
- ftruncate A
- fsync A
- rename A B
- fsync B

So the reason this is working is because 2nd fsync needs to
persist ctime of B and not because it needs to persist the
truncate.

XFS does it, but it doesn't seem like something that any
filesystem is guaranteed to do the same:
        /*
         * We always want to hit the ctime on the source inode.
         *
         * This isn't strictly required by the standards since the source
         * inode isn't really being changed, but old unix file systems did
         * it and some incremental backup programs won't work without it.
         */
        xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);

So for the purpose of the test itself, which needs to guaranty that
btrfs persists the size, fsync of parent would be more robust for
any filesystem.

Thanks,
Amir.
