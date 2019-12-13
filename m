Return-Path: <SRS0=17CA=2D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188EFC4BA08
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D754246AF
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="W2+1S7Yi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfLMQVx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:21:53 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:39536 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbfLMQVx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Dec 2019 11:21:53 -0500
Received: by mail-qv1-f66.google.com with SMTP id y8so1035252qvk.6
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2019 08:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nIZRJE4uUi0ljEVbmM7fOvmC1VdPXwNbDiuvEiYRTYU=;
        b=W2+1S7YidDWZ7eShTuUss+jB2fR/Q3WNKkkQ8ukrZe+a9sKpTFtHslNYGwxTTnEzBs
         iStnP593HpJZLfxhxBAcRDSPUAz3+q4YWnrVtVEGvJTte6p0yMtynC/6ZE7GNq1HDP/u
         +XEjZKKvrcu/ZMi+BqJ/fJHAZNY3pd2x8qU5MTV4jwTvhP+2INt9xJESSh65lMI67lSB
         ZXcvA8Y02mGWGZVzHJaPi6rdygbxK7LLoJGwgi6zrS1viA/vrqQTynm/6WPsswQd1gQQ
         thUMpXNuCEL5SJPzMoDikxElmUNEgxeqCVmcOmJSLJfCj+SAa7TnhFzE6yiUaCICo8cv
         hwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIZRJE4uUi0ljEVbmM7fOvmC1VdPXwNbDiuvEiYRTYU=;
        b=ouA8AQmdixNnUSNNY2m8fxFRq/dnwy+o8EvEVT3KXJmp9gNuKbEx8PI+y9Z9CzuNEd
         YhYq3a6lEtti1zF3fpz4JeI1I9VhjRbhFUhy5ad0JVsaLIP33uBHQwoEwxThD6DEyKBv
         kcdnqRsSpKNwSnjoyqse+HMOdoEL1ZxERm8WENpq/52sf/Nem8y43FOqvrnHlu7FZ0WZ
         GQjSHV6144I5E6TYVuZcuUID7uA8C20d4oDuWSI5rdl728coFGf2VmwIpZ8yjyrx3KhA
         nXlz5Oz7Rka32NtdiQCNuec7+a1J4nXZIchHMAZr3TykkFLYqvu7/3Uwn5OUQfMKZ2K2
         NQog==
X-Gm-Message-State: APjAAAWD0Aofhln4iwSbXjQPMJjVXo1irQ5RtAUeicFbAaa88QX0Jj1n
        oUl56JNsmKmLojsLN7lI0PHrTw==
X-Google-Smtp-Source: APXvYqz9NbjXBFOT064bsAOiDZ+RQrjLPSdAchdLZ18nhfRmb6IvXrlMbJq9WES6Fo269U6JcDKYQw==
X-Received: by 2002:a0c:ada3:: with SMTP id w32mr13718072qvc.99.1576254112145;
        Fri, 13 Dec 2019 08:21:52 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:1102:ce0:3629:8daa:1271? ([2620:10d:c091:480::4e65])
        by smtp.gmail.com with ESMTPSA id i2sm3555499qte.87.2019.12.13.08.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 08:21:51 -0800 (PST)
Subject: Re: [PATCH v6 04/28] btrfs: disallow RAID5/6 in HMZONED mode
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
References: <20191213040915.3502922-1-naohiro.aota@wdc.com>
 <20191213040915.3502922-5-naohiro.aota@wdc.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <460f3205-419e-63cf-376b-ddc2e2e88689@toxicpanda.com>
Date:   Fri, 13 Dec 2019 11:21:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191213040915.3502922-5-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/12/19 11:08 PM, Naohiro Aota wrote:
> Supporting the RAID5/6 profile in HMZONED mode is not trivial. For example,
> non-full stripe writes will cause overwriting parity blocks. When we do a
> non-full stripe write, it writes to the parity block with the data at that
> moment. Then, another write to the stripes will try to overwrite the parity
> block with new parity value. However, sequential zones do not allow such
> parity overwriting.
> 
> Furthermore, using RAID5/6 on SMR drives, which usually have a huge
> capacity, incur large overhead of rebuild. Such overhead can lead to higher
> to higher volume failure rate (e.g. additional drive failure during
> rebuild) because of the increased rebuild time.
> 
> Thus, let's disable RAID5/6 profile in HMZONED mode for now.
> 
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
