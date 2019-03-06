Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC640C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 07:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC3412064A
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 07:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoVZAvXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfCFHvg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 02:51:36 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41234 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfCFHvf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2019 02:51:35 -0500
Received: by mail-yw1-f68.google.com with SMTP id q128so9207059ywg.8;
        Tue, 05 Mar 2019 23:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrTOcC9B/ni6xQt3NOzRF5RdwQW+ye8hpMVTGBH9g0A=;
        b=AoVZAvXkbz2Q7EhGaOoObaC8zadmWNbIoPoPMBLkp/6G50iG8kXfAvtTF4WxpOUj/h
         VmSyghhNX5Ke9QCH7Gf52QQ7t8TYH/pCJSyc/rnJmAIhgj+r1WQXv16yiQ2xSxi5pZTa
         jD9Q1hlWLeUqkbpRxjyO3z6D1Or7luKJ6vC0j1Nefe1LECoEWv6GnskT8/07SnX54SsR
         kSS7W16L1Gix7INcKJjDGsrhJZbSyRiAg1n3N13i47kl5zK+ssbJM0J8QShKV0v/MnYY
         WumammxW4u5QKFLc2k9IotzwByAW0xnINqS4P1L3W6HKfeW5iwcilPFdtCz3GqsVFTUb
         l/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrTOcC9B/ni6xQt3NOzRF5RdwQW+ye8hpMVTGBH9g0A=;
        b=M64xSwUnRsKrz/gPpQwsejvPDfVbXWPaWkkijTjBM5LAZ1XFAC8x4hjtqzJAM7FHpE
         RS1WHOx26bvL99/fXj62103Mf5bcC5dv3J+5ckQJeSBV1cLiPojQDE/7PXe4jHZh0E8B
         BNZH+jKo2od8uYNaswD33uI6Wqtq0VAuoRJobUsCaixhUVlnPrn73wT+Mf6Yeu9/zz43
         md2QrdiYcYnQl9lStUnTCs+bOMxUzaY/T1APBaxWDZE2SpHUdmBbFmXlwdS9QGDefPN/
         EMSpjihWk1/dxoeOfNRuMWDD5fjPQ//4Nj25wQJc30RzRZU1FMxWsumDNdAZ6ScQd0vf
         XyFw==
X-Gm-Message-State: APjAAAVlZi0Iobwc8dv1b5QgEfllbxLMbu9xFLlf7KyLTlWK9lun/MmK
        MQnF1QkOcAbpRax9odyn2Dq7OzUNqWbR1jltOMQ=
X-Google-Smtp-Source: APXvYqzpZIzOO4CVtxisC4maqsXDFS/ijAld08tv7TIwD+hvYgRSLTxwEWCjXW/MTHPWcKOCw1wiIxJqYmXUxc/zx64=
X-Received: by 2002:a81:2e86:: with SMTP id u128mr4222583ywu.241.1551858694376;
 Tue, 05 Mar 2019 23:51:34 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard> <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard>
In-Reply-To: <20190305223301.GD26298@dastard>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 6 Mar 2019 09:51:23 +0200
Message-ID: <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
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

On Wed, Mar 6, 2019 at 12:33 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Mar 05, 2019 at 07:39:28AM +0200, Amir Goldstein wrote:
> > On Tue, Mar 5, 2019 at 2:50 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Mon, Mar 04, 2019 at 05:04:23PM +0200, Amir Goldstein wrote:
> > > > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > > > >
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > Test that if we truncate a file to reduce its size, rename it and then
> > > > > fsync it, after a power failure the file has a correct size and name.
>
> This says:
>
> - ftruncate A
> - rename A B
> - fsync B
>
> > > > I am not sure that ext4/xfs semantics guaranty anything about
> > > > persisting file name after fsync of file?...
> > >
> > > They do.  It's that pesky "strictly ordered metadata" thing I keep
> > > having to explain to people...
> > >
> > > i.e. if you fsync an inode, then you are persisting all the changes
> > > needed to reference that file and it's data. And so if there was a
> > > rename in the history of that file, then that is persisted, too.
> > > Which means that both the original and the new directory
> > > modifications are persisted, too.
> > >
> > > *POSIX* doesn't require this - it says that if you O_DSYNC data,
> > > then it also includes all the metadata needed to reference that
> > > data. So even if the data is there, POSIX doesn't define whether the
> > > rename is there or noti, just that you can get to the fsync'd data
> > > via either the old or new name. IOWs, POSIX allows the behaviour to
> > > be implementation specific.
> > >
> > > In this case, file systems with strictly ordered metadata will end
> > > up making the rename visible because the rename occurred before the
> > > truncate that the fsync() is persisting...
> > >
> >
> > That is not what is happening in Filipe's test. Test has:
> > - ftruncate A
> > - fsync A
> > - rename A B
> > - fsync B
>
> And this does not match the test description.
>
> /me goes and looks at the test again to check.
>
> Ok, the test is as Filipe describes:
>
> - pwrite 0 0x8000 A
> - fsync A
> - truncate 3000 A
> - rename A B
> - fsync B
>
> There is no fsync between truncate and rename.
>
> > So the reason this is working is because 2nd fsync needs to
> > persist ctime of B and not because it needs to persist the
> > truncate.
>
> ctime modifications during rename are irrelevent because there's no
> fsync between the truncate and the rename so the file inode is
> already dirty due to the truncate. I think you've got the wrong end
> of the stick here, Amir. :)
>

Doh! The discussion is still interesting because people have
hard time to understand that those hidden details like ctime
update on rename may have different behavior on different fs
regardless if they obay ordered metadata or not.
Btrfs is different in the respect of metadata dependencies from
xfs/ext4 in many ways as seen in the different rename/link
crash consistency discussions.

Thanks,
Amir.
