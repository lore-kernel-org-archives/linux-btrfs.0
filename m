Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:39055 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934338AbeB1UPj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 15:15:39 -0500
Received: by mail-io0-f182.google.com with SMTP id b34so4602408ioj.6
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 12:15:38 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id w195sm2109130ita.35.2018.02.28.12.15.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Feb 2018 12:15:37 -0800 (PST)
Subject: Re: btrfs space used issue
To: linux-btrfs@vger.kernel.org
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <pan$e116f$e5aa2400$88c9d453$f5589ed1@cox.net>
 <2892a866-fdc3-b337-4cd4-2cd4a18b9f21@gmail.com>
 <pan$dd7e7$8a56ef21$d7fa0ab5$d833c283@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <11bc6ef9-e818-fda0-8e03-e9beca70fc2e@gmail.com>
Date: Wed, 28 Feb 2018 15:15:35 -0500
MIME-Version: 1.0
In-Reply-To: <pan$dd7e7$8a56ef21$d7fa0ab5$d833c283@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-28 14:54, Duncan wrote:
> Austin S. Hemmelgarn posted on Wed, 28 Feb 2018 14:24:40 -0500 as
> excerpted:
> 
>>> I believe this effect is what Austin was referencing when he suggested
>>> the defrag, tho defrag won't necessarily /entirely/ clear it up.  One
>>> way to be /sure/ it's cleared up would be to rewrite the entire file,
>>> deleting the original, either by copying it to a different filesystem
>>> and back (with the off-filesystem copy guaranteeing that it can't use
>>> reflinks to the existing extents), or by using cp's --reflink=never
>>> option.
>>> (FWIW, I prefer the former, just to be sure, using temporary copies to
>>> a suitably sized tmpfs for speed where possible, tho obviously if the
>>> file is larger than your memory size that's not possible.)
> 
>> Correct, this is why I recommended trying a defrag.  I've actually never
>> seen things so bad that a simple defrag didn't fix them however (though
>> I have seen a few cases where the target extent size had to be set
>> higher than the default of 20MB).
> 
> Good to know.  I knew larger target extent sizes could help, but between
> not being sure they'd entirely fix it and not wanting to get too far down
> into the detail when the copy-off-the-filesystem-and-back option is
> /sure/ to fix the problem, I decided to handwave that part of it. =:^)
FWIW, a target size of 128M has fixed it on all 5 cases I've seen where 
the default didn't.  In theory, there's probably some really 
pathological case where that won't work, but I've just gotten into the 
habit of using that by default on all my systems now and haven't seen 
any issues so far (but like you I'm pretty much exclusively on SSD's, 
and the small handful of things I have on traditional hard disks are all 
archival storage with WORM access patterns).
> 
>> Also, as counter-intuitive as it
>> might sound, autodefrag really doesn't help much with this, and can
>> actually make things worse.
> 
> I hadn't actually seen that here, but suspect I might, now, as previous
> autodefrag behavior on my system tended to rewrite the entire file[1],
> thereby effectively giving me the benefit of the copy-away-and-back
> technique without actually bothering, while that "bug" has now been fixed.
> 
> I sort of wish the old behavior remained an option, maybe
> radicalautodefrag or something, and must confess to being a bit concerned
> over the eventual impact here now that autodefrag does /not/ rewrite the
> entire file any more, but oh, well...  Chances are it's not going to be
> /that/ big a deal since I /am/ on fast ssd, and if it becomes one, I
> guess I can just setup say firefox-profile-defrag.timer jobs or whatever,
> as necessary.
> 
> ---
> [1] I forgot whether it was ssd behavior, or compression, or what, but
> something I'm using here apparently forced autodefrag to rewrite the
> entire file, and a recent "bugfix" changed that so it's more in line with
> the normal autodefrag behavior.  I rather preferred the old behavior,
> especially since I'm on fast ssd and all my large files tend to be write-
> once no-rewrite anyway, but I understand the performance implications on
> large active-rewrite files such as gig-plus database and VM-image files,
> so...
Hmm.  I've actually never seen such behavior myself.  I do know that 
compression impacts how autodefrag works (autodefrag tries to rewrite up 
to 64k around a random write, but compression operates in 128k blocks), 
but beyond that I'm not sure what might have caused this.
