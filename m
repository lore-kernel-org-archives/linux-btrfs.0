Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A820C07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 19:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0224D2086D
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 19:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WC8VTY2w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfARTTY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:19:24 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41547 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbfARTTX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 14:19:23 -0500
Received: by mail-qt1-f193.google.com with SMTP id l12so16411152qtf.8
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 11:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7shdgRKUZSTB4ujq8S9OJFpxBAEjImdrGbrJxtYKj2Y=;
        b=WC8VTY2w2YVB5Dz6r5caKOswi6wkm4YJsf2v8Kbd26NyQmpst44l5EMecw3PcdCp8r
         Dw46KF4GKfbuF9wCxDg9eJGezH2oPyyW7Au0ZYc+OKDlPig/feh2uPHzw0O2qqecv7jV
         woaD8WqKkaCYEzz63HunhSB27gwP6e91+uu+zULmzzBJT/sNzmH+DEbguS2dDjdHw7i+
         r97xrvjUghqX/5lxKtAE6LmsLBdZQnw8cwGvtxPi6yHZ4PzpdC3mODgr8DOjyE5jW8kZ
         yfkEpqQZRl3Oxp6hjqmyOEU9cEJ4yokonzI5x+x17zwbgWhmUh+Emc+w/+ViSk/bclQ6
         3mmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7shdgRKUZSTB4ujq8S9OJFpxBAEjImdrGbrJxtYKj2Y=;
        b=tGLnna71tywdafalc8s9OofsIj/eAOslHtvQOabKwaHV+65TxIUTaRTXt9d5VgnwqI
         da+btFfOtC++WsX53By+yCeJgy9ReQJewXs7BeDAdDk+QKRxwKfEZCc+aVsyVJfNUbsi
         ZtyjoHCSG0cw6gXPy7ShG1g6Vj81kGANpg3vAgVg0vGmA4MueqbGWrC2T8vL0YMWrtu2
         e36vpngctd3up+RYnaWetxelSyHDBR1ojEEtzC8Apry1RqioutoZLzBR+uFTU8u72do6
         vv/pXmFCTMZVTXR6CoVHO6E6oHbzAGA7NBjyhQYgwGzwAs2g33zq5fPxTMEjSlPjBG+4
         w9yw==
X-Gm-Message-State: AJcUukc5ErgTDHak5iQsahGqur7UN0QX03wp2Fh1CJFBAWs3wRk58W6I
        QoU1pNJN+/ux9pFGe4MS2CpzQUW93aa89rnXD/qHCw==
X-Google-Smtp-Source: ALg8bN4STroRj8fUUSECE1SwVQLmjCTY0U1TuWzKCaLp5HsEMLVgwErndS0MkLiAJ5qqEAEvjTQ9ECa9naOqVcmekoc=
X-Received: by 2002:aed:34e6:: with SMTP id x93mr17570115qtd.156.1547839163174;
 Fri, 18 Jan 2019 11:19:23 -0800 (PST)
MIME-Version: 1.0
References: <CA+VXTjgtyrWvpNd+5N_pz95s34LcwWLsUyVR-ioj28r81mHf_Q@mail.gmail.com>
In-Reply-To: <CA+VXTjgtyrWvpNd+5N_pz95s34LcwWLsUyVR-ioj28r81mHf_Q@mail.gmail.com>
From:   Liu Bo <obuil.liubo@gmail.com>
Date:   Fri, 18 Jan 2019 11:19:12 -0800
Message-ID: <CANQeFDCGSOzqXoWi+29PtuHj8jMhvLUVnbh0RVs_+oQ7GfVu4A@mail.gmail.com>
Subject: Re: trouble with btrfs lockup
To:     Krishna Mannem <kmannem@pivotal.io>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 10:58 AM Krishna Mannem <kmannem@pivotal.io> wrote:
>
> Hi,
>
> I work on Concourse-CI (https://concourse-ci.org/). It's a container
> based CI system where we create volumes using Btrfs. Due to the nature
> of Concourse, btrfs subvolumes are short lived ( sometimes a few
> seconds if it's a small automation task, sometimes hours if its a long
> build and test suite). We ran into a failure and we're not really sure
> what to make of it. Looks like a lock failed to get acquired before
> scheduling? We need another eye on this.
>
> >uname -a
> Linux a06d0ae3-b242-4518-85ba-977426a3f214 4.15.0-43-generic
> #46~16.04.1-Ubuntu SMP Fri Dec 7 13:31:08 UTC 2018 x86_64 x86_64
> x86_64 GNU/Linux
>
> > btrfs df
> btrfs filesystem df /var/vcap/data/baggageclaim/volumes
> Data, single: total=263.01GiB, used=262.59GiB
> System, DUP: total=8.00MiB, used=48.00KiB
> Metadata, DUP: total=9.00GiB, used=6.60GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> Calltrace:
> https://gist.github.com/kcmannem/3baf848845bc986f5ac7d23d3df51e56

Can you please dump a "echo w > /proc/sysrq-trigger" so that
developers can have a good understanding on what's going on?

From the above info,
1. mm->mmap_sem is held
2. transaction is being committed and others are waiting for it.
3. subvolumes are deleted in short time which may make btrfs-cleaner
thread busy as hell.

thanks,
liubo
