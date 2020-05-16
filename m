Return-Path: <SRS0=XWf5=66=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9C8C433E0
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 May 2020 20:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E975C20709
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 May 2020 20:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lechevalier.se header.i=@lechevalier.se header.b="dWFL1HrO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgEPUCA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 May 2020 16:02:00 -0400
Received: from mailrelay4-3.pub.mailoutpod1-cph3.one.com ([46.30.212.13]:47940
        "EHLO mailrelay4-3.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgEPUB7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 May 2020 16:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lechevalier.se; s=20191106;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version:date:
         message-id:from:references:cc:to:subject:from;
        bh=sHVqFasshW4u0j95CpEBKjZD4Jc7JL+N5hz55dWrSCo=;
        b=dWFL1HrOZZCmwlnWPIVAxikr5W4PL95Q0Mi2hVTsXeRxG8jAYV1RRbOaYmC6nE03hU9busIW2ZD8m
         CkN6bAkBejF9hUJTma44a1oOY3Xkgj4hWD4etrDSi+c8sdzIQ6lqojPQd6QqYJt59cf/ozIV5qmkdZ
         C9Hsfro8SJFAwJyHV0QnSRrW0s5FiPzFHSl3XYx5jDWMPXfrws80xvbQ+7WUmVP0B2GYFmgdIKmnYg
         RFJBBOjiAjehNmjFNE6X0dnpLJM8Zl1GahAw2ReZ5fXIcZ0IWX+1eSrK39viHCbJWkyAIg9GNVExYc
         +4NPS/InsFMFt48r2SMmwhs8ostdRYQ==
X-HalOne-Cookie: 6095bbeeaf78d14d21daf5b220c0bd515379eb8b
X-HalOne-ID: 18253b7a-97b0-11ea-b305-d0431ea8bb10
Received: from [10.0.88.22] (unknown [98.128.186.112])
        by mailrelay4.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 18253b7a-97b0-11ea-b305-d0431ea8bb10;
        Sat, 16 May 2020 20:01:56 +0000 (UTC)
Subject: Re: cp -a leaves some compressed data.
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     fdmanana@gmail.com
References: <b3f880.1227fea8.1721e54aeeb@lechevalier.se>
 <CAL3q7H4zkS=9U2+ig=6a3WDF2NXDDZkmnw9havUKi5EbB0t6Og@mail.gmail.com>
From:   A L <mail@lechevalier.se>
Message-ID: <af4712e3-d7eb-6ba7-0ecd-155e5ee17bc3@lechevalier.se>
Date:   Sat, 16 May 2020 22:01:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4zkS=9U2+ig=6a3WDF2NXDDZkmnw9havUKi5EbB0t6Og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On 2020-05-16 19:18, Filipe Manana wrote:
> On Sat, May 16, 2020 at 5:51 PM A L <mail@lechevalier.se> wrote:
>> Dear all,
>>
>> I did some testing on copying files with the +c (compression) xattrs set.
>>
>> As far as I can tell, 'cp - a' only sets any xattrs after copying the data. This means that a compressed file should end up without compression, but still with the +c xattr set. However this is not entirely true. Some small amount of data is still getting compressed.
>>
>> I would like to understand why.
> As discussed on the mailing list:
>
> cp copies the xattr only after copying the file data. Since the data
> is written to the destination using buffered IO, it is possible that
> while copying the data the system flushes dirty pages for whatever
> reason (due to memory pressure, someone called sync(2), etc) - this
> data will not be compressed since the file doesn't have yet the
> compression xattr. If the remaining data is flushed after cp finishes,
> then that data can end up compressed, since the file has the
> compression xattr at that point. Typically for small files, all the
> data ends up getting flushed after cp finishes, so we don't see any
> surprising behaviour.
>
> I'll look into changing 'cp''s behaviour to copy xattrs before file
> data next week, unless you or someone else is interested in doing it.
>
> Thanks.
>
Based on what you say, the file operations are happening asynchronous in 
the background, rather than synchronous. I guess 'cp' and other tools 
like it should issue a 'fsync' call between setting the xattrs and 
writing data? Is this specific to Btrfs, or is it a Linux design choice?

Also, thanks for looking into changing cp to do the xattrs before 
writing data. I had also asked about this on the coreutils mailing list: 
https://lists.gnu.org/archive/html/coreutils/2020-05/msg00011.html

Thanks
