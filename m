Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E41BC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E29420666
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4HZUVfc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E29420666
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbeLDNz3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 08:55:29 -0500
Received: from mail-it1-f179.google.com ([209.85.166.179]:51534 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbeLDNz3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 08:55:29 -0500
Received: by mail-it1-f179.google.com with SMTP id x19so15445854itl.1
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 05:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HM3hiN0Ctg1ybsolPQ1akmF5T5jSI5hmnp5QUNfA9fc=;
        b=o4HZUVfceVoYWhI1GcA7F8DWOxmgfzN90PN4Dt44QCKsA4GgQ18dZ8mdXU4APhhJOz
         bgNmy4OqzWtVUDXBUsj+Dch09jS5RCsttTCMQgIMb5y8PfwEhvRbsPsz2OIp6vWGI8A2
         cOZRLckTXURH7o1LUGbOgYo6IuK8bHngZprLKM1xhu7FUVP3u0AUOUPAlv3r+E81SEAw
         iLZRQCwttgiG75xwxe4wJObzwhqiwZKvko4Mxc3ZY4uYrRG0xemvO1YYKHsAc1/pv/ty
         uBUNY7X9WxpfHYwmCNj7tiUcuukCHT3zGT7Ub8TcFZAjPKq7R0w81mm/6johH1hK9h0T
         /t5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HM3hiN0Ctg1ybsolPQ1akmF5T5jSI5hmnp5QUNfA9fc=;
        b=VdqvR/JQssXVbBNf/i+lNpUui78LBy6eOm+z76GJRCS3WqsUg9kdwYuSuIWb85SK3k
         E1VK7ohyN95Yt9ErXm+IWw760x+ASmhaJ7KefIGZHBNCnNU4qT+ugyZlMZ7vRcQBQNGC
         wrzfiIqmc7ZTi184eBogMjI7jmHtnU3UnVKiYui2/qIAQAzJgEV6VYxSedX//Kqa7cW5
         Zruw/TpcMa2B5V3bxfa5LqqsKx096pIMAkYCE/uTvAR7BbpEOqgdQS/gN+iGy3rkXffI
         cI1UX6PyXdBWysDbOixEacAL0hFrF8ebyLqp3zlPCUpei5RZIj6wuVxQAb3u24q6/b4S
         IukA==
X-Gm-Message-State: AA+aEWae6l2mUqN7MG2gJIpFoJwjKheLRKvEdmbSrhA7CyZVSKaj2qaB
        l+K9T253gvg82YqQsiVz1jX+eXJAH3Y=
X-Google-Smtp-Source: AFSGD/VK5sboZBtXdXv26co887E1scUKxX0dxTCYUi/QhnScvUBPkF1oHxot7VKlTd2c6KsCucuS/g==
X-Received: by 2002:a24:1152:: with SMTP id 79mr12174572itf.167.1543931727960;
        Tue, 04 Dec 2018 05:55:27 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id s13sm2980880iop.36.2018.12.04.05.55.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 05:55:27 -0800 (PST)
Subject: Re: experiences running btrfs on external USB disks?
To:     Graham Cobb <g.btrfs@cobb.uk.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
 <7c8a85c7-52d8-202b-5bc7-0fa0c5c6e502@gmail.com>
 <d891096f-04c5-cf4b-cfb6-ba873b1ff72f@cobb.uk.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bf90f799-2202-f266-c829-801c22b81ac6@gmail.com>
Date:   Tue, 4 Dec 2018 08:55:24 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <d891096f-04c5-cf4b-cfb6-ba873b1ff72f@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-04 08:37, Graham Cobb wrote:
> On 04/12/2018 12:38, Austin S. Hemmelgarn wrote:
>> In short, USB is _crap_ for fixed storage, don't use it like that, even
>> if you are using filesystems which don't appear to complain.
> 
> That's useful advice, thanks.
> 
> Do you (or anyone else) have any experience of using btrfs over iSCSI? I
> was thinking about this for three different use cases:
> 
> 1) Giving my workstation a data disk that is actually a partition on a
> server -- keeping all the data on the big disks on the server and
> reducing power consumption (just a small boot SSD in the workstation).
> 
> 2) Splitting a btrfs RAID1 between a local disk and a remote iSCSI
> mirror to provide  redundancy without putting more disks in the local
> system. Of course, this would mean that one of the RAID1 copies would
> have higher latency than the other.
> 
> 3) Like case 1 but actually exposing an LVM logical volume from the
> server using iSCSI, rather than a simple disk partition. I would then
> put both encryption and RAID running on the server below that logical
> volume.
> 
> NBD could also be an alternative to iSCSI in these cases as well.
> 
> Any thoughts?
I've not run it over iSCSI (I tend to avoid that overly-complicated 
mess), but I have done it over NBD and ATAoE, as well as some more 
exotic arrangements, and it's really not too bad.  The important part is 
making sure your block layer and all the stuff under it are reliable, 
and USB is not.
