Return-Path: <SRS0=9o53=32=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A02C33CAC
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 16:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8131020720
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 16:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JE+M5Pug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgBFQob (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 11:44:31 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34667 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBFQob (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2020 11:44:31 -0500
Received: by mail-qt1-f194.google.com with SMTP id h12so5001448qtu.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2020 08:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Rn/mUtoOayvFcRXPONgkjKqwFd/uYFM1HWZWYqyBTk=;
        b=JE+M5PugGrqTkTpYlk7x5WWnal6KPMuzC4FN1qoOduabyN5nDxMN0diR/N0agbVd1o
         Hs8fT2N/IkUHYL8PCduCO9hgUa65KfvyFnJ7fIybPOQNqBsFrWfYBBMcRO77/eESmq3o
         E/Z9JkZ0kpSBMtp1pFNEUedXkiwrX1J1Ij7mTNsD5Zw57+pm/V1/Hv+BG1hvU5/tfwiq
         UjOxLT0ElJmq0exkNjP7a8K1A4ngzoepTITpZAZkx6bJzCD0MkJepKDu6Fe/Gczqt8VA
         gY4SMYQfDouXPdTZzxCstFoDbynhk/DTdOYMpS289isao0RNgGjk+KZGco0bhHT2COxF
         6zJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Rn/mUtoOayvFcRXPONgkjKqwFd/uYFM1HWZWYqyBTk=;
        b=E4a6emGB/3y+fek6rv7SKvyp/C4w2vAIrSJ5dujvNu12lHlZ2hjA4jsOu6OedL4qFf
         QUH9agiXFh1MElLEGEkEBSDP4ilqoRGTX0VW2+u+WlNbPxvJIbf9wv7iYAe+HM8plPcQ
         vTybCfpONnELEuMYzJyPLgcKQS2H3UeObc7NdIzFq5W00QJOVb3G8wOXuT47nURwJKnW
         /890zESSSCsAenv6aied/IOMMkTj9PMeKXdaOSScQkBMOhggj82gzZp/QEWQmhXPhTqn
         GY27h7CBOKYPO8DqZgXzV9pm368n77xxj96G6L5JhRmGJ7Ldveh3ZHTQOBW2HYcZINrU
         Ttsw==
X-Gm-Message-State: APjAAAVdjOJnRN6M18JdvBZQn5WPM1OJ2TCk6HcY1q61+Rpbmx4TO81y
        N6lDPob5Jal/ArvxZznYjW3x4A==
X-Google-Smtp-Source: APXvYqwCCefmaEdGqfTpmRyrF5GSnNq3KYM10FESEr3kx4D/L0PbQpmCg43f3aAXzUnkGfbPjFekBg==
X-Received: by 2002:ac8:7765:: with SMTP id h5mr3480327qtu.223.1581007469146;
        Thu, 06 Feb 2020 08:44:29 -0800 (PST)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e130sm1657834qkb.72.2020.02.06.08.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 08:44:28 -0800 (PST)
Subject: Re: [PATCH 06/20] btrfs: factor out gather_device_info()
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
References: <20200206104214.400857-1-naohiro.aota@wdc.com>
 <20200206104214.400857-7-naohiro.aota@wdc.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <b2102ead-aa15-56a3-e284-4b8c47b06b61@toxicpanda.com>
Date:   Thu, 6 Feb 2020 11:44:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200206104214.400857-7-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/6/20 5:42 AM, Naohiro Aota wrote:
> Factor out gather_device_info() from __btrfs_alloc_chunk(). This function
> iterates over devices list and gather information about devices. This
> commit also introduces "max_avail" and "dev_extent_min" to fold the same
> calculation to one variable.
> 
> This commit has no functional changes.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
