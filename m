Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E33AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 17:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5ADD20672
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 17:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="FWHEq7+y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5ADD20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbeK0EKe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 23:10:34 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39771 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbeK0EKe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 23:10:34 -0500
Received: by mail-pf1-f196.google.com with SMTP id c72so6886558pfc.6
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4j2zba+iVvW1nHvfgR8T11z8nYgGHmTEwx7JSVu2G28=;
        b=FWHEq7+yXcbwz/M/GxXkYskgT7XE9ccrelT1/JOU21rVoN6hh+sWnfcUh3L4umQerQ
         2pX0SwexHexJieH3x1tOa+tNM584kIfqIg91krXlEeRGGZI1q1itHpGpKzG7bEEgmo6n
         Pr4CH9s1zv3+R4mpXPuZ3XKk7PnRfCA8gpzJu3jmHwAA8QYQHBXQBEnOJZBcB7yKpn2A
         Z+ylrbb1FvpubX5lDdsvr2dVG9DkrFIv5KtV5CJ8ucsk7a5sdu+9hvBQWSbXKnCUhNt5
         xJZp9xYED/oGAhEWJ5gq04YFvyRdBsWEqYPq1uYvJYcpnxrEaU1KAbZne8e/ACH/A921
         KpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4j2zba+iVvW1nHvfgR8T11z8nYgGHmTEwx7JSVu2G28=;
        b=r2oySiS0zfkoRjJgMzF7ObziBDR3ndV9Lfy74x6hmsTzLtQJUtadP4Qm63+Lh604rA
         1RolCTrASFYGLOAgTy0/j4HJVyIg3HPETKQ/RjMhSgUcWOw5Uffz+pqivwAKRzLYf8tv
         XgFVVJcNM0HHqykXjzxftzSAQ4xCBj4T3nHtMEqWSEATM5c5TDp7vvEx31bCN/q1Z5L0
         IGHcHR5lkPFODxRsDBExqzbwOhgl3MwYk087lfChEFusRq7xik2nTpzi1K92I/fDJ8CE
         D2cw3/nwj8bLZkk8iKU3s6O1njs4SqIF5LgbJveEtgCeq7o1+jOsdyQKkmY8uSKiKSHn
         aMSQ==
X-Gm-Message-State: AGRZ1gLtwnh5qKz6b+CqmxPaxz86SpndffDFIdGb4Mg/qjSTJjdZB7C2
        Wvdlfc7eezMQa/iNA2RyppCHSzkmEn0=
X-Google-Smtp-Source: AFSGD/XKGw6guubv8VZI4/33kjK2LNKk3b/5lTKEXxWeAhlO1cJWCRzPAdXzNj5+QfExzDRMPmmNQw==
X-Received: by 2002:a63:1f1c:: with SMTP id f28mr25769901pgf.193.1543252548703;
        Mon, 26 Nov 2018 09:15:48 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:fd28])
        by smtp.gmail.com with ESMTPSA id 196sm2835093pfc.77.2018.11.26.09.15.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 09:15:47 -0800 (PST)
Date:   Mon, 26 Nov 2018 09:15:44 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH 00/10] btrfs-progs: my libbtrfsutil patch queue
Message-ID: <20181126171544.GA17512@vader>
References: <cover.1542181521.git.osandov@fb.com>
 <20181126161811.GH2842@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126161811.GH2842@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 05:18:12PM +0100, David Sterba wrote:
> On Tue, Nov 13, 2018 at 11:46:55PM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Hi,
> > 
> > This series contains my backlog of libbtrfsutil changes which I've been
> > collecting over the past few weeks.
> > 
> > Patches 1-4 are fixes. Patches 5-6 add functionality to the unit tests
> > which is needed for patches 7-8. Patches 7-8 add support for the
> > unprivileged ioctls added in Linux 4.18; more on those below. Patch 9
> > bumps the library version. Patch 10 adds documentation for the available
> > API along with examples.
> > 
> > Patches 7-8 are based on Misono Tomohiro's previous patch series [1],
> > with a few important changes.
> > 
> > - Both subvolume_info() and create_subvolume_iterator() now have unit
> >   tests for the unprivileged case.
> > - Both no longer explicitly check that top == 0 in the unprivileged
> >   case, since that will already fail with a clear permission error.
> > - Unprivileged iteration is much simpler: it uses openat() instead of
> >   fchdir() and is based more closely on the original tree search
> >   variant. This fixes a bug in post-order iteration in Misono's version.
> > - Unprivileged iteration does _not_ support passing in a non-subvolume
> >   path; if this behavior is desired, I'd like it to be a separate change
> >   with an explicit flag.
> 
> Series merged to devel, thanks.

Thanks!

> I've added link from the main README now
> that there's the API documentation.

Ah, great idea.

> The test-libbtrfsutil is missing from the travis CI for some reason, I
> was about to add it.  So far the testing environment does not provide
> 'umount' that knows about '-R' so the tests fail. I'll have a look if
> there's a newer base image provided, otherwise a workaround would be
> necessary.

It looks like it was added to util-linux in v2.23 back in 2013. Or maybe
the base image uses busybox? I believe that umount from busybox doesn't
have -R.

> As for the unprivileged subvolume listing ioctls, the functionality in
> the util library is self-contained and the interface is up to you to
> design properly, so this does not depend on the 'btrfs subvolume list'
> command. That one has unfortunately not bubbled high enough in my todo.

That comment is mostly for Misono, since the original version had that
functionality, probably for the subvolume list command.
