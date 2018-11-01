Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBBCC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB5ED20657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="2Dhk051M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB5ED20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbeKBENC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:13:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43925 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbeKBENB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:13:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id r71so12986433qkr.10
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=giuSUSunmYsz6Uas3Hn1Yli8ie5V89NHA1wFlcRn8jc=;
        b=2Dhk051MIfrhSRsoRFqYmun/OXUYTVwSW4V7y4QQRclPyFhTS4JbTM2Yt6jobYXdsB
         EM3hnzT0t3lUUxvV1onXn80MbXaFpJ8VXFagmllAejnX0BXlX9Fx3oTx/cCdTdxCNcG9
         8qr4c4v7p+lu0RDDy5mxlbb6QYsOcFrISIsK06jjU44p7Lb84DQ3hN5Mc9+C9u5eSqe+
         mt7hmaeAjynv6+Lvq3G1KcBV+PM0FBBOhaT8NGJzR9wBf+quk5H72+lvqam48rEJznn/
         3zTLnMJI8oX1BppVYc5ZVsLqlLGkHUKTP2WUeuD/A2bHPhecERVyzOEbRrbnOzfd4lrB
         4LtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=giuSUSunmYsz6Uas3Hn1Yli8ie5V89NHA1wFlcRn8jc=;
        b=d9PcfyWp3zvkWKRCxsZ5IVEuKhGmPeJ2mj99R3kn7lFGw3kvf1WHVgrtNy7GiLSgtZ
         M5D0XLNqw3TAKRThhBdE4/9jCOjqDfBtJruOc0P/+LPkDXH24AG3ulUL4ZevEbT4WSb3
         oSEsDA0/Zhy4mUEADRd4g2EozCA4CF5MJYu1e9vcNK8TGJN+0hvDce8zg9GD9pIsO6lF
         ed5Wv82OvWdOGTcz0K9RSnuheragIihn9TarDqYij+0EufyNqliGDCEs1708xQyNA3KT
         uty7UwaznH79Bj0WNkbYKsYA4YX8L+y+J1Q0ncTRBAslW07gAmDRw+AvTtppiYGCZg47
         1yEw==
X-Gm-Message-State: AGRZ1gLARXeLLCOWIDmgzvTKN7IucABUE8lwsmd8tRZbY8C+J7MZYRMr
        UlOh8G0FY5S0isf1bX3lMHr/yHRjxsLVGA==
X-Google-Smtp-Source: AJdET5eSWWayOTi9Q/fmML25xsII+MhXHx6r0U3iA8G0zUQXLem4D+ZkeyUGDgjSkRaeki8hVW6xjQ==
X-Received: by 2002:a37:3c4c:: with SMTP id j73mr7597409qka.298.1541099326506;
        Thu, 01 Nov 2018 12:08:46 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id k1-v6sm19773632qte.76.2018.11.01.12.08.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:08:45 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:08:44 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/8] btrfs: Remove extent_io_ops::clear_bit_hook callback
Message-ID: <20181101190842.hozbilzro4bb3lus@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-7-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-7-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:51PM +0200, Nikolay Borisov wrote:
> This is the counterpart to ex-set_bit_hook (now btrfs_set_delalloc_extent),
> similar to what was done before remove clear_bit_hook and rename the
> function. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
