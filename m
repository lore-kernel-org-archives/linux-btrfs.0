Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68230C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04B8920832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04B8920832
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=swiftspirit.co.za
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbeK2AmJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:42:09 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:15311
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbeK2AmJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 19:42:09 -0500
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2018 19:42:08 EST
X-Sender-Id: webafrica|x-authuser|brendan@swiftspirit.co.za
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 9C07112419C;
        Wed, 28 Nov 2018 13:24:39 +0000 (UTC)
Received: from lnxwebr13.cpt.wa.co.za (unknown [100.96.11.179])
        (Authenticated sender: webafrica)
        by relay.mailchannels.net (Postfix) with ESMTPA id 19197124214;
        Wed, 28 Nov 2018 13:24:37 +0000 (UTC)
X-Sender-Id: webafrica|x-authuser|brendan@swiftspirit.co.za
Received: from lnxwebr13.cpt.wa.co.za (lnxwebr13.cpt.wa.co.za [41.185.8.63])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Wed, 28 Nov 2018 13:24:39 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: webafrica|x-authuser|brendan@swiftspirit.co.za
X-MailChannels-Auth-Id: webafrica
X-Cold-Belong: 1a1324ce5152fbe6_1543411479373_2011245290
X-MC-Loop-Signature: 1543411479373:3274501175
X-MC-Ingress-Time: 1543411479372
Received: from [41.79.193.87] (port=33116 helo=dogmarch.sienna.invalid.co.za)
        by lnxwebr13.cpt.wa.co.za with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <brendan@swiftspirit.co.za>)
        id 1gRzpS-004iyi-SC; Wed, 28 Nov 2018 15:24:34 +0200
Subject: Re: [PATCH] Fix typos
To:     Nikolay Borisov <nborisov@suse.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
 <54384bb2-e602-a1d5-ea6f-96513d7e1f3a@suse.com>
From:   Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <6fce869c-79fe-465e-2bda-84222e5e09a3@swiftspirit.co.za>
Date:   Wed, 28 Nov 2018 15:24:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <54384bb2-e602-a1d5-ea6f-96513d7e1f3a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AuthUser: brendan@swiftspirit.co.za
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/28/18 1:23 PM, Nikolay Borisov wrote:
> 
> 
> On 28.11.18 г. 13:05 ч., Andrea Gelmini wrote:
>> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
>> ---

<snip>

>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index bab2f1983c07..babbd75d91d2 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -104,7 +104,7 @@ static void __endio_write_update_ordered(struct inode *inode,
>>   
>>   /*
>>    * Cleanup all submitted ordered extents in specified range to handle errors
>> - * from the fill_dellaloc() callback.
>> + * from the fill_delalloc() callback.
> 
> This is a pure whitespace fix which is generally frowned upon. What you
> can do though, is replace 'fill_delalloc callback' with
> 'btrfs_run_delalloc_range' since the callback is gone already.
> 
>>    *
>>    * NOTE: caller must ensure that when an error happens, it can not call
>>    * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
>> @@ -1831,7 +1831,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
> 
> <snip>
> 
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 410c7e007ba8..d7b6c2b09a0c 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -892,7 +892,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>    *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
>>    *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
>>    *  9. We can't remove a root or mountpoint.
>> - * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
>> + * 10. We don't allow removal of NFS silly renamed files; it's handled by
>>    *     nfs_async_unlink().
>>    */
>>   
>> @@ -3522,7 +3522,7 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
>>   					       false);
>>   	/*
>>   	 * If one of the inodes has dirty pages in the respective range or
>> -	 * ordered extents, we need to flush dellaloc and wait for all ordered
>> +	 * ordered extents, we need to flush delalloc and wait for all ordered
> 
> Just whitespace fix, drop it.
> 
> <snip>
> 

If the spelling is changed, surely that is not a whitespace fix?
