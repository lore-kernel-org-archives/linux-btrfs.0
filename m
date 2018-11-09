Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B4CC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8213A20827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="TPEXY4OV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8213A20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbeKJGpv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 01:45:51 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39795 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbeKJGpu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 01:45:50 -0500
Received: by mail-qk1-f193.google.com with SMTP id e4so4078955qkh.6
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 13:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bi2vjl1EQhgJ0IlOUqThH4gzTe0FeVjG8dA9dN6O3fY=;
        b=TPEXY4OV+eEpW9hqVXUHwFZQVWDonfRN+wgHGdDxKrwpTHDbWbg5bd06rXtzyFfHIC
         TAbj9mcdBXuOEu8dcxMUKYeM7wC2NFbUXEQV3doh/Oii9+nYtOVvm1HlIDOgQ5gr2EQa
         QngRWDj+AiyMuO0eMQfz4Rr4/R4YRi8OMaCdz+T2LdlbEZemFArUN+hHiKJ+CLP2hsH0
         XcsjLtwEhQ/hcxyR4GcPYQEVHmVR5BZzN8ciCu1StCEAQWyhGD+Iuu9CxFP/IpQp5tzL
         zlifhzFGnbDMhUaI3dyhf8cQjWsJSjBfNyajLiD7Z5zyNE/ZBcjLxNAkgeyTYIXKIUaV
         F1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bi2vjl1EQhgJ0IlOUqThH4gzTe0FeVjG8dA9dN6O3fY=;
        b=GOLBTNXaP/HuwfGlf5AuAemDBDLtTlt5FmvP4Dv88A1f0aXWP1w0dyP0BGUTebBD4L
         uWnefO9Wm/GwGUBH7jhBFr0I43tJO/MurfInYG2im9tnp5D2IDNUaYClXCF5nrOVUYL9
         DaSoiWVPJHXlIb8sma+EEU4221iU1FEQamiaxTD1RtNv8x4whGwKPWJCry7/1YLs+yvS
         USBsVwBAPmitL/GUFGWVLgWfbbHTAiroSCWT73r1xpx30u+TN3vPGjiENC+5ovSJ02/r
         U+oYwchYQpIyEipiI4Q9wWIH5bZ0aYmOUaJmZNS+u8dIXKfuyoYWMGJejZWT0X18/YFz
         krMw==
X-Gm-Message-State: AGRZ1gK3FcLvyd7jU3zpc5K7yN3nH8rVJlyOaNBCxc52HPFRndopzwKv
        6vmO0K9GnpO/c/SHk8Q6BeO7UA==
X-Google-Smtp-Source: AJdET5dV8xGosUpiiF1TY/DG8d22taZZYtzMbTL3bsZdY2MtxqNfgX/uAPbspeJDTuAdUYRK9/6WUg==
X-Received: by 2002:a0c:b5e3:: with SMTP id o35mr10514908qvf.164.1541797411385;
        Fri, 09 Nov 2018 13:03:31 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:42b3])
        by smtp.gmail.com with ESMTPSA id c45sm6218993qte.66.2018.11.09.13.03.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 13:03:31 -0800 (PST)
Date:   Fri, 9 Nov 2018 16:03:29 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Check for missing device before bio submission in
 btrfs_map_bio
Message-ID: <20181109210329.6tfbay7ockbgwjwf@macbook-pro-91.dhcp.thefacebook.com>
References: <20181108141638.31681-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108141638.31681-1-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 08, 2018 at 04:16:38PM +0200, Nikolay Borisov wrote:
> Before btrfs_map_bio submits all stripe bio it does a number of checks
> to ensure the device for every stripe is present. However, it doesn't
> do a DEV_STATE_MISSING check, instead this is relegated to the lower
> level btrfs_schedule_bio (in the async submission case, sync submission
> doesn't check DEV_STATE_MISSING at all). Additionally
> btrfs_schedule_bios does the duplicate device->bdev check which has
> already been performed in btrfs_map_bio.
> 
> This patch moves the DEV_STATE_MISSING check in btrfs_map_bio and
> removes the duplicate device->bdev check. Doing so ensures that no bio
> cloning/submission happens for both async/sync requests in the face of
> missing device. This makes the async io submission path slightly shorter
> in terms of instruction count. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
