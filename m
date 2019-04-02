Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC1BC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 21:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A1D32075E
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 21:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="hTuuYJ4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfDBVW7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 17:22:59 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:42526 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfDBVW7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 17:22:59 -0400
Received: from [192.168.29.36] (avgustinov.eu [87.140.63.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 7A4F747D71E9;
        Wed,  3 Apr 2019 00:22:55 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554240175;
        bh=eA1YLzOwtiVXd9zFwpqPHmYU47wpv3ZkQLXJIlnGHzQ=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=hTuuYJ4HUlCbmsm4+i6i1wP8Lsh3wcC0+oES8odfcMnnCibD6L5PH2mdO5uo2DgJ9
         WDDfkwUs3m+CkUK9xN0jILwRi60vRGykrgzf1+ac0kMbKUxyp5xelORMlqtr+dSh9P
         c2uhMIOqNKasogtx9gbZWj0tzvLirpGYZiw3muDN06Xf42TKnjS3qaBrOMFvO+4qTy
         sJefCptkBIrefLtlWqaVLxkj5O9+FDFHVqtdzc8DSkqztgxRON7F1ArDeiQA3U6/fZ
         UEjNMTTLsuVwYxDlLv9LUUJ/KH2FZQu0R2XC3bPEQWDToBHtEuXGffjRqtENZFAcXe
         Y4qJJFBD+mg/g==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
Date:   Tue, 2 Apr 2019 23:22:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


2019-04-02 16:12, Qu Wenruo:
> 
> 
> On 2019/4/2 下午9:59, Nik. wrote:
>>
>>
>> 2019-04-02 15:24, Qu Wenruo:
>>>
>>>
>>> On 2019/4/2 下午9:06, Nik. wrote:
>>>>
>>>> 2019-04-02 02:24, Qu Wenruo:
>>>>>
>>>>> On 2019/4/1 上午2:44, btrfs@avgustinov.eu wrote:
>>>>>> Dear all,
>>>>>>
>>>>>>
>>>>>> I am a big fan of btrfs, and I am using it since 2013 - in the
>>>>>> meantime
>>>>>> on at least four different computers. During this time, I suffered at
>>>>>> least four bad btrfs-failures leading to unmountable, unreadable and
>>>>>> unrecoverable file system. Since in three of the cases I did not
>>>>>> manage
>>>>>> to recover even a single file, I am beginning to lose my confidence in
>>>>>> btrfs: for 35-years working with different computers no other file
>>>>>> system was so bad at recovering files!
>>>>>>
>>>>>> Considering the importance of btrfs and keeping in mind the number of
>>>>>> similar failures, described in countless forums on the net, I have got
>>>>>> an idea: to donate my last two damaged filesystems for investigation
>>>>>> purposes and thus hopefully contribute to the improvement of btrfs.
>>>>>> One
>>>>>> condition: any recovered personal data (mostly pictures and audio
>>>>>> files)
>>>>>> should remain undisclosed and be deleted.
>>>>>>
>>>>>> Should anybody be interested in this - feel free to contact me
>>>>>> personally (I am not reading the list regularly!), otherwise I am
>>>>>> going
>>>>>> to reformat and reuse both systems in two weeks from today.
>>>>>>
>>>>>> Some more info:
>>>>>>
>>>>>>      - The smaller system is 83.6GB, I could either send you an
>>>>>> image of
>>>>>> this system on an unneeded hard drive or put it into a dedicated
>>>>>> computer and give you root rights and ssh-access to it (the network
>>>>>> link
>>>>>> is 100Mb down, 50Mb up, so it should be acceptable).
>>>>>
>>>>> I'm a little more interested in this case, as it's easier to debug.
>>>>>
>>>>> However there is one requirement before debugging.
>>>>>
>>>>> *NO* btrfs check --repair/--init-* run at all.
>>>>> btrfs check --repair is known to cause transid error.
>>>>
>>>> unfortunately, this file system was used as testbed and even
>>>> "btrfs check --repair --check-data-csum --init-csum-tree --init-extent
>>>> tree ..." was attempted on it.
>>>> So I assume you are not interested.
>>>
>>> Then the fs can be further corrupted, so I'm not interested.
>>>
>>>>
>>>> On the larger file system only "btrfs check --repair --readonly ..." was
>>>> attempted (without success; most command executions were documented, so
>>>> the results can be made available), no writing commands were issued.
>>>
>>> --repair will cause write, unless it even failed to open the filesystem.
>>>
>>> If that's the case, it would be pretty interesting for me to poking
>>> around the fs, and obviously, all read-only.
>>>
>>>>
>>>>> And, I'm afraid even with some debugging, the result would be pretty
>>>>> predictable.
>>>>
>>>> I do not need anything from the smaller file system and have (hopefully
>>>> fresh enough) backups from the bigger one.
>>>> I would be good enough if it helps to find any bugs, which are still in
>>>> the code.
>>>>
>>>>> It will be 90% transid error.
>>>>> And if it's tree block from future, then it's something barrier
>>>>> related.
>>>>> If it's tree block from the past, then it's some tree block doesn't
>>>>> reach disk.
>>>>>
>>>>> We have being chasing the spectre for a long time, had several
>>>>> assumption but never pinned it down.
>>>>
>>>> IMHO spectre would lead to much bigger loses - at least in my case it
>>>> could have happened all four times, but it did not.
>>>>
>>>>> But anyway, more info is always better.
>>>>>
>>>>> I'd like to get the ssh access for this smaller image.
>>>>
>>>> If you are still interested, please advise how to create the image of
>>>> the file system.
>>>
>>> If the larger fs really doesn't get any write (btrfs check --repair
>>> failed to open the fs, thus have the output "cannot open file system"),
>>> I'm interesting in that one.
>>
>> This is excerpt from the terminal log:
>> "# btrfs check --readonly /dev/md0
>> incorrect offsets 15003 146075
>> ERROR: cannot open file system
>> #"
> 
> That's great.
> 
> And to my surprise, this is completely different problem.
> 
> And I believe, it will be detected by latest write time tree checker
> patches in next kernel release.

Is the next release going to come out in April?

> This problem is normally caused by memory bit flip.

Well, this system has suffered many power outages (at least 6 since 
2013), and after each outage I had to run scrub AND nevertheless 
discovered the loss of a couple of files. I can imagine, that the power 
supply or the mother board of this machine is not (well) designed for 
reliability, but:
   1) shouldn't the file system be immune to this?
   2) Isn't is too stupid to lose terabytes of information due to a 
