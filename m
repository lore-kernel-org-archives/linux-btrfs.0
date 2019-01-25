Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAA3C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 20:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3FD207E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 20:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXHEji8R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfAYUpc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:45:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40933 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfAYUpb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 15:45:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so11697334wrt.7
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 12:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=OEX6Duhc14MQui1VnCbdSd2vdXeuL/610/7RlbaN+pI=;
        b=uXHEji8RR8IsRX6GD+XbxFo+yPUC2Ccaa6qMudRp22hkg5Tbm3QylCqze3bDg7bfSi
         yf7DDV6/y25jEmjUgt0cyUr63zlFjsfXoS6un/+ovqq7gNqu5XzXAj3r1e76XxCUS9U7
         gaPchaSo3GXzusSLSj2tjFtD1hV9rp0Nn4WWFirW244m9eiTT8sJf66zyTwy8+yD2f4c
         rHFqRaymW9Tz+1OoL09kvyVlTpMW9j+pCRVhBXmHPf9dUQs83wQGIwjA49bVkMKhhBtR
         UKlY/bt1RV2bnLKkTCJmVPrFhClnlW1NnZbFehJkRInBZF5zBEW5YZXtQnLQCIjAb/94
         uNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OEX6Duhc14MQui1VnCbdSd2vdXeuL/610/7RlbaN+pI=;
        b=Hy82jR8Ef5ptA2SYFtAySjID4X1niDl/TmjhGSHzOMSbV0s4ba+05U4Uv9kA5S7YVQ
         V6HatIiCOq1Bm6thPO0GCdYWrXF7qesBeUhUi0AoRxTu9eCMKTE7nCPFqE07lZ6XSKag
         nC6tPCb9NextNlqNoGLysG0DfvGShaCLVhaJ0fPQRs44fqf0ZGJTvIgrMqMtmwe81kkw
         dVVNMH812SliZ2we5LKG13VslOlfgf4A7F8uacQhUOXSgLtDYC1G/lNrSIDz/QE/864s
         P6yB1K1lN2xqJn03RLfA73aBcSqJ5SJ4uzuCqYay4H67M2wVnUCBmpV0F75bE+LA3PiX
         oRcA==
X-Gm-Message-State: AJcUukd29K/+eGxHxAot/mQwrdLakJdEdFrd6Wq8yuh8f9TFCPlIjAjW
        wjs/ajufCS2ZbcQ47ghGP1GVOPgi
X-Google-Smtp-Source: ALg8bN7hYnp2KRoj05nsEYcO/R9a0tfTo5QR+qiANijU0w4bWgHIfBmyUn35MYkBu14DSymc9RXFSw==
X-Received: by 2002:adf:92a4:: with SMTP id 33mr12804391wrn.11.1548449128962;
        Fri, 25 Jan 2019 12:45:28 -0800 (PST)
Received: from [192.168.254.12] (ip5b4244e9.dynamic.kabel-deutschland.de. [91.66.68.233])
        by smtp.googlemail.com with ESMTPSA id y12sm38331206wmi.7.2019.01.25.12.45.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 12:45:27 -0800 (PST)
Subject: Re: Retrieving CSUM-Tree
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
 <a0e58490-8610-2b86-751f-772625fdf0ca@gmx.com>
 <91b98362-9019-3199-990d-072466b1b455@gmail.com>
 <dd3a0062-ada9-ee2c-95f1-6376514e8c9b@mendix.com>
