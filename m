Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC136C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 17:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7735218A2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 17:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHtLy17I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfAYRAC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 12:00:02 -0500
Received: from mail-ed1-f50.google.com ([209.85.208.50]:40324 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAYRAC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 12:00:02 -0500
Received: by mail-ed1-f50.google.com with SMTP id g22so7900316edr.7
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 09:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Q8f5vKZYlSq6ol8YBvQnEnFA8SHVbG8+Uir0uryJqj0=;
        b=HHtLy17IVdfAMDkCq7BBq9neXAsHLyTkHBAAXaTJwvrm2/3jnBm+snFeqW8fy3SUWB
         aOoFefhcpRPsirQB6jqlKdgH4Sh+QJnbgLlK3LUHiwzy4oG93gsELvc3f4LFyRiGYyrt
         zH1cID+IshvGzPiMvC4/rWaYlvUByFSYVpMPNvVpod8UZ8maPDqfRqIg8qZwl0vvZ4IX
         586Et3V/Y200lhpY1RpAplZhlPwF5k9Ww2j3xWCYhdbMLmlQDqQrzTJStSn0No70WFoE
         hZTmSbXinCFtrwJozKecoxnEHj6hgqdZyJCw63QWCZpcTMIyL1J7fmqkF6/68GyWmhYk
         hwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q8f5vKZYlSq6ol8YBvQnEnFA8SHVbG8+Uir0uryJqj0=;
        b=SmerILFSqe44K+0B5jKcy8sY9ZoXmfDYyiFCuTV8US7TR9iV5swPQx967XAwJyLhxI
         ylH7PBUUBZr4eWXy8WyCo13M3YmX6cH4o923HLE5KDlfGaLK5lSyRKG09MjiJzvGZgP+
         Ich8r0Uoq2eH2xLwkalxi4w7RS3Hi6yzTZcP0SGQJF/ug6IgEL/oQPpNRaQrcwAK0wJt
         Fvqa0aDHPo0hPEtg7lxhkh9yw15WqSmASezTR6ODLmsQ797pYKwJX6fWxm214polLX4S
         HRqMY9Tv7eXsW/NfULB6ZN5ymaDAj45eRPaxm0/gNzezAj34v5wJiSxbT/55X5xyVMuX
         aXyg==
X-Gm-Message-State: AJcUukdz/uqsA3HzIRdZkj6/4griOP6/9Fw9FWo/afVhGNWFPsfe1INK
        tgQfnKDzaO5n4O4Hfiy5MfGoWfMo
X-Google-Smtp-Source: ALg8bN7ob3TgahkA7XTCdiieRs13IasOVhsKcNlX/15f7H6YCOJ/1cXKiXGusDV8T2uMCVD79AppaA==
X-Received: by 2002:a17:906:9a2:: with SMTP id q2-v6mr10140098eje.247.1548435599950;
        Fri, 25 Jan 2019 08:59:59 -0800 (PST)
Received: from [192.168.254.12] (ip5b4244e9.dynamic.kabel-deutschland.de. [91.66.68.233])
        by smtp.googlemail.com with ESMTPSA id x38sm12123416edx.24.2019.01.25.08.59.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 08:59:58 -0800 (PST)
Subject: Re: Retrieving CSUM-Tree
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
 <a0e58490-8610-2b86-751f-772625fdf0ca@gmx.com>
From:   Tobias Reinhard <trtracer@gmail.com>
Message-ID: <91b98362-9019-3199-990d-072466b1b455@gmail.com>
Date:   Fri, 25 Jan 2019 17:59:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <a0e58490-8610-2b86-751f-772625fdf0ca@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 13.01.2019 um 12:02 schrieb Qu Wenruo:
>
> On 2019/1/13 下午6:19, Tobias Reinhard wrote:
>> Hi,
>>
>> I want to read the complete CSUM-Tree from userspace. I tried it via the
>> ioctl. This is what the code looks like:
>>
>> struct btrfs_sv2_args sv2_args;
>> int fd = open(filename, O_RDONLY);
>> sv2_args.key.tree_id = BTRFS_CSUM_TREE_OBJECTID;
>> sv2_args.key.min_objectid = 0;
>> sv2_args.key.max_objectid = -1;
>> sv2_args.key.min_offset = 0;
>> sv2_args.key.max_offset = -1;
>> sv2_args.key.min_transid = 0;
>> sv2_args.key.max_transid = -1;
>> sv2_args.key.min_type = BTRFS_CSUM_ITEM_KEY;
>> sv2_args.key.max_type = BTRFS_CSUM_ITEM_KEY;
>> sv2_args.key.nr_items = -1;
>> sv2_args.buf_size = sizeof(sv2_args.buf);
>> ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, &sv2_args);
>>
>> But the device is not small and I hit the limit of the
>> btrfs_sv2_args.buf which seems to be 16 MB.
>>
>> How can I get the *complete* CSUM-Tree?
>>
>> Limiting to offset does not work (My first idea was to do it this way
>> and get it in chunks).
> That's strange.
>
> Are you still using 0~-1 objectid and 0~-1 type, just last_offset~-1?
>
> Have tried searching using the following parameters?
> min_objectid = max_objectid = BTRFS_EXTENT_CSUM_OBJECTID
> min_type = max_type = BTRFS_CSUM_ITEM_KEY;
> min_offset = last_found_csum_offset
> max_offset = -1

Sorry for my late response.

If I set

min_objectid = max_objectid = BTRFS_EXTENT_CSUM_OBJECTID

I don't get anything. I have to set it to max=-1 (min doesn't matter).

And in that I case, min_offset and max_offset doesn't matter - I always 
get the same result. I can even use "wrong" filters like min=1000 max=500.

Tobias