flipped bit?
The same machine has ext4 and FAT file systems, and they never have had 
a problem or recovered automatically by means of fsck during the next 
reboot!

> This should ring a little alert about the problem.
> 
> Anyway, v5.2 or v5.3 kernel would be much better to catch such problems.

This kernel isn't even scheduled, is it? Well, I am not really in a 
hurry...

>>
>> Btw., since the list does allow _plain_text_only, I wonder how do you
>> quote?
>>
>>> If not, then no.
>>>
>>>> I can imagine that it is preferable to use the
>>>> original, but in my case it is a (not mounted) partition of a bigger
>>>> hard drive, and the other partitions are in use. The "btrfs-image" seems
>>>> inappropriate to me, "dd" will probably screw things up?
>>>
>>> Since the fs is too large, I don't think either way is good enough.
>>>
>>> So in this case, the best way for me to poke around is to give me a
>>> caged container with only read access to the larger fs.
>>
>> I am afraid that this machine is too weak for using containers on it
>> (QNAP SS839Pro NAS, Intel Atom, 2GB RAM), and right now I do not have
>> other machine, which could accommodate five hard drives. Let me consider
>> how to organize this or give another idea. One way could be "async ssh"
>> -  a private ssl-chat on one of my servers, so that you can write your
>> commands there, I execute them on the machine as soon as I can and put
>> the output back into the chat-window? Sounds silly, but could start
>> immediately, and I have no better idea right now, sorry!
> 
> Your btrfs check output is already good enough to locate the problem.
> 
> The next thing would be just to help you recovery that image if that's
> what you need.

Well, let me say it again: 1) I have a backup, but one is never sure 
which newest files are not in it. 2) It is much more important to be 
sure that the btrfs code is flawless and no other btrfs file system is 
in danger! I can live with some loses, but inability to recover even 
single file is not acceptable!

> The purposed idea is not that uncommon. In fact it's just another way of
> "show commands, user execute and report, developer check the output" loop.
> 
> In your case, you just need latest btrfs-progs and re-run "btrfs check
> --readonly" on it.

Will try this, but have no time before tomorrow evening.


> If it just shows the same result, meaning I can't get the info about
> which tree block is corrupted, then you could try to mount it with -o ro
> using *LATEST* kernel.

I tried this before with the 4.15.0-46 kernel, it was impossible. Will 
try again with newer ona as soon as possible (in best case tomorrow 
evening); I will post the results.

> Latest kernel will report anything wrong pretty vocally, in that case,
> dmesg would include the bytenr of corrupted tree block.
> 
> Then I could craft needed commands to further debug the fs.

Ok, I will try to post more info tomorrow about this time.

Nik.
--

> Thanks,
> Qu
> 
>>
>> Thank you for trying to improve btrfs!
>>
>> Nik.
>>>
>>> Thanks,
>>> Qu
>>
>> You are not from the 007 - lab, are you? ;-)
>>
>>>>
>>>> Kind regards,
>>>>
>>>> Nik.
>>>
> 
