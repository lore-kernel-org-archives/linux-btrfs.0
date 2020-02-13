Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEBFC352A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 19:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1344D20659
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 19:56:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="mGgyARF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgBMT4X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 14:56:23 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45502 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgBMT4X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 14:56:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so2749412pls.12
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2020 11:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K41rHHi78NH7LfnbsNtGm7/8ce/4IeglCRKrQ/Gun8E=;
        b=mGgyARF6j4JPeSWqZxDivC8f2Bi2TUaNW5xImU+P17YbZar4epuTICYd3DSr86v6xH
         He1Aspypu9/OJweMih2DAl7pB+FxVJ7DPh9QY+Cy2l91KF671ldihRa0g6HWEDFVB8d0
         SeI5ZnvFqaxyZkju8z+X2BAlHzhMnag2dKMZ6+Mo8jKoF+3bBB899DpogsKcLKyngv+a
         C/62F61mBQrmg8gc3L/I6j7/NhLs/Go+w5ZL+lQsAnY/+spahuttFBC2RzEKL7/g4EyB
         r2M9AK4CjhNrrfmcX1bXe0KArh0ELjdm1Izb4gwEgd5+i1PekqHbNF+LXit3G3S9lt6a
         37gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K41rHHi78NH7LfnbsNtGm7/8ce/4IeglCRKrQ/Gun8E=;
        b=U7cu/DoMcZjrD0j7JzRkioCFp80U37vKo2TEEAG6QzH7wDYo7gsqzrGCXbMuiaiw0g
         wJimmT1DgoLicAtZneSuaWuPL7bmChK6/ORgiHaCMNNEJ2n0yjWyAzfYoC88c9S+Yy+D
         0QUypSNAS9fUnKsZpFmOvE0pMgI+QBV3oMlkJcgEjyMR/uJfK7yLWFVYpQ9Ew1/bB0wQ
         kYNjkbiTcPqtlKIKq5saE34VubxacLUu9k9Alc7glcUYtvwg467bgPcIVQsI5034AjM5
         kz2jv4F4UEXjHHxzrbSMH7w273hylsP6HA69YXUY1fxuqp33ykp2Vf5/bewdigmVpWhm
         eg2g==
X-Gm-Message-State: APjAAAUlRDQNpYBMM8pxmLE9mWOnmFTWy3aBbH93CMtm8q+VDOzMpARN
        Bwpt1e2tajRjqIqBLGI6H64A8A==
X-Google-Smtp-Source: APXvYqxyKzKrO2rp0oGEAYSrfeFdE5J8xB9bW0kGRxwWOaZa0TqvQmV+CK5qur4xkVDni04K5c06hA==
X-Received: by 2002:a17:902:8d8d:: with SMTP id v13mr15280086plo.260.1581623782574;
        Thu, 13 Feb 2020 11:56:22 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21cf::1150? ([2620:10d:c090:400::5:249c])
        by smtp.gmail.com with ESMTPSA id g72sm4317874pfb.11.2020.02.13.11.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 11:56:21 -0800 (PST)
Subject: Re: [PATCH v2 12/21] btrfs: move hint_byte into find_free_extent_ctl
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
References: <20200212072048.629856-1-naohiro.aota@wdc.com>
 <20200212072048.629856-13-naohiro.aota@wdc.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <c883e3b8-246b-b5a2-6aad-405759755648@toxicpanda.com>
Date:   Thu, 13 Feb 2020 14:56:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200212072048.629856-13-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/12/20 2:20 AM, Naohiro Aota wrote:
> This commit moves hint_byte into find_free_extent_ctl, so that we can
> modify the hint_byte in the other functions. This will help us split
> find_free_extent further. This commit also renames the function argument
> "hint_byte" to "hint_byte_orig" to avoid misuse.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
