Return-Path: <SRS0=RqtL=C7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5001C4363D
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Sep 2020 14:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E42E20C09
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Sep 2020 14:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="q7n9Aza1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgIVO1Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 10:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgIVO1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Sep 2020 10:27:25 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C06C061755
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2020 07:27:24 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id r8so15651348qtp.13
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2020 07:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Umb4lQ90QS/WxTLGtQLywQ7iLAl1vTbp8ZbFSXQ28N4=;
        b=q7n9Aza1hccHsrGwFlnTPeiqb1Bjg+8JT9W+anVwJCJ+5FXKgTRngPP3dTDloXl5L6
         iS4faLVrjaPcv50R9W/wVkZo4R64lWVpkbkhyV+MFgnyLSCrhUgkbZ+NnpKdD9hVvlV/
         FHqknzYIV1nXm79dDuvvVNGj9Nm6XZ6FyvC4a2JqWuM9/HvOmWCp2SjxEYLHEi6ww1GL
         3Toh558H8g4McMOMNyTrfka2yLMwZ7dkvMKsi9epFpjSBsTaIJ8DvAxRIFDExNaO3tAq
         QZ3A8bVVc76048yejPpN3t8XbzoZL0BpRbEd0E6Ghgt98RfqkQZasCWIdf2HZ4QyAUEx
         bIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Umb4lQ90QS/WxTLGtQLywQ7iLAl1vTbp8ZbFSXQ28N4=;
        b=E0wnO1UV7KfEM79vZ569ZkM1zAyjrkQ4LSMUEhfTEx9pCQ+JuvTpbBfJ9eQgTY5Np3
         VsKY7acMsQXh7vUwASACUIUx3NX8bGBaNnJfu9Jn3EMczVBCxzz9VeIeakV9514Akvdp
         PsNRFBgbkxk0G/UoZKt71YSGXBDRVM4Mhb/fEKWAFQb+KDH9S/jOrKIBVr6YFEZ4PzRB
         NcY++aw5iEgKkTV74MBKiFFMyYt7eqgalAEUv47XuLAFI0l8A+MqjEsXk9qZlkeVA7mf
         OKDbE0qUmB8jlfD/r06sqkJcJpZVSXmBZWtFfGRQQN+eRXsL+HK+7HX6toNYej7I8DsC
         VpXg==
X-Gm-Message-State: AOAM533ECrq9CK363dha8ycELA24PDuggDrfHRaik1CAJNGvg42BNJYs
        HZioiOJrykTWdCl+RbjVS55mzA==
X-Google-Smtp-Source: ABdhPJyxQUtlJ1zoHc8wPOhYPEbxIEOasC9SbUT77mgbPp2BbBZZD2ZURfUD+SKImfc/6oku31uaVw==
X-Received: by 2002:ac8:4a93:: with SMTP id l19mr4954975qtq.163.1600784844145;
        Tue, 22 Sep 2020 07:27:24 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id s18sm11540163qks.44.2020.09.22.07.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 07:27:23 -0700 (PDT)
Subject: Re: [PATCH 05/15] btrfs: split btrfs_direct_IO to read and write
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        johannes.thumshirn@wdc.com, dsterba@suse.com,
        darrick.wong@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20200921144353.31319-1-rgoldwyn@suse.de>
 <20200921144353.31319-6-rgoldwyn@suse.de>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <361a3f24-ace4-497a-2254-84a4ac0449b8@toxicpanda.com>
Date:   Tue, 22 Sep 2020 10:27:22 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200921144353.31319-6-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/21/20 10:43 AM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The read and write DIO don't have anything in common except for the
> call to iomap_dio_rw. Extract the write call into a new function to get
> rid of conditional statements for direct write.
> 
> Originally proposed by Christoph Hellwig <hch@lst.de>
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
