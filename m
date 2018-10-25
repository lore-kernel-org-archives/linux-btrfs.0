Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0319DC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 18:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B4E20652
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 18:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DiqyV+7R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92B4E20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbeJZDHT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 23:07:19 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36184 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeJZDHT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 23:07:19 -0400
Received: by mail-yw1-f65.google.com with SMTP id z206-v6so4015745ywb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 11:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fgRGv3wNt1PcfoI8AIjqEaXEF/9JQN1dXHshLJ16JYI=;
        b=DiqyV+7R7DF3/oG/iinz8xqmoh9azIZa/yC+8tYQjHt3Eo5JjegNBkAWNXxbdpWTjC
         mKFPmQvQxGMvy14izsZ7MGjpDxPbxYZ2ID2SuQH0gekn51DkWwFFLmsTLVB0YAyX2wll
         tYxZevIm+AI0WUaPK6irq45EjE9nHy/kQfgw3nI8C4r8sutGkKsJ0jXfQTEBfCc0wYgs
         9Z29IlxCWzuc39rJV4J4ZMUtLe+Lyby/1q/UP8c5wzjHosAITcSKtwOzicROGzd2ukry
         9XOUesRft0zmMX6bauL4oF3hq6yETmYM90RSJ/4qpFNxRI7ngIfjZDsu1Q5neNPxHs2b
         480Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fgRGv3wNt1PcfoI8AIjqEaXEF/9JQN1dXHshLJ16JYI=;
        b=bOk5WY73E6httv9KaH56UbuhAw0MEzo2Sg24WBSOaDAYQe10RHbtbdgr2vQsxzKtE4
         k5pB6G1+8Wv095qTttt20Y7Nnr0cXu0rzA3YlQowsHdvyYWYU7GenlYOHTim/wfUPML6
         ZSomUl0I1VzAQ0cBeR0+gV3fOrmD/G5Z4xVvLYBiD6gBwcy6I85HE07aMkVR4M3cNJtP
         87bto+bJx8GUvVWwIy4ZLuPOAlKtdjyEonRGwgbbl8w89V1ASUzVuwdSoDsEqU47aJf2
         MEd+0B+OkUUGr2PbTWsYVXKAMr+L6vSsl3MeQsE3R0ldCHAWKbONI5wKwxvQ0lYlnk8F
         kCVA==
X-Gm-Message-State: AGRZ1gJNQJME0+I5sKibE7IhfrRHBwsPLPt9/XAeTuJQKHN2dONt1RqQ
        QIeei+mnWTqJabTAuzuaBrSeVg==
X-Google-Smtp-Source: AJdET5dldfWrG3USjvitI7mtZFjZLUm6/g3poPKPOF3b4aluB+pif7C+qJpSj1Me2MqVALwGIomjFw==
X-Received: by 2002:a81:256:: with SMTP id 83-v6mr438055ywc.344.1540492406019;
        Thu, 25 Oct 2018 11:33:26 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:600d])
        by smtp.gmail.com with ESMTPSA id g65-v6sm2017353ywb.16.2018.10.25.11.33.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Oct 2018 11:33:24 -0700 (PDT)
Date:   Thu, 25 Oct 2018 14:33:23 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] fix pinned underflow in generic/475
Message-ID: <20181025183322.okvvhwxrwkpu52vc@macbook-pro-91.dhcp.thefacebook.com>
References: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 08:24:00PM +0800, Lu Fengqi wrote:
> When running generic/475, pinned underflow may occur. This patch will
> fix this problem, but there are still other warnings need to addressed in
> this case.
> 
> Patch 1-2 introduce a macro and wrappers to help detect underflow
> Patch 3	the fix patch of pinned underflow
> 
> Lu Fengqi (2):
>   btrfs: extent-tree: Detect bytes_pinned underflow earlier
>   btrfs: fix pinned underflow after transaction aborted
> 
> Qu Wenruo (1):
>   btrfs: extent-tree: Detect bytes_may_use underflow earlier
> 

You can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

to the series, thanks,

Josef
