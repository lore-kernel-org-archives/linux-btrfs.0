Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0107C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC6920663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="OYTyurQa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FC6920663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbeK1Gz2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:55:28 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38082 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbeK1Gz2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:55:28 -0500
Received: by mail-yb1-f195.google.com with SMTP id u103-v6so9601259ybi.5
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y4uf5vz0hI5RuMFrfiHf4NP4t3bQTwoBr43VLpFgo/A=;
        b=OYTyurQaw8nvLpYjHWCR5xJL6RqLU39lD3mhdoxjhMcW8n/DRejLM39gawXmUY60s3
         AYxL5G/XbeorLbiyaH1wDqOoQk1NBjOMT5hRXXurrjzLe3gMwHWl/GU0Y5ocvaH7XK2y
         Wrg+ZCuY7TDVEmZyrerdbjb7a6Y6d6o+s3pVFvykq5p/Qz/kSGpN9KFogfvm7R8V5uF+
         lsOPm/dIvaXnYPAFiwt0PVG9DlwxY4mrTWS7axVHVtmURSYM6qxy5BjQXE419A1g/hDo
         pf38gIqs6wv3gmAqU/vxOBf2iIy0/7QSFE/cj1OtWx7xEkichuGhlc9JJZMEXNv0mQYm
         xzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y4uf5vz0hI5RuMFrfiHf4NP4t3bQTwoBr43VLpFgo/A=;
        b=MFyolc/g6k9pRcVEoHgs03QTAViXncSFYUbCRmq8GL6NvuyeaI9yS4dqZGFP8fLd+V
         HyEeFCAN39JL4za/7dxjwGiB4I4iGd6E3EDb8d02W08AY5001qmsPEJk71yBa3fj0Ypd
         StSO15c9+12i3jOT5aYA1ZciCG5NJXmPbQ7r/Ard2QS9hxEEDIfDXtgDSOazJhw79PzF
         3ZJrsSshO3TgxIf2JTdQBaGJw8rIYbPEF+FH1F5/X2SglV3yZqyFdo2etvDRBMNIImuD
         M4OIuNef8jxwfSDzwmUzmlsTT6+V0mqWyBhXGtyjGo91TFlQuUCPQ7c50HW6E45K0Ued
         17+w==
X-Gm-Message-State: AA+aEWaGpZSm3r975PBkI7zgBWEduqbE9k5Cc6lacsJt613rKc5xAWJv
        yBahT2NyB32gSxUQzHTpX3tNOr/Am4I=
X-Google-Smtp-Source: AFSGD/WTdGe3PS1VCuJ0GjYJKZNn4Wyc/o16cHyAJ5f58S1vx98DxOje4pAwBpyUiL8nHAo49dfUew==
X-Received: by 2002:a25:2b41:: with SMTP id r62-v6mr24282095ybr.369.1543348588092;
        Tue, 27 Nov 2018 11:56:28 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id f10sm4644348ywb.26.2018.11.27.11.56.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 11:56:27 -0800 (PST)
Date:   Tue, 27 Nov 2018 14:56:26 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: only run delayed refs if we're committing
Message-ID: <20181127195625.btdnqa7m3fb6hwun@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121191016.25224-1-josef@toxicpanda.com>
 <CAL3q7H45FX3VO0h_9u5-M38ObiWaZPgyXezUDT-4rJvx7BUkhw@mail.gmail.com>
 <20181127192224.zozqhtpcuv5j2qcm@macbook-pro-91.dhcp.thefacebook.com>
 <CAL3q7H4esyeG6uUvegUHdGy0k4Szv8-iw5dDAzUpwiBS_hd7hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4esyeG6uUvegUHdGy0k4Szv8-iw5dDAzUpwiBS_hd7hg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 07:43:39PM +0000, Filipe Manana wrote:
> On Tue, Nov 27, 2018 at 7:22 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > On Fri, Nov 23, 2018 at 04:59:32PM +0000, Filipe Manana wrote:
> > > On Thu, Nov 22, 2018 at 12:35 AM Josef Bacik <josef@toxicpanda.com> wrote:
> > > >
> > > > I noticed in a giant dbench run that we spent a lot of time on lock
> > > > contention while running transaction commit.  This is because dbench
> > > > results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
> > > > they all run the delayed refs first thing, so they all contend with
> > > > each other.  This leads to seconds of 0 throughput.  Change this to only
> > > > run the delayed refs if we're the ones committing the transaction.  This
> > > > makes the latency go away and we get no more lock contention.
> > >
> > > Can you share the following in the changelog please?
> > >
> > > 1) How did you ran dbench (parameters, config).
> > >
> > > 2) What results did you get before and after this change. So that we all get
> > >     an idea of how good the impact is.
> > >
> > > While the reduced contention makes all sense and seems valid, I'm not
> > > sure this is always a win.
> > > It certainly is when multiple tasks are calling
> > > btrfs_commit_transaction() simultaneously, but,
> > > what about when only one does it?
> > >
> > > By running all delayed references inside the critical section of the
> > > transaction commit
> > > (state == TRANS_STATE_COMMIT_START), instead of running most of them
> > > outside/before,
> > > we will be blocking for a longer a time other tasks calling
> > > btrfs_start_transaction() (which is used
> > > a lot - creating files, unlinking files, adding links, etc, and even fsync).
> > >
> > > Won't there by any other types of workload and tests other then dbench
> > > that can get increased
> > > latency and/or smaller throughput?
> > >
> > > I find that sort of information useful to have in the changelog. If
> > > you verified that or you think
> > > it's irrelevant to measure/consider, it would be great to have it
> > > mentioned in the changelog
> > > (and explained).
> > >
> >
> > Yeah I thought about the delayed refs being run in the critical section now,
> > that's not awesome.  I'll drop this for now, I think just having a mutex around
> > running delayed refs will be good enough, since we want people who care about
> > flushing delayed refs to wait around for that to finish happening.  Thanks,
> 
> Well, I think we can have a solution that doesn't bring such trade-off
> nor introducing a mutex.
> We could do like what is currently done for writing space caches, to
> make sure only the first task
> calling commit transaction does the work and all others do nothing
> except waiting for the commit to finish:
> 
> btrfs_commit_transaction()
>    if (!test_and_set_bit(BTRFS_TRANS_COMMIT_START, &cur_trans->flags)) {
>        run delayed refs before entering critical section
>    }
> 

That was my first inclination but then one of the other committers goes past
this and gets into the start TRANS_STATE_COMMIT_START place and has to wait for
the guy running the delayed refs to finish before moving forward, essentially
extending the time in the critical section for the same reason.  The mutex means
that if 9000 people try to commit the transaction, 1 guy gets to run the delayed
refs and everybody else waits for him to finish, and in the meantime the
critical section is small.  Thanks,

Josef
