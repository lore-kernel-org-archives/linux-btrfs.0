Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD70C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5B292084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="L4hGPTyP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfDLNhs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:37:48 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46554 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfDLNhs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:37:48 -0400
Received: by mail-yw1-f68.google.com with SMTP id v127so3360519ywe.13
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 06:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=DBwqy7nK8S08UfgCo3Qj9ZHDO6waUXVWC0WZ5gNWcuo=;
        b=L4hGPTyP6GEhJQwZvBOUbgeqWN6C3nV4LFDh4U+t958Fnaa3HammP7sZ83657GgJxz
         tT45lZgF3BalnLFfrcvxXNi3dgMkD8QP/COjxLXK5t3tRnrzNOo1h1lvrWEDRNvSK5sC
         xMVjSd6+Ds5Iz7tV85IQg/GJgY31nr5DQvxJrZFZTD+eB4lqtrJ8K5RB1vg7jbtCCic2
         LRmMozNfORGn4BgHjvzM3JQL21SM38EMJ0/YOlzPCLFm0qLYcwCrXNN12kgnXySniLcy
         +vczX1HQQKb9w62q3MSDR+O1c8BQ07ASvCpDwFQNIMOT0v8B7cQeQsdOfe4BJBV8bpKC
         VJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DBwqy7nK8S08UfgCo3Qj9ZHDO6waUXVWC0WZ5gNWcuo=;
        b=dxjpwyEK7gdXVPEqv51em1B0/R3jLsH8ruUgYxTj27tKIvBQTtsxcYg9o9CdiY8Z+3
         kFXiNgUZ2BbCJIJaWczYyfn7T3ANn33HNo3jAHzihz+Bobei1gCfLFAuZTUbqDI1f5sH
         WCWUTAApidg2nY7OavjiSwDfKqc0LjfF2Hy0QtcenH/p2DQImtixGo4G5sLQju9ASGI6
         QFUjo/mdnLjDjf5uGiImdcXClmioeTh+ggIHw3RS1U0xZV9iKHhphNGvCsKUL65XQE50
         DCEuwtqtEBN1Q7CFI4W8r1cPj865NKeFkpRKQVTNHUm9KrhQ2lwdHdt5Op98MiGhxgi9
         P2yg==
X-Gm-Message-State: APjAAAU/oa/wm7sdI5ipe079zg3TwJvWjqrJlh8pl7KfCtZLQwjItdwZ
        OBahh9vPS904j+9soRqbm3dNLA==
X-Google-Smtp-Source: APXvYqy9aWgYtb+cvBf07x2ll/y8OdJH912Z9F+fxwnW4eoNwysbijM4cOgq0g3yS+bG1+Omq8Zd2Q==
X-Received: by 2002:a81:69d5:: with SMTP id e204mr45562471ywc.267.1555076265984;
        Fri, 12 Apr 2019 06:37:45 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::d607])
        by smtp.gmail.com with ESMTPSA id b71sm15133547ywb.1.2019.04.12.06.37.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 06:37:45 -0700 (PDT)
Date:   Fri, 12 Apr 2019 09:37:43 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: reserve delalloc metadata differently
Message-ID: <20190412133742.em2476ioffybajs6@macbook-pro-91.dhcp.thefacebook.com>
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-3-josef@toxicpanda.com>
 <0098847c-71fb-b305-3f2a-392ce2737ed4@suse.com>
 <20190412132639.2be46k54avhiwlcb@macbook-pro-91.dhcp.thefacebook.com>
 <50324bcb-a6c3-c287-3d89-fb8cc9fea3f4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50324bcb-a6c3-c287-3d89-fb8cc9fea3f4@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 12, 2019 at 04:35:20PM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.04.19 г. 16:26 ч., Josef Bacik wrote:
> > On Fri, Apr 12, 2019 at 04:06:25PM +0300, Nikolay Borisov wrote:
> >>
> >>
> >> On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
> >>> With the per-inode block rsvs we started refilling the reserve based on
> >>> the calculated size of the outstanding csum bytes and extents for the
> >>> inode, including the amount we were adding with the new operation.
> >>>
> >>> However generic/224 exposed a problem with this approach.  With 1000
> >>> files all writing at the same time we ended up with a bunch of bytes
> >>> being reserved but unusable.
> >>>
> >>> When you write to a file we reserve space for the csum leaves for those
> >>> bytes, the number of extent items required to cover those bytes, and a
> >>> single credit for updating the inode at ordered extent finish for that
> >>> range of bytes.  This is held until the ordered extent finishes and we
> >>> release all of the reserved space.
> >>>
> >>> If a second write comes in at this point we would add a single
> >>> reservation for the new outstanding extent and however many reservations
> >>> for the csum leaves.  
> >>
> >> If a second write comes we won't do anything different than the first
> >> i.e calculate the number of extent items + csums bytes required, add
> >> them to the block reservation and call btrfs_inode_rsv_refill which
> >> should refill the delta necessary for the 2nd write.
> >>
> >>
> >> At this point we find the delta of how much we
> >>> have reserved and how much outstanding size this is and attempt to
> >>> reserve this delta.  If the first write finishes it will not release any
> >>> space, because the space it had reserved for the initial write is still
> >>> needed for the second write.  However some space would have been used,
> >>
> >> Each and every reservation is responsible for itself how come the first
> >> one will know some of its space is required for the second, hence it
> >> won't be released?
> >>
> > 
> > Write 1 comes in, sets the size to 3mib, reserves 3mib.
> > Write 2 comes in, sets the size to 5 mib, attempts to reserve 2mib.
> >   - can't reserve because there's not enough space, starts flushing.
> > Write 1 finishes, used 1mib of it's 3mib reservation
> > Write 1 sets the size to 3mib
> > We still have 2mib in reserves, which is less than 3mib, so no bytes are
> >   released to the space info.
> > 
> > Now multiply this by 1000, you have 1000 files with 2mib sitting in their
> > reservations, but they need 2mib, and there's no space to be squeezed from the
> > rest of the fs, so they start to ENOSPC out one by one.
> > 
> > With the new thing we get this
> > 
> > Write 1 comes in, reserves 3mib, sets the size to 3mib.
> > Write 2 comes in, attempts to reserve 3mib.
> >   - can't reserve because there's not enough space, starts flushing.
> 
> Um, no, you've removed btrfs_inode_rsv_refill so there is no flushing
> happening in btrfs_delalloc_reserve_metadata whatsoever. None of the 2
> remaining callers of btrfs_delalloc_reserve_metadata does any flushing
> based on the retval of that function.
> 

Please go read the code again.  Thanks,

Josef
