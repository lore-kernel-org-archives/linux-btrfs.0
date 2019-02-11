Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E4AC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 12:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA48F218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 12:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yb61Ql8b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfBKMRr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 07:17:47 -0500
Received: from mail-it1-f171.google.com ([209.85.166.171]:38248 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfBKMRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 07:17:47 -0500
Received: by mail-it1-f171.google.com with SMTP id z20so25607845itc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 04:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I9S3rZ3Y4j7LsqP+iUF/wLJ7RTtX5Y0f2mH/Kj4YGyA=;
        b=Yb61Ql8b3gxQ9ljFUnBvuaDaJZcCDsTqg5yibw+GK5AUVRUI9cYURPwfJiS0dUVOOW
         CKLFzYLp68FtW7U0zSypk/kB/LRiS/T0yCgQ824PnFd7gRUTJ4XCpmUwFB8chp6yO+VQ
         JGhJMo/ubkDWixMpAQiHpCzEHtDlGJ07DDo1aZU4+bJiwcl3v2h1HnI3nt61QflscAuC
         m1GGwCDn98w/15xfqfeS2U+pBpbykgHBL2ZHn8u0TWXHR1o8k3ImX4acPZWQyZEKfyiQ
         +6By24tlGxk2A1VSi52Msk6AwGl57iUZGA+eDtJVI7oj/1TJP1nUYptN6JbyAgp4qFUU
         fcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9S3rZ3Y4j7LsqP+iUF/wLJ7RTtX5Y0f2mH/Kj4YGyA=;
        b=DNRPRMU7nbegghO4rVTtKjsxtUbSH2Dr7coc+71IUKlCx6Bn6dsHMiux+M/C+iBL6g
         MR/qDUXDfuQ8A82nMDI+y3TKcgRI2a/CLeNcgZICej4wsEGfYydptstZ2NHghJT+M+8K
         m4nAnsCUXZEFJmAW+VHUy5OirBXbgcmBLdtyZEMz2NBmtki0RtN3T1FKIOmrMhJwRzPD
         BeCJPijKEKnrFEHdn+ViJ2CpNRNWMJeeyu/Hfhl8e8SeIXbxPtOeRvA/LZ+uG7gZVvAO
         Y4mduDCbaDumkNs6iqNjHwxOeDSAOYZX43yrx9/KxzXCg1Np97Z9t6aye8Uxy8PUa74r
         cWZw==
X-Gm-Message-State: AHQUAuZeNY5QfKDeTzGUihUNyZ05Ae8Ehyb39CQJmN+0gFWqbsEY6Mu+
        16Lp49+sGf3sWLgW4fnOnS4lEYxGgQ4=
X-Google-Smtp-Source: AHgI3IYjIsJqEbs8b6Ts9pmxVz0YZ6og6K3nL1JIkx/Im7lM2AEdAf/Vy9Z7nFlnybKoKSFGEjh8UQ==
X-Received: by 2002:a24:ac02:: with SMTP id s2mr5469933ite.94.1549887465334;
        Mon, 11 Feb 2019 04:17:45 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i135sm5064232iti.34.2019.02.11.04.17.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 04:17:44 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     Chris Murphy <lists@colorremedies.com>,
        waxhead <waxhead@dirtcellar.net>
Cc:     Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
 <f41063e8-b9b1-f929-7954-8a96e673bd2e@gmail.com>
 <f67c6a69-4fc8-e33a-543e-9b97adf54438@dirtcellar.net>
 <CAJCQCtQ-nLkOYE5ARk+rjT4JBxR6Atn1gU-+U8gAT0sb7Mduow@mail.gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a8e00ae7-9e18-ba74-5521-a2db7b525e51@gmail.com>
Date:   Mon, 11 Feb 2019 07:17:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ-nLkOYE5ARk+rjT4JBxR6Atn1gU-+U8gAT0sb7Mduow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-10 13:34, Chris Murphy wrote:
> On Sat, Feb 9, 2019 at 5:13 AM waxhead <waxhead@dirtcellar.net> wrote:
> 
>> Understood, but that is not quite what I meant - let me rephrase...
>> If BTRFS still can't mount, why would it blindly accept a previously
>> non-existing disk to take part of the pool?!
> 
> It doesn't do it blindly. It only ever mounts when the user specifies
> the degraded mount option, which is not a default mount option.
> 
>> E.g. if you have "disk" A+B
>> and suddenly at one boot B is not there. Now you have only A and one
>> would think that A should register that B has been missing. Now on the
>> next boot you have AB , in which case B is likely to have diverged from
>> A since A has been mounted without B present - so even if both devices
>> are present why would btrfs blindly accept that both A+B are good to go
>> even if it should be perfectly possible to register in A that B was
>> gone. And if you have B without A it should be the same story right?
> 
> OK no, you haven't gone far enough to setup the split brain scenario
> where there is a partially legitimate complaint. Prior to split brain,
> it's entirely reasonable for Btrfs to mount *when you use the degraded
> mount option* - it does not blindly mount. And if you've ever done
> exactly what you wrote in the above paragraph, you'd see Btrfs
> *complains vociferously* about all the errors it's passively finding
> and fixing. If you want a more active method of getting device B
> caught up with A automatically - that's completely reasonable, and
> something people have been saying for some time, but it takes a design
> proposal, and code.
> 
> As for split brain scenario, it is only the user's manual intervention
> with multiple 'degraded' mount options (which again, is not the
> default) that caused the volume to arrive in such a state. Would it be
> wise to have some additional error checking? Sure. Someone would need
> to step up with a design and to do code work, same as any other
> feature. Maybe a rudimentary check would be comparing the timestamps
> for leaves or nodes ostensibly with the same transid, but in any case
> that doesn't just happen for free.
And even then it couldn't be made truly reliable, because data from old 
transactions may be arbitrarily overwritten at any point after the next 
transaction (and is just plain gone if you're using the `discard` mount 
option).
> 
> 
>>>> So what you are saying is that the generation number does not
>>>> represent a true frozen state of the filesystem at that point?
>>> It does _only_ for those devices which were present at the time of the
>>> commit that incremented it.
>>>
>> So in other words devices that are not present can easily be marked /
>> defined as such at a later time?
> 
> That isn't how it currently works. When stale device B is subsequently
> mounted (normally) along with device A, it's only passively fixed up.
> Part of the point of non-automatic degraded mounts that require user
> intervention is the lack of anything beyond simple error handling and
> fixups.
> 
>> Ok, not sure I still understand how/why systemd knows what devices are
>> part of btrfs (or md or lvm for that matter). I'll try to research this
>> a bit - thanks for the info!
> 
> It doesn't, not directly. It's from the previously mentioned udev
> rule. For md, the assembly, delays, and fall back to running degraded,
> are handled in dracut. But the reason why this is in udev is to
> prevent a mount failure just because one or more devices are delayed;
> basically it inserts a pause until the devices appear, and then
> systemd issues the mount command.
Last I knew, it was systemd itself doing the pause, because we provide 
no real device for udev to wait on appearing.

