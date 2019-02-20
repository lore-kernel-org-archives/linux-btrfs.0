Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C86C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 16:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE50321841
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550681664;
	bh=WWuBhxI7V8R0yHiwTkhM7Ldv6cGgF4dLfUYhLsiH4nI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ah1vkpFCBsM2BY84quRFZXHI2xC922GHJeW/yHOtlDzK8JmxjDHOF43/sU5MFOToR
	 /p0Ap6ujxJH7h41khR/C96Ulf1gRBpi98GM8AgAR94t6MA+oi5JFkL17neZDNWDKG5
	 zjJlYg5P9ssRXfLzc8QmGafUlZSoI/zElwNUip/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfBTQyX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbfBTQyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 11:54:23 -0500
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA61C21848
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 16:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550681662;
        bh=WWuBhxI7V8R0yHiwTkhM7Ldv6cGgF4dLfUYhLsiH4nI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jVYYjeNaWVyHhKFSM8Tclp2kBgO5PYnuNxkM4C96lKVlJsV1YCRmqpx+WKQsQ2Rpw
         mvSnxCWKIR++e7AdMeXtfka4zj/wsi++ARc4MV+u6wOf0HWj7ryRfmSX6Z5gw5SKyW
         mbNvQofK64rscmkjifC5bJu1jpunjU75MftiFZEM=
Received: by mail-vk1-f173.google.com with SMTP id l136so5664231vke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 08:54:21 -0800 (PST)
X-Gm-Message-State: AHQUAuZ1APHeuiNBoYhoP5Zza6GYdUiVql9KzQADHynunTN0txYAkLiN
        K2dNB5PyHx5fmJNx0DWnMw8S9n3y6acIoCkXqTw=
X-Google-Smtp-Source: AHgI3IblTW7v9bmUGIBztJoVREjuI60j50nzLNptL0J9ORb3O6e8fdPBJnd9d1DTssSdC8I18vdtekwutS0DZ1IeTjY=
X-Received: by 2002:a1f:2b11:: with SMTP id r17mr18599704vkr.88.1550681660897;
 Wed, 20 Feb 2019 08:54:20 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz> <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
 <20190220164140.GF9995@hungrycats.org>
In-Reply-To: <20190220164140.GF9995@hungrycats.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 20 Feb 2019 16:54:09 +0000
X-Gmail-Original-Message-ID: <CAL3q7H455MCpj_-5U=zUzD3Of7aLtG6R_tHdGhZ4Kj-393sWAg@mail.gmail.com>
Message-ID: <CAL3q7H455MCpj_-5U=zUzD3Of7aLtG6R_tHdGhZ4Kj-393sWAg@mail.gmail.com>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for deduplication
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 4:42 PM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> > On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> > >
> > > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > Checking if the destination root is read-only was being performed only for
> > > > clone operations. Make deduplication check it as well, as it does not make
> > > > sense to not do it, even if it is an operation that does not change the
> > > > file contents (such as defrag for example, which checks first if the root
> > > > is read-only).
> > >
> > > And this is also change in user-visible behaviour of dedupe, so this
> > > needs to be verified if it's not breaking existing tools.
> >
> > Have you had the chance to do such verification?
> >
> > This actually conflicts with send. Send does not expect a root/tree to
> > change, and with dedupe on read-only roots happening
> > in parallel with send is going to cause all sorts of unexpected and
> > undesired problems...
>
> This is a problem bees ran into.  There is a workaround in bees (called
> --workaround-btrfs-send) that avoids RO subvols as dedupe targets.
> As the name of the option implies, it works around problems in btrfs send.
>
> This kernel change makes the workaround mandatory now, as the default
> case (without workaround) will fail on every RO subvol even if that
> behavior is desired by the user.  That breaks an important use case on
> the receiving side of sends--to dedupe the received subvols together
> while also protecting them against modification on the target system
> with the RO flag--and preserving that use case is why the send workaround
> was optional (and not default) in bees.
>
> bees also won't handle the RO/RW/RO transition correctly, as it didn't
> seem like a sane thing to support at the time.  That is arguably something
> to be fixed in bees.
>
> > This is a problem introduced by dedupe ioctl when it landed, since
> > send existed for a longer time (when nothing else was
> > allowed to change read-only roots, including defrag).
>
> Is there a reason why incremental send can't simply be fixed?

This is a problem that affects both incremental and non-incremental (full) send.

> As far
> as I can tell, send is failing because of a runtime check that seems to
> be too strict; however, I haven't tried removing that check to see if
> it fixes the problem in send, or just hides the next problem.

The problem is send was designed with the idea that read-only roots
don't ever change.

The failures that can happen are many and unpredictable, from
occasionally failing with some error, to invalid memory accesses, use
after free problems, etc.
Essentially all caused by races when the nodes/leafs from the
read-only tree change while send is running.

I don't know what runtime check you are mentioning that is too strict.
You can definitely do dedupe on a read-only root and after it finishes
do a send (either full or incremental), and it will work.

>
> More details at:
>
>         https://github.com/Zygo/bees/issues/79#issuecomment-429039036
>
> > I understand it can break some applications, but adding other solution
> > such as preventing send and dedupe from running in parallel
> > (erroring out or block and wait for each other, etc) is going to be
> > really ugly. There's always the workaround for apps to set the
> > subvolume
> > to RW mode, do the dedupe, then switch it back to RO mode.
> >
> > Thanks.
