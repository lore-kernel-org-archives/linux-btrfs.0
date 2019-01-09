Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE02C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 17:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4AFF20660
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 17:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gi12nxpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbfAIRU7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 12:20:59 -0500
Received: from mail-ed1-f49.google.com ([209.85.208.49]:45950 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfAIRU7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2019 12:20:59 -0500
Received: by mail-ed1-f49.google.com with SMTP id d39so7908144edb.12
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2019 09:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=FKiLf3nu99O67yBAAN1B34Wm+P+pCJsl8LdRcmEUsIs=;
        b=gi12nxpnIxzwxXINkBhDIEP3PJK7CCjypP0t70HEMoo7ScxzRMUVAiFlvzFVOibPGb
         IqyDI6vtN8mn0Gh3F+4eifXqd+cg6U1tOEjJo+8lpTyv+zJ9TPNDeNhDKFet7c3reoI2
         RMLG2cKtUh2i+mOzAd9N3tTGS2OKrs8yu74vk0tU0SXuwJfh+NrDkSZy8fGEuzx6fPRD
         WSE05/bOCcJyU1FKqBCFU1dYhAwlqyI5WH2rnmkVKvz12SWhR+9aeqfeO82IMBYjSY53
         zf71Pi3XtmzeKVR5vRtD/kVHArMcaVoo4H6PZuSSlv9uAaz4BR+GnvamEor7nKFI7GHx
         /3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FKiLf3nu99O67yBAAN1B34Wm+P+pCJsl8LdRcmEUsIs=;
        b=JUylUS6mLBaiERlwTOMKRYCAUTYIjrX5hHLXQQ6wq+eqAaXmrvoURQz6Wno9VhTwsw
         4VzsBZ35LFD8eZhMiO1WYx6IAZLVSzlMPE7c9kFrsVgO8Urs2U4Avb30ftSmsQmYYtBI
         Fgj+6VxGri9aseW4VkQtgeN1NrpJYhR+Msyb0LfV8S8iK1GikZbKIgIISDrkzpLiBgve
         lftAc0vEau+4iDkiwNQIweDEz3lHXuFxStV2/Orc+R0ePHmriao3MZS89SKI8nBcEUJ+
         S8G0mghYPqFj/NHiduVq0Z84dQ7FgtM/wqxBtkygZCtvhkluJlAtQflS9Iz40TSByMfC
         edLQ==
X-Gm-Message-State: AJcUukf9MggpqCy6W++koKQg/PRntVlwdYrfZTk5HGbGHFOxhRbTOdnR
        96bcsm/chBU3cPb9YUHGgafUep0d
X-Google-Smtp-Source: ALg8bN6beLzV7Pjuck5lq38QuFqEAJvwMSIWCJ4yZ3sdQSesFOqfzmVe2eupMOfy3ZOe+MJIvHTWYA==
X-Received: by 2002:a17:906:7cd0:: with SMTP id h16-v6mr5934108ejp.207.1547054456995;
        Wed, 09 Jan 2019 09:20:56 -0800 (PST)
Received: from [172.26.1.3] (085083086107.dynamic.telenor.dk. [85.83.86.107])
        by smtp.googlemail.com with ESMTPSA id j8sm1213402ede.55.2019.01.09.09.20.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 09:20:56 -0800 (PST)
Subject: Re: Balance of Raid1 pool, does not balance properly.
From:   Karsten Vinding <karstenvinding@gmail.com>
To:     linux-btrfs@vger.kernel.org
References: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
Message-ID: <64cf0762-bd59-3d77-8aca-94622233767f@gmail.com>
Date:   Wed, 9 Jan 2019 18:20:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: da
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just a short answer.

I didn't use the replace command.

I added the new drive to the pool / array, and checked that it was 
registered.
Following that I removed the 1TB drive with "btrfs device delete <drive>".

As far as I know this should avoid the need to resize the new drive.

"btrfs fi us" shows all the space as available. The drive shows 1.7TB as 
unallocated.

I have started moving some data of the array to give btrfs some more 
room to move, and will follow what happens when I try a new balance 
later on.