From:   Tobias Reinhard <trtracer@gmail.com>
Message-ID: <e56eccf6-7c6e-3601-5068-95d700c60351@gmail.com>
Date:   Fri, 25 Jan 2019 21:45:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <dd3a0062-ada9-ee2c-95f1-6376514e8c9b@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 25.01.2019 um 19:05 schrieb Hans van Kranenburg:
> On 1/25/19 5:59 PM, Tobias Reinhard wrote:
>> Am 13.01.2019 um 12:02 schrieb Qu Wenruo:
>>> On 2019/1/13 下午6:19, Tobias Reinhard wrote:
>>>> Hi,
>>>>
>>>> I want to read the complete CSUM-Tree from userspace. I tried it via the
>>>> ioctl. This is what the code looks like:
>>>>
>>>> struct btrfs_sv2_args sv2_args;
>>>> int fd = open(filename, O_RDONLY);
>>>> sv2_args.key.tree_id = BTRFS_CSUM_TREE_OBJECTID;
>>>> sv2_args.key.min_objectid = 0;
>>>> sv2_args.key.max_objectid = -1;
>>>> sv2_args.key.min_offset = 0;
>>>> sv2_args.key.max_offset = -1;
>>>> sv2_args.key.min_transid = 0;
>>>> sv2_args.key.max_transid = -1;
>>>> sv2_args.key.min_type = BTRFS_CSUM_ITEM_KEY;
>>>> sv2_args.key.max_type = BTRFS_CSUM_ITEM_KEY;
>>>> sv2_args.key.nr_items = -1;
>>>> sv2_args.buf_size = sizeof(sv2_args.buf);
>>>> ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, &sv2_args);
>>>>
>>>> But the device is not small and I hit the limit of the
>>>> btrfs_sv2_args.buf which seems to be 16 MB.
>>>>
>>>> How can I get the *complete* CSUM-Tree?
>>>>
>>>> Limiting to offset does not work (My first idea was to do it this way
>>>> and get it in chunks).
>>> That's strange.
>>>
>>> Are you still using 0~-1 objectid and 0~-1 type, just last_offset~-1?
>>>
>>> Have tried searching using the following parameters?
>>> min_objectid = max_objectid = BTRFS_EXTENT_CSUM_OBJECTID
>>> min_type = max_type = BTRFS_CSUM_ITEM_KEY;
>>> min_offset = last_found_csum_offset
>>> max_offset = -1
>> Sorry for my late response.
>>
>> If I set
>>
>> min_objectid = max_objectid = BTRFS_EXTENT_CSUM_OBJECTID
>>
>> I don't get anything. I have to set it to max=-1 (min doesn't matter).
>>
>> And in that I case, min_offset and max_offset doesn't matter - I always
>> get the same result. I can even use "wrong" filters like min=1000 max=500.
> First, it's important to understand how all these min/max values play
> together:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/btrfs.h#n441
>
> So, you define a single start key, and a single end key, and then you
> get everything that's in between (including the end value).
>
> So, this...
>
> sv2_args.key.min_objectid = 0;
> sv2_args.key.max_objectid = -1;
> sv2_args.key.min_offset = 0;
> sv2_args.key.max_offset = -1;
> sv2_args.key.min_transid = 0;
> sv2_args.key.max_transid = -1;
> sv2_args.key.min_type = BTRFS_CSUM_ITEM_KEY;
> sv2_args.key.max_type = BTRFS_CSUM_ITEM_KEY;
>
> ...translates to:
>
> min key: (0, CSUM_ITEM_KEY, 0)
> max key: (18446744073709551615, CSUM_ITEM_KEY, 18446744073709551615)
>
> Since the keys end up being just a single 136 bit number, it makes no
> sense to do anything with the middle field, if the first field, objectid
> is not the same in both start and end key. The search space is linear,
> not 3 dimensional. The invidual min/max values for objectid, type and
> offset cannot be used to filter the result, they only define the
> endpoints of an interval.
>
> Since all csum items have the same objectid number anyway, the second
> suggestion is fine, and gives you this start and end:
>
> min key: (EXTENT_CSUM_OBJECTID, CSUM_ITEM_KEY, 0)
> max key: (EXTENT_CSUM_OBJECTID, CSUM_ITEM_KEY, 18446744073709551615)
>
> Works for me (here in python, but using same ioctl):
>
> -$ cat show_csum_keys.py
> #!/usr/bin/python3
>
> import btrfs
> from btrfs.ctree import Key, CSUM_TREE_OBJECTID, \
>          EXTENT_CSUM_OBJECTID, EXTENT_CSUM_KEY
>
> with btrfs.FileSystem('/mnt/tutorial') as fs:
>      min_key = Key(EXTENT_CSUM_OBJECTID, EXTENT_CSUM_KEY, 0)
>      max_key = Key(EXTENT_CSUM_OBJECTID, EXTENT_CSUM_KEY + 1, 0) - 1
>      print("Searching from {} to {}".format(min_key, max_key))
>      for header, data in btrfs.ioctl.search_v2(fs.fd, CSUM_TREE_OBJECTID,
>                                                min_key, max_key):
>          print(Key(header.objectid, header.type, header.offset))
>
> -# ./show_csum_keys.py
> Searching from (EXTENT_CSUM EXTENT_CSUM 0) to (EXTENT_CSUM EXTENT_CSUM -1)
> (EXTENT_CSUM EXTENT_CSUM 5700059136)
> (EXTENT_CSUM EXTENT_CSUM 5700321280)
> (EXTENT_CSUM EXTENT_CSUM 5700583424)
> (EXTENT_CSUM EXTENT_CSUM 5700845568)
> (EXTENT_CSUM EXTENT_CSUM 5701107712)
> (EXTENT_CSUM EXTENT_CSUM 5704646656)
> (EXTENT_CSUM EXTENT_CSUM 5705039872)
> (EXTENT_CSUM EXTENT_CSUM 5706350592)
> [...]
>
Reading your example, I noticed my mistake.

I took  BTRFS_CSUM_ITEM_KEY  instead of BTRFS_EXTENT_CSUM_KEY for the 
type, doh.

Now, it seems to works.

Thanks!

Tobias

