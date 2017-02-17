Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37321 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755550AbdBQNFD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 08:05:03 -0500
Received: by mail-it0-f51.google.com with SMTP id x75so13861437itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 05:05:02 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id p82sm519112itg.15.2017.02.17.05.05.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Feb 2017 05:05:00 -0800 (PST)
Subject: Re: Opps.. Should be 4.9/4.10 Experiences
To: linux-btrfs@vger.kernel.org
References: <CAK5rZE7mDy+8hkm74UVS81Xht=QxvNOmW=ZfYqpHmnqGZHbMbA@mail.gmail.com>
 <pan$1fe63$b02c9dfa$efbc9dc2$1ccd0342@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ec42604a-7d25-4fa9-3966-e87004f74df9@gmail.com>
Date: Fri, 17 Feb 2017 08:04:55 -0500
MIME-Version: 1.0
In-Reply-To: <pan$1fe63$b02c9dfa$efbc9dc2$1ccd0342@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-17 03:26, Duncan wrote:
> Imran Geriskovan posted on Thu, 16 Feb 2017 13:42:09 +0200 as excerpted:
>
>> Opps.. I mean 4.9/4.10 Experiences
>>
>> On 2/16/17, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:
>>> What are your experiences for btrfs regarding 4.10 and 4.11 kernels?
>>> I'm still on 4.8.x. I'd be happy to hear from anyone using 4.1x for a
>>> very typical single disk setup. Are they reasonably stable/good enough
>>> for this case?
>
> I ran 4.9 and have been on 4.10 since before rc1.  Btrfs has been fine
> here, tho there have been some late rc7/8 fixes.  I've had and still have
> some 4.10 issues, but they're amdgpu, not btrfs related.  (Unfortunately,
> between working long hours and being sick partly as a result, I've had
> little time to report them, but booting with amdgpu.dpm=0 has let me
> continue running 4.10-git, tho I don't know exactly why if I'm not going
> to have time to report problems anyway.)
>
FWIW, I've had largely similar experiences since about 4.0.  I'm also 
not using anything more complicated than raid1/raid0, and I stay on top 
of monitoring for all my systems, but even accounting for that, I've had 
no BTRFS issues that caused anything beyond minor inconvenience (that 
is, no data loss, nothing that would have required taking the system 
completely off-line to fix if it was the root filesystem, and no crashes 
arising from BTRFS itself).

 From what I've seen though, as long as you stay up to date and don't do 
much more complicated than a raid1 or raid0 setup, don't use qgroups 
(they're technically working, but they still have a significant 
performance impact) and don't use lots of snapshots, you should be 
relatively fine.
