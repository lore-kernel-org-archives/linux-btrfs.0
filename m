Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4C4C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 15:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D1A02082E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 15:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="MJeYVnDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfDDP6p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 11:58:45 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:46820 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfDDP6o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2019 11:58:44 -0400
Received: from [172.18.148.109] (unknown [46.183.103.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 4DAB2484CE8A;
        Thu,  4 Apr 2019 18:58:41 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554393522;
        bh=yKAw+VssIiOcr1MykS8yESueI4sKqQgFN1SFjed24vw=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=MJeYVnDcQ1+/VjchhF83IqZTq1YzR9+xePNFtNwtSS3lUNsI4+uIyImgjI3xy3cvZ
         X2YT0+BVG76RSdrh3O0y4GyN5rb6gGGbcGCZtGTFhgi+iQMcHqd3hJJ6mDGyzWIoko
         ALZI/V68HvNnSK0EAlXePW3zg/0CormIAsClFmrrhLo5peZRL/fcPrg9s5+loeapSb
         KW7K2Ayrl72Ihba4WTXlCLmmPVTL8Vlp/L63DBLWa9lnjOkwLcxLE2OEIDeS1zn7Hx
         m5E8ipbl7WYDyNGXe5c0UXw7sowj9TPYzTwSRsuTnLtS+YyJJcew4MJ7bVn7iVPCP2
         NhqLRB63gN7/g==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <3a3537f5-b84c-ee01-b5da-d6bab5bdf221@avgustinov.eu>
Date:   Thu, 4 Apr 2019 17:58:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


2019-04-04 04:48, Jeff Mahoney:
> On 3/31/19 2:44 PM, btrfs@avgustinov.eu wrote:
>> Dear all,
>>
>>
>> I am a big fan of btrfs, and I am using it since 2013 - in the meantime
>> on at least four different computers. During this time, I suffered at
>> least four bad btrfs-failures leading to unmountable, unreadable and
>> unrecoverable file system. Since in three of the cases I did not manage
>> to recover even a single file, I am beginning to lose my confidence in
>> btrfs: for 35-years working with different computers no other file
>> system was so bad at recovering files!
>>
>> Considering the importance of btrfs and keeping in mind the number of
>> similar failures, described in countless forums on the net, I have got
>> an idea: to donate my last two damaged filesystems for investigation
>> purposes and thus hopefully contribute to the improvement of btrfs. One
>> condition: any recovered personal data (mostly pictures and audio files)
>> should remain undisclosed and be deleted.
>>
>> Should anybody be interested in this - feel free to contact me
>> personally (I am not reading the list regularly!), otherwise I am going
>> to reformat and reuse both systems in two weeks from today.
>>
>> Some more info:
>>
>>    - The smaller system is 83.6GB, I could either send you an image of
>> this system on an unneeded hard drive or put it into a dedicated
>> computer and give you root rights and ssh-access to it (the network lin
>> is 100Mb down, 50Mb up, so it should be acceptable).
>>
>>    - The used space on the other file system is about 3 TB (4 TB
>> capacity) and it is distributed among 5 drives, so I can only offer
>> remote access to this, but I will need time to organize it.
>>
>> If you need additional information - please ask, but keep in mind that I
>> have almost no "free time" and the answer could need a day or two.
> 
> My team is always interested in images of broken file systems.  This is
> how --repair evolves.  Images with failed --repair operations are still
> valuable.  That's the first step most users take and why wouldn't they?
>   If --repair is misbehaving, the end result shouldn't be "I hope you
> have backups."

I absolutely agree!

> It's not the size of the file system that matters so much.  The data on
> it doesn't matter from a debugging perspective and, in any event, it's
> not written to the image file anyway.  I do want a btrfs-image file from
> the file system, and if btrfs-image fails to create a usable image,
> that's also valuable to know and fix.

The larger filesystem gives me the following output (kernel 
5.0.6-050006-generic, btrfs-progs v4.20.2):

# btrfs-image -c 9 /dev/md0 /mnt/b/md.img
incorrect offsets 15003 146075
ERROR: open ctree failed
ERROR: create failed: Success

Last line is funny.
The smaller system let me create an image, but the size of the file, 
resulting from "btrfs-image -c 9 /dev/sdXY ...", is surprisingly small - 
only 536576B. I guess this is conform with the man-page: "All data will 
be zeroed, but metadata and the like is preserved. Mainly used for 
debugging purposes."

I shall send you a link to the image (in a private mail) as soon as 
possible. Please, respect any private data in case you manage to recover 
something.

Kind regards,
Nik.
--

> Thanks,
> 
> -Jeff
> 
