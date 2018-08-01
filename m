Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38793 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1733177AbeHAKfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 06:35:31 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fkmoA-0002oo-8a
        for linux-btrfs@vger.kernel.org; Wed, 01 Aug 2018 10:48:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS and databases
Date: Wed, 1 Aug 2018 08:48:31 +0000 (UTC)
Message-ID: <pan$53fe4$7e22d563$460317d1$60bf94e5@cox.net>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MegaBrutal posted on Wed, 01 Aug 2018 05:45:15 +0200 as excerpted:

> But there is still one question that I can't get over: if you store a
> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
> with nodatacow, or would you just simply use ext4?
> 
> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance – the exact CoW nature
> that is elsewhere a blessing, with databases it's a drawback). But are
> there any advantages of still sticking to BTRFS for a database albeit
> CoW is disabled, or should I just return to the old and reliable ext4
> for those applications?

Good question, on which I might expect some honest disagreement on the 
answer.

Personally, I tend to hate nocow with a passion, and would thus recommend 
putting databases and similar write-pattern (VM images...) files on their 
own dedicated non-btrfs (ext4, etc) if at all reasonable.

But that comes from a general split partition-favoring viewpoint, where 
doing another partition/lvm-volume and putting a different filesystem on 
it is no big deal, as it's just one more partition/volume to manage of 
(likely) several.

Some distros/companies/installations have policies strongly favoring 
btrfs for its "storage pool" features, trying to keep things simple and 
flexible by using just the one solution and one big btrfs and throwing 
everything onto it, often using btrfs subvolumes where others would use 
separate partitions/volumes with independent filesystems.  For these 
folks, the flexibility of being able to throw it all on one filesystem 
with subvolumes overrides the down sides of having to deal with nocow and 
its conditions, rules and additional risk.

And a big part of that flexibility, along with being a feature in its own 
right, is btrfs built-in multi-device, without having to resort to an 
additional multi-device layer such as lvm or mdraid.


So if you're using btrfs for multi-device or other features that nocow 
doesn't affect, it's plausible that you'd prefer nocow on btrfs to 
/having/ to do partitioning/lvm/mdraid and setup that separate non-btrfs 
just for your database (or vm image) files.

But from your post you're perfectly fine with partitioning and the like 
already, and won't consider it a heavy imposition to deal with a separate 
non-btrfs, ext4 or whatever, and in that case, at least here, I'd 
strongly recommend you do just that, avoiding the nocow that I honestly 
see as a compromise best left to those that really need it because they 
aren't prepared to deal with the hassle of setting up the separate 
filesystem along with all that entails.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

