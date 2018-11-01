Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DC2C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22392205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BFLkOTmK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22392205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbeKBEJt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:09:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44004 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbeKBEJt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:09:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id r71so12967214qkr.10
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tnf8eIx7Yj6lNs2PNmGs9+2hwcvsIzSN24IrQ1kiXzY=;
        b=BFLkOTmK0+kcE0NoXbfiNQTb6KKvSDCSrfAHtncWg/lsK63BMqhTOYDQ+6GUo/0wfv
         Tv1sTBZzZqXYaj53V9ux5h2HVZMzzsM7y6deCh8jcvWerwd95IQDLMSTcuoWiaA5/aJx
         L0pBWSAKBRUv/nfGukXcWD6nqWce+LFZF1Gohrg+6O7g1UX/oLypReQ+ioPxhxuYk0P5
         9AzQvr3luIhjXDIRlJtNgSzqQvkPirlqk9qUJsbTBi8iOhTen+WxDzJ4yB8u5BdHv8qh
         KbguP7D0VMupPgM6kXbey5asVAMAxgS4D/RFd1/A/RN3YHAHIPLEndBL5OPgJDdPaJQV
         eRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tnf8eIx7Yj6lNs2PNmGs9+2hwcvsIzSN24IrQ1kiXzY=;
        b=ornMeqXI9E+gzYy9S52r9PyxA3im7ivcd8Hkrxlev5SAVwv3+7OmjEkAjyhiWqlpJ+
         Tj3gzwb7j8Ix/ZAn2oXbSTPd91javmmmLDbUeR1oTVFDZIJWcW9hzeb5JthkBLbeBiXe
         fJg3SbbAPZJpfHT8VJLOfwggieywrV7oANQgPukNgt5wkzoIAK6ARpoPFPwaZDcqz/qI
         owd2PJBjymLnXjjb3uxsw2ItPEiapr2SxiJeBTd2WO4wPiXBz4jTjBtXt/CUe1UL0+gg
         bzMdY6Hdh2CXKQuVgB64+bqueo2/2WzOTmNWmcAFa9+cjyOWoI68fjb81amk5Jn3DL9c
         +i3Q==
X-Gm-Message-State: AGRZ1gImSwa0X7bgKWm622FLAV72QjDvNC6ZeLGW2RMLkUgRKeLMPSyL
        gBpnd6K5NCrBtQVnJePAx9TjDw==
X-Google-Smtp-Source: AJdET5efdvyEGAc3A5SwFFZbf9d/lXb4ZnLTxO2W+TZNnTBhuKOdrTuR37TCIGAzMG4jOGiGmbM8dw==
X-Received: by 2002:a37:cf43:: with SMTP id e64-v6mr7594380qkj.24.1541099134444;
        Thu, 01 Nov 2018 12:05:34 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id g2-v6sm7707247qtq.62.2018.11.01.12.05.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:05:33 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:05:32 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/8] btrfs: Remove extent_io_ops::check_extent_io_range
 callback
Message-ID: <20181101190531.qa3wluouqairupsi@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-5-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:49PM +0200, Nikolay Borisov wrote:
> This callback was only used in debug builds by btrfs_leak_debug_check.
> A better approach is to move its implementation in
> btrfs_leak_debug_check and ensure the latter is only executed for
> extent tree which have ->private_data set i.e. relate to a data node and
> not the btree one. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
