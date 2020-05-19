Return-Path: <SRS0=EU31=7B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDABC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 May 2020 15:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16FD2075F
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 May 2020 15:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lechevalier.se header.i=@lechevalier.se header.b="DUVRCduU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgESPc2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 May 2020 11:32:28 -0400
Received: from mailrelay2-3.pub.mailoutpod1-cph3.one.com ([46.30.212.11]:31687
        "EHLO mailrelay2-3.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728725AbgESPc2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 May 2020 11:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lechevalier.se; s=20191106;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version:date:
         message-id:from:references:to:subject:from;
        bh=d+gVqSCejrF3Jhnamd6+UIHVzlhzJtA2Fzyrh7hBkjA=;
        b=DUVRCduUpOIdGxMw70ruYhg6q19+ea5KOX35Oyio8CDZUmJAgNUpnUxeI5ybfj2Xo0fF1cofkh/Ke
         DiCG5LLyKdvWX8K+wJtCePqiaeOgNABrwls8x8GUVwULfouLHkaqzAfIPBVupQJyRg0zl5z23sKxn4
         FW45iULuDvvvHvnBbA3K9zPGjzg4CxP2p1CGseWyDLtiihwYb7BmCvEiZqS5yGkpIK+So5Y2VjMNRS
         OdBIDj0D1JVBIRRZNw3JRKxGriWS87Cp0AWMwDpSstLCW+ktPrhtrkI4Vk4jUwvlB17pLcu+6VAL7+
         nMJgEAGYEpo6mLR3bC0U7d7ox96BUKw==
X-HalOne-Cookie: 03a930d4860dab1cbb963af07118b66a1a347403
X-HalOne-ID: f0b10fe2-99e5-11ea-873c-d0431ea8a290
Received: from [10.0.88.22] (unknown [98.128.186.71])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id f0b10fe2-99e5-11ea-873c-d0431ea8a290;
        Tue, 19 May 2020 15:32:25 +0000 (UTC)
Subject: Re: cp -a leaves some compressed data.
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b3f880.1227fea8.1721e54aeeb@lechevalier.se>
 <CAL3q7H4zkS=9U2+ig=6a3WDF2NXDDZkmnw9havUKi5EbB0t6Og@mail.gmail.com>
 <af4712e3-d7eb-6ba7-0ecd-155e5ee17bc3@lechevalier.se>
 <CAL3q7H6F2s0azBbGO6B9FfX7GVUMVyH-xfXzmWFqkUd8uMKG8Q@mail.gmail.com>
From:   A L <mail@lechevalier.se>
Message-ID: <19d4e3ed-c023-4326-b229-17a7d47f3bd5@lechevalier.se>
Date:   Tue, 19 May 2020 17:32:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6F2s0azBbGO6B9FfX7GVUMVyH-xfXzmWFqkUd8uMKG8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> I don't understand what you are trying to say. Are you suggesting the
> fsync would help the issue you described (I don't see how), with the
> file ending up having compressed and uncompressed extents, or is that
> for some other issue you are thinking about?
>
>> Is this specific to Btrfs, or is it a Linux design choice?
> Can't tell since I don't understand what is the problem.
>

As a normal end-user, my expectation is that if I 1) first write to a 
file, then 2) change its attributes (compression), those attributes 
should not affect the data previously written.

But how it is now, depending on how "quick" the system acts in writing 
out the data, some of it might be written after the attributes take 
affect. I found this non-serial way of writing confusing. It is probably 
how it is supposed to be, and my understanding is lacking :)

Thanks again!


