Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414A4C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A6C20873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="IHxbGuPK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5A6C20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbeK1GpC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:45:02 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46556 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbeK1GpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:45:02 -0500
Received: by mail-qt1-f194.google.com with SMTP id y20so23172115qtm.13
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=sTBcjxZasWVYqJ6lDZ6sr23WNQ8bk8J55CEUbsNRv3Q=;
        b=IHxbGuPKc/6EGxLUsgYoS2bKGusYQAOYTfNDUjn9qT6ndLP41THUXXbKW6orTgj5va
         6C0TxF9p9B3qeRSrYMfF06tzf/phALqni0O1549n3d+sGuQlcFnSQGDNWw0rF5rOliSb
         0RTXoKgFVsWifJxGB2CrHim/wU0u86x+AswGwSpqFVwTnhE+c5tPOd1bfkl4jBcbuBL5
         zdQflfXnRGHbTh6lZNwEJaYmQiXOrs+Va2h8gp1ULeR2ynOKSkPYACRl5XgHOP8CI7Y5
         H3kuISqZxbAuBw3V84l5kTnHj92Llv/kpUxSo3MG/wE3swVQdCWqHvM4yLCUOkG3eZ//
         efbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=sTBcjxZasWVYqJ6lDZ6sr23WNQ8bk8J55CEUbsNRv3Q=;
        b=XHTFA+MKdyH5kq56lFZCBoAzlsac5oi86wpHsdlOsyeF0s9GKwUaI044WS2HeojP+T
         De7p1Zq6I6vnsTMK5PYapwok9hU4AZITks+bQxBuoDUeAIQun0/SvNM5pf/kx2lE/huX
         D0vYe+XC5li6nTVXzZqozzZ+h5m3pGlldcojZeQlobww2b5MEb+6D6zskeIJ9KdJz147
         tCWD0b1FK99RnCAoee0bv6T6bS/nzm3jnhSAe+mH0IxsoM0mqzcC3aP2v+cKHfxXb5af
         DSj2vugLayAoBReqFmkYvoqBYl8yFk67oGpkv3CzDd8icbNOwTUWvjJbODu53sF5K/9b
         ZeLQ==
X-Gm-Message-State: AA+aEWatYdyxxyMalEYSKmyr8RzFL9/LrDPCH+fGdvulpKIbzGkJ1cU5
        zhnGmifpmMJVTP+aY4dZ1iXW5w==
X-Google-Smtp-Source: AJdET5dSf6UmdX6O8bfHPDGl0Y0SbmehvjWlTl75XMNSV7CmXm322VHM437rKJunT3avWrEEQHqn6g==
X-Received: by 2002:ac8:1779:: with SMTP id u54mr31781324qtk.285.1543347963337;
        Tue, 27 Nov 2018 11:46:03 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id c17sm4089835qtb.14.2018.11.27.11.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 11:46:03 -0800 (PST)
Date:   Tue, 27 Nov 2018 14:46:01 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 5/8] btrfs: don't enospc all tickets on flush failure
Message-ID: <20181127194601.sdl3qhekvixvevgu@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
 <20181121190313.24575-6-josef@toxicpanda.com>
 <ccd81359-764f-6651-a738-ba3b3843b9b3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccd81359-764f-6651-a738-ba3b3843b9b3@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 02:25:52PM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.11.18 г. 21:03 ч., Josef Bacik wrote:
> > With the introduction of the per-inode block_rsv it became possible to
> > have really really large reservation requests made because of data
> > fragmentation.  Since the ticket stuff assumed that we'd always have
> > relatively small reservation requests it just killed all tickets if we
> > were unable to satisfy the current request.  However this is generally
> > not the case anymore.  So fix this logic to instead see if we had a
> > ticket that we were able to give some reservation to, and if we were
> > continue the flushing loop again.  Likewise we make the tickets use the
> > space_info_add_old_bytes() method of returning what reservation they did
> > receive in hopes that it could satisfy reservations down the line.
> 
> 
> The logic of the patch can be summarised as follows:
> 
> If no progress is made for a ticket, then start fail all tickets until
> the first one that has progress made on its reservation (inclusive). In
> this case this first ticket will be failed but at least it's space will
> be reused via space_info_add_old_bytes.
> 
> Frankly this seem really arbitrary.

It's not though.  The tickets are in order of who requested the reservation.
Because we will backfill reservations for things like hugely fragmented files or
large amounts of delayed refs we can have spikes where we're trying to reserve
100mb's of metadata space.  We may fill 50mb of that before we run out of space.
Well so we can't satisfy that reservation, but the small 100k reservations that
are waiting to be serviced can be satisfied and they can run.  The alternative
is you get ENOSPC and then you can turn around and touch a file no problem
because it's a small reservation and there was room for it.  This patch enables
better behavior for the user.  Thanks,

Josef
