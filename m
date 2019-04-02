Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E98C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 13:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 207582063F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 13:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="V0Sj0liD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfDBN7T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:59:19 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:60406 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731186AbfDBN7T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 09:59:19 -0400
Received: from [192.168.99.127] (unknown [93.241.30.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 7C08947C34D0;
        Tue,  2 Apr 2019 16:59:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554213557;
        bh=rrgidtc4C2LmUwUVrsUYNVbiE7R5GHKQaQyUnH+wYPI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=V0Sj0liDPYGWQP5I1SBxVfgl6stPhVFs8bEPCrF/+bgw+AVwm/WWXXXbF0yuY4lHh
         x66CcVYZ+7JffI9PzFmGAZy6e1uvmFW7KhaCGHOHF1MTrER8MT91wjVqVixth9dsFT
         srvXEjpz0TUJY2KV4ythF3lZWqEH5yqY0l5rRqoMEH0YpJLTFXS9nJRaHtrih90uC2
         aOicm4Ju9A9tmFR5Kl6GLf5biGM4vgHeP6RyMwID2We08HJM9Tt75H++WyCdZTcWEy
         /Y2uNkuHC+XXCiH2YiHZ8yeAFo/d12zBDsSYZ8aR6QOJ3dIRDv23tlvrnqSP07QLGN
         6ZF9911U8J2Dg==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
Date:   Tue, 2 Apr 2019 15:59:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-02 15:24, Qu Wenruo:
> 
> 
> On 2019/4/2 下午9:06, Nik. wrote:
>>
>> 2019-04-02 02:24, Qu Wenruo:
>>>
>>> On 2019/4/1 上午2:44, btrfs@avgustinov.eu wrote:
>>>> Dear all,
>>>>
>>>>
>>>> I am a big fan of btrfs, and I am using it since 2013 - in the meantime
>>>> on at least four different computers. During this time, I suffered at
>>>> least four bad btrfs-failures leading to unmountable, unreadable and
>>>> unrecoverable file system. Since in three of the cases I did not manage
>>>> to recover even a single file, I am beginning to lose my confidence in
>>>> btrfs: for 35-years working with different computers no other file
>>>> system was so bad at recovering files!
>>>>
>>>> Considering the importance of btrfs and keeping in mind the number of
>>>> similar failures, described in countless forums on the net, I have got
>>>> an idea: to donate my last two damaged filesystems for investigation
>>>> purposes and thus hopefully contribute to the improvement of btrfs. One
>>>> condition: any recovered personal data (mostly pictures and audio files)
>>>> should remain undisclosed and be deleted.
>>>>
>>>> Should anybody be interested in this - feel free to contact me
>>>> personally (I am not reading the list regularly!), otherwise I am going
>>>> to reformat and reuse both systems in two weeks from today.
>>>>
>>>> Some more info:
>>>>
>>>>     - The smaller system is 83.6GB, I could either send you an image of
>>>> this system on an unneeded hard drive or put it into a dedicated
>>>> computer and give you root rights and ssh-access to it (the network link
>>>> is 100Mb down, 50Mb up, so it should be acceptable).
>>>
>>> I'm a little more interested in this case, as it's easier to debug.
>>>
>>> However there is one requirement before debugging.
>>>
>>> *NO* btrfs check --repair/--init-* run at all.
>>> btrfs check --repair is known to cause transid error.
>>
>> unfortunately, this file system was used as testbed and even
>> "btrfs check --repair --check-data-csum --init-csum-tree --init-extent
>> tree ..." was attempted on it.
>> So I assume you are not interested.
> 
> Then the fs can be further corrupted, so I'm not interested.
> 
>>
>> On the larger file system only "btrfs check --repair --readonly ..." was
>> attempted (without success; most command executions were documented, so
>> the results can be made available), no writing commands were issued.
> 
> --repair will cause write, unless it even failed to open the filesystem.
> 
> If that's the case, it would be pretty interesting for me to poking
> around the fs, and obviously, all read-only.
> 
>>
>>> And, I'm afraid even with some debugging, the result would be pretty
>>> predictable.
>>
>> I do not need anything from the smaller file system and have (hopefully
>> fresh enough) backups from the bigger one.
>> I would be good enough if it helps to find any bugs, which are still in
>> the code.
>>
>>> It will be 90% transid error.
>>> And if it's tree block from future, then it's something barrier related.
>>> If it's tree block from the past, then it's some tree block doesn't
>>> reach disk.
>>>
>>> We have being chasing the spectre for a long time, had several
>>> assumption but never pinned it down.
>>
>> IMHO spectre would lead to much bigger loses - at least in my case it
>> could have happened all four times, but it did not.
>>
>>> But anyway, more info is always better.
>>>
>>> I'd like to get the ssh access for this smaller image.
>>
>> If you are still interested, please advise how to create the image of
>> the file system.
> 
> If the larger fs really doesn't get any write (btrfs check --repair
> failed to open the fs, thus have the output "cannot open file system"),
> I'm interesting in that one.

This is excerpt from the terminal log:
"# btrfs check --readonly /dev/md0
incorrect offsets 15003 146075
ERROR: cannot open file system
#"

Btw., since the list does allow _plain_text_only, I wonder how do you quote?

> If not, then no.
> 
>> I can imagine that it is preferable to use the
>> original, but in my case it is a (not mounted) partition of a bigger
>> hard drive, and the other partitions are in use. The "btrfs-image" seems
>> inappropriate to me, "dd" will probably screw things up?
> 
> Since the fs is too large, I don't think either way is good enough.
> 
> So in this case, the best way for me to poke around is to give me a
> caged container with only read access to the larger fs.

I am afraid that this machine is too weak for using containers on it 
(QNAP SS839Pro NAS, Intel Atom, 2GB RAM), and right now I do not have 
other machine, which could accommodate five hard drives. Let me consider 
how to organize this or give another idea. One way could be "async ssh" 
-  a private ssl-chat on one of my servers, so that you can write your 
commands there, I execute them on the machine as soon as I can and put 
the output back into the chat-window? Sounds silly, but could start 
immediately, and I have no better idea right now, sorry!

Thank you for trying to improve btrfs!

Nik.
> 
> Thanks,
> Qu

You are not from the 007 - lab, are you? ;-)

>>
>> Kind regards,
>>
>> Nik.
> 
