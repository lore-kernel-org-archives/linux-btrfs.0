Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56078C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1971220657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:12:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="oqynltCs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1971220657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbeKBEQX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:16:23 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46792 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbeKBEQX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:16:23 -0400
Received: by mail-qk1-f195.google.com with SMTP id q1so11305621qkf.13
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LUFQUsiRi/NjG8GU6O5x78GpjHkoMKcNAbLRRi4atoQ=;
        b=oqynltCsDddrIEJ1Umugv4a9Wtj8e33mwhow10KbzSIrfETRyRa545Woa8/Gr1UEN8
         J8rBleQGMncOY3uAP+9nWQzu6+Lzxz9BcKdfywgVL7PrGvWHI3QAuJqACStoVIdbUtSH
         /yUmh5czRurCrG8msE9az8mgUVIusoDUXEqSus30OkCAfEfHL1QK5GZKNLH9xtB2Jv8V
         5IYvwy/LUWtVO1P1DvsAnjYdDZ5SLaHSx8KuJZKrWppMJjKWyP2vXnEoNQ7v+NVLckun
         nd9Ye+HNqlv1f4cWK2lEFKmBYdwLgRccJb4O01nudGDBST1C+txzCHAcFikJBq5A7iRo
         dL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LUFQUsiRi/NjG8GU6O5x78GpjHkoMKcNAbLRRi4atoQ=;
        b=ZkHCP4wir5sLbputb2qmBy9ZL5ju/Jq9qkzAwxbY1UcK9jQS+YJnvAmjKz/L2esW/y
         ihpRYmC6TMjMQ+wsxlJhOO+wSDpLa3m5xkWZdQIxAwXhUJ+ey1Ie1YTGxJaG7lQerCqZ
         TMMy/Q1tGObTOV5uvhmgzaLUJRwOU2gRaxRVxRuBMUz2QqLRt0pkhTjXldx1Gk3fXe+6
         65sHRInMu7a4ylCG95gkF1xZq9lVDgzi/2lJreF+b37tTiPRoIaPy6OM7XziVBGBZ0/F
         FqxFWph/SKMZJ/YneLQW8DSnhl386iAPdGsifSfR8Px7C/vRih29apactmNeuX08IerW
         lc0g==
X-Gm-Message-State: AGRZ1gJxDdzmY9JNaUOmiJTCJB7j2QyZB2p6yi2NBdjdfeLny4ZE3DoY
        FXMzvcEKnzd2j8b0wIbTI65vLRjsCtnBKA==
X-Google-Smtp-Source: AJdET5cCNskk2S7/XIRlsNXCueWX+1+Y0lHsj40cmf+lYkJG9jKEeFQUKRNBhvI6ipBoYc703EzUvQ==
X-Received: by 2002:ac8:51d4:: with SMTP id d20mr8112379qtn.365.1541099527177;
        Thu, 01 Nov 2018 12:12:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id 24-v6sm25731024qts.19.2018.11.01.12.12.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:12:06 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:12:05 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/8] btrfs: Remove extent_io_ops::split_extent_hook
 callback
Message-ID: <20181101191204.ugyudht2tolti3na@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-9-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-9-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:53PM +0200, Nikolay Borisov wrote:
> This is the counterpart to merge_extent_hook, similarly, it's used only
> for data/freespace inodes so let's remove it, rename it and call it
> directly where necessary. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
