Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59401 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S933687AbeB1T4Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 14:56:25 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1er7ns-0004FY-Qi
        for linux-btrfs@vger.kernel.org; Wed, 28 Feb 2018 20:54:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs space used issue
Date: Wed, 28 Feb 2018 19:54:10 +0000 (UTC)
Message-ID: <pan$dd7e7$8a56ef21$d7fa0ab5$d833c283@cox.net>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
        <pan$e116f$e5aa2400$88c9d453$f5589ed1@cox.net>
        <2892a866-fdc3-b337-4cd4-2cd4a18b9f21@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 28 Feb 2018 14:24:40 -0500 as
excerpted:

>> I believe this effect is what Austin was referencing when he suggested
>> the defrag, tho defrag won't necessarily /entirely/ clear it up.  One
>> way to be /sure/ it's cleared up would be to rewrite the entire file,
>> deleting the original, either by copying it to a different filesystem
>> and back (with the off-filesystem copy guaranteeing that it can't use
>> reflinks to the existing extents), or by using cp's --reflink=never
>> option.
>> (FWIW, I prefer the former, just to be sure, using temporary copies to
>> a suitably sized tmpfs for speed where possible, tho obviously if the
>> file is larger than your memory size that's not possible.)

> Correct, this is why I recommended trying a defrag.  I've actually never
> seen things so bad that a simple defrag didn't fix them however (though
> I have seen a few cases where the target extent size had to be set
> higher than the default of 20MB).

Good to know.  I knew larger target extent sizes could help, but between 
not being sure they'd entirely fix it and not wanting to get too far down 
into the detail when the copy-off-the-filesystem-and-back option is 
/sure/ to fix the problem, I decided to handwave that part of it. =:^)

> Also, as counter-intuitive as it
> might sound, autodefrag really doesn't help much with this, and can
> actually make things worse.

I hadn't actually seen that here, but suspect I might, now, as previous 
autodefrag behavior on my system tended to rewrite the entire file[1], 
thereby effectively giving me the benefit of the copy-away-and-back 
technique without actually bothering, while that "bug" has now been fixed.

I sort of wish the old behavior remained an option, maybe 
radicalautodefrag or something, and must confess to being a bit concerned 
over the eventual impact here now that autodefrag does /not/ rewrite the 
entire file any more, but oh, well...  Chances are it's not going to be 
/that/ big a deal since I /am/ on fast ssd, and if it becomes one, I 
guess I can just setup say firefox-profile-defrag.timer jobs or whatever, 
as necessary.

---
[1] I forgot whether it was ssd behavior, or compression, or what, but 
something I'm using here apparently forced autodefrag to rewrite the 
entire file, and a recent "bugfix" changed that so it's more in line with 
the normal autodefrag behavior.  I rather preferred the old behavior, 
especially since I'm on fast ssd and all my large files tend to be write-
once no-rewrite anyway, but I understand the performance implications on 
large active-rewrite files such as gig-plus database and VM-image files, 
so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

