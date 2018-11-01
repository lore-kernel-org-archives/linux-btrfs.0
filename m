Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654A6C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 18:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CEB205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 18:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0BbnTELK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03CEB205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbeKBED2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:03:28 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39738 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725722AbeKBED1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:03:27 -0400
Received: by mail-yw1-f67.google.com with SMTP id v1-v6so8324787ywv.6
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 11:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZmKrdXXEZBBb8RL9x9mSy9/EupArRIzyGS4sJE/yB4Q=;
        b=0BbnTELK6vLBd7UsIlamE5vBuYeqgCzeKs+0DKAWWc63aWFhkrufwC9zpVNcUB8i3R
         u4SsBTUOPRKNb9uzzTkBoqvFRLQ7FvMu952qk1V+/ge6oUgIoYJGii6bcg0gOqD7lCc3
         u2rhLcYSk1Y7rjaSnckkilI8RaEfYxF2k9mHxzKozOJTesZvYeK/XY5VQVt/nTD1b3Cr
         9Yg0ssUxI2qOWb0kbRIvaQdvPLShMKW80BoPTo2wsXSO/ytNeEbH9o4mLdDFO3aN/wMf
         7NsunYhp/zqRIO8uq6eHTtrA8bKszX4TwNJ0k1ay0kZLXcZQqyNzUh7Nee0+ywXQxUDn
         SJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZmKrdXXEZBBb8RL9x9mSy9/EupArRIzyGS4sJE/yB4Q=;
        b=lHq+0+81nYbW/S89GEgfhbMjvsAEJxk5rOpa/oTBtxjmzTKQXNYE9AZJqyCOLfSNN6
         /MFv4AHTML3JrMe952shJ9+zphAzCokMKFLBeCICd3SZZdVKe2H8lfvlTXk+ymbnK8Kb
         xhh/rzv3LWetxVG5CPpSvVXD8mkbmSOm5Pwz99f6Mz5uUhKu/NG9qTySuwP6M5X4j5yt
         tTTp8D5Muuq5V6+O6k8Tlj2L8t1yFC2mWDyMmRxyXDXvqFNmACqu81adrWlC+RLU1Bn1
         M3RdMy1Lvc7UDY2wAhVoIK/JzpXFquzqwYzf1ZqXZSdtX+9oG8/zbuP/rE2BZIZ9WNRj
         a+FQ==
X-Gm-Message-State: AGRZ1gIQlcmcvrj/4UKvrJZ/qS5inhCc4JYDuEJX3hGGv8z02Jj8g9Eh
        jLY7gyFC2jM2S6QTBelY3c2Arg==
X-Google-Smtp-Source: AJdET5fAs5hi6T9HAOEjKxpNAoUBJfoaymAGHppRphVkj3lV4vrfozDqBtmCtc5APzGRkSp/iTf4hA==
X-Received: by 2002:a81:3197:: with SMTP id x145-v6mr8549197ywx.502.1541098754621;
        Thu, 01 Nov 2018 11:59:14 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id x10-v6sm9514897ywi.70.2018.11.01.11.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 11:59:13 -0700 (PDT)
Date:   Thu, 1 Nov 2018 14:59:12 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] btrfs: Remove extent_io_ops::fill_delalloc
Message-ID: <20181101185911.binpretcpzixragt@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-2-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:46PM +0200, Nikolay Borisov wrote:
> This callback is called only from writepage_delalloc which in turn
> is guaranteed to be called from the data page writeout path. In the end
> there is no reason to have the call to this function to be indrected
> via the extent_io_ops structure. This patch removes the callback
> definition, exports the function and calls it directly. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
