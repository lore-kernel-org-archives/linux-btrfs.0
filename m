Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3268EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F13332177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550508925;
	bh=6KZFlqggkbsd6YRoxewLx5dLeEL+qMEcjUfkN41DT3g=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=agCHPyKGNBlRFsdHPD6dh4U2eQRmXEa4ZfV0f7ITkQ2D01fpiQQ5BFGETMD7TmHI5
	 9r1PSWEo+Ttm4kM9AinB/2X8Rvjcr4fnMjH+qEIaa0PcgKY/RVWs4LNhpUn7b2Thrr
	 NJ+PsB11F/dJtuK3ECSgrIPuXd014nlvuIYG1dCc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbfBRQzX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbfBRQzX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 11:55:23 -0500
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D75217F9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550508922;
        bh=6KZFlqggkbsd6YRoxewLx5dLeEL+qMEcjUfkN41DT3g=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=A5XfHRpVxp1v4w+0IF93fK9nZgtiniiAoGlH1aOZfaiv4/zSSjRoMnuGiJygXD1f+
         k8/YAMBs4IduEXvupQwbODOvIBLbaHxmk4ewdmVxDhkwflVwWhfmzhPP+abvzvwIju
         p/dqw7a34kqhbLI5MCArxoZnwsrI0jMeBWL5Jx5A=
Received: by mail-vs1-f47.google.com with SMTP id b20so10025890vsl.9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 08:55:22 -0800 (PST)
X-Gm-Message-State: AHQUAuaEwHkKNGmP6cr/nhSI56SDwEi918sXYjChmpb/y//+N26tME6q
        enjlzkwRKPSAar7ej8b8YOKgKtTPXv2OvGeM7Tw=
X-Google-Smtp-Source: AHgI3IYzQOpqDH78f4zTSpcnCTzlTY6JOet9e7YCqnGY0CBg7d1ckNrKC4jcB0y0dkEvdqoDJNxfrGe8Fe4cz9GzjoY=
X-Received: by 2002:a67:bc0e:: with SMTP id t14mr5320425vsn.206.1550508921566;
 Mon, 18 Feb 2019 08:55:21 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz> <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
 <20190131164439.GC4461@carfax.org.uk> <20190218153814.GL9874@twin.jikos.cz>
In-Reply-To: <20190218153814.GL9874@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 18 Feb 2019 16:55:10 +0000
X-Gmail-Original-Message-ID: <CAL3q7H53D=7nawb2wugg0d4S4KH2Sx=DuZVwUcsfrzrv-+PN6Q@mail.gmail.com>
Message-ID: <CAL3q7H53D=7nawb2wugg0d4S4KH2Sx=DuZVwUcsfrzrv-+PN6Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for deduplication
To:     dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 3:36 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Thu, Jan 31, 2019 at 04:44:39PM +0000, Hugo Mills wrote:
> > On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> > > On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> > > >
> > > > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > Checking if the destination root is read-only was being performed only for
> > > > > clone operations. Make deduplication check it as well, as it does not make
> > > > > sense to not do it, even if it is an operation that does not change the
> > > > > file contents (such as defrag for example, which checks first if the root
> > > > > is read-only).
> > > >
> > > > And this is also change in user-visible behaviour of dedupe, so this
> > > > needs to be verified if it's not breaking existing tools.
> > >
> > > Have you had the chance to do such verification?
> > >
> > > This actually conflicts with send. Send does not expect a root/tree to
> > > change, and with dedupe on read-only roots happening
> > > in parallel with send is going to cause all sorts of unexpected and
> > > undesired problems...
> > >
> > > This is a problem introduced by dedupe ioctl when it landed, since
> > > send existed for a longer time (when nothing else was
> > > allowed to change read-only roots, including defrag).
> > >
> > > I understand it can break some applications, but adding other solution
> > > such as preventing send and dedupe from running in parallel
> > > (erroring out or block and wait for each other, etc) is going to be
> > > really ugly. There's always the workaround for apps to set the
> > > subvolume
> > > to RW mode, do the dedupe, then switch it back to RO mode.
> >
> >    Only if you want your incremental send chain to break on the way
> > past...
> >
> >    I think it's fairly clear by now (particularly from the last thread
> > on this a couple of weeks ago) that making RO subvols RW and then back
> > again is a fast way to broken incremental receives.
>
> So, I think the way it should be fixed is to keep deduplication off the
> read-only subvolumes. The main reason I see is to avoid the random
> problems that arise from send + dedupe interaction. The cost is lower
> deduplication ratio.
>
> The main usecase being a primary subvolume with RO snapshots over time,
> with optional incremental send. That I know is common and widely used.
>
> A problematic usecase that would utilize deduplication over RO snapshots
> does could be something like a set of subvolumes that have very similar
> data, get snapshotted or set RO, followed by a dedupe pass.
>
> To support the latter I'd go only via the RO->RW, dedupe, RW->RO way, as
> this records that there was a change and does not collide with send
> assumptions. That this leads to loss of incremental send must be
> communicated to the user with possible override, eg. --I-know-what-I-am-doing
> option.

I fully agree.
Thanks.
