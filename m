Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7A0C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7452220657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="eWrJU5+9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7452220657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbeKBEPt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:15:49 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39345 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbeKBEPs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:15:48 -0400
Received: by mail-qk1-f195.google.com with SMTP id e4so13001202qkh.6
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1cQOr9TLB+gYLK9jijimk+knJS+skirPK/kQKl1Wz4A=;
        b=eWrJU5+9aBaxuCFCOB2l7WFzokDsQTeYWdFR7E0ZFFBj4ife/s1qvoIg13Hr7U8kbn
         +ID5xhBDjeQhw5qTFItlygAvZ5rGyRQiIXaNTMzTHQA2ilEytI55TFz30yMP196LkuG5
         /9rv52OaLCWFpI65rDIgAHN4ke9K0g2BNiOXmhdFqPCrdA0VoShzA+QSWSSVO7aVBJn0
         ahR9dTWmhNw/GHf2nNdkjj1wPxmaCgNTSY2uxWadDWMVXrTZawUgGCA5EmH/LynTrtOH
         qUeqdAtWFYakRAi1Xz8cWVjK4qH3+kFh8823fY3yGHdqWCNk/b9fjLPUw8KWmo3Wp3oP
         xszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1cQOr9TLB+gYLK9jijimk+knJS+skirPK/kQKl1Wz4A=;
        b=WgKbcSt7qm5d9uE4uwieJL2xy3usS8ijROmIvpqyh4Xc7K6sf4zBELRcbYcb9piv8q
         yMF4BsRXl3Hi8pI+wET097l2Fy5ajyFQuAGTU/CuizjjPLqud5GWJy9LnM9QGpgVnAhU
         jo5lpSKwYoRgcOFPpUqrn5qXvRQgR5+elsi/EtdfYoX8t2t/HvizsrnTAHilapmc+2Ky
         cFdZ4+HkcUbe85dcSA+3FyfpLoSfz2C8sRh1/MVdDGRYTSuCt2OBXzpmjZY5PKF3KZe6
         SoNBe37I5otZM8Iw1vFKWzRw7K2xqss7ScAC57fl/1xznNYVo0k5bXwStkGsb07eCV0Z
         ozdg==
X-Gm-Message-State: AGRZ1gKp9KCT2U49Ie1/VAdWbUn08poAhIVbZkWkM+uJ6apXK55dHBlp
        /7jM5HUa5lar3Q/q8k1qjUSBhwz5XLkH/Q==
X-Google-Smtp-Source: AJdET5eLECx/UvgzmBm3WEsgDh2xtC8FkEH8F5zgnsUu/3QlQo9phsmXIyndJq3Xlr9nIDeHdA7hIA==
X-Received: by 2002:a37:1956:: with SMTP id k83mr7452618qkh.344.1541099492918;
        Thu, 01 Nov 2018 12:11:32 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id o27sm10983940qkh.35.2018.11.01.12.11.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:11:31 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:11:30 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/8] btrfs: Remove extent_io_ops::merge_extent_hook
 callback
Message-ID: <20181101191129.f5ywd2ggdj67pkli@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-8-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-8-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:52PM +0200, Nikolay Borisov wrote:
> This callback is used only for data and free space inodes. Such inodes
> are guaranteed to have their extent_io_tree::private_data set to the
> inode struct. Exploit this fact to directly call the function. Also
> give it a more descriptive name. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
