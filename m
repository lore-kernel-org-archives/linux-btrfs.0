Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53730 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdDRET4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 00:19:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d0KcG-0008Ew-MK
        for linux-btrfs@vger.kernel.org; Tue, 18 Apr 2017 06:19:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: compressing nocow files
Date: Tue, 18 Apr 2017 04:19:42 +0000 (UTC)
Message-ID: <pan$2f715$fa21b851$469190a7$153eb3a4@cox.net>
References: <CAJCQCtTnjNqhSNa9TypsJqvnKeh6H9dKJ9VU8_CHPuzu+zNxsA@mail.gmail.com>
        <20170417180707.GA3856@lim.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo posted on Mon, 17 Apr 2017 11:07:07 -0700 as excerpted:

> On Mon, Apr 17, 2017 at 11:36:17AM -0600, Chris Murphy wrote:
>> HI,
>> 
>> 
>> /dev/nvme0n1p8 on / type btrfs
>> (rw,relatime,seclabel,ssd,space_cache,subvolid=258,subvol=/root)
>> 
>> I've got a test folder with +C set and then copied a test file into it.
>> 
>> $ lsattr ----------------C--
>> ./
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
>> 
>> So now it's inherited +C. Next check fragments and compression.
>> 
>> $ sudo ~/Applications/btrfs-debugfs -f
>> 
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
>> (290662 0): ram 100663296 disk 17200840704 disk_size 100663296 file:
>> 
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
>> extents 1 disk size 100663296 logical size 100663296 ratio 1.00
>> 
>> 
>> Try to compress it.
>> 
>> $ sudo btrfs fi defrag -c
>> 
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
>> 
>> Check again.
>> 
>> [snip faux fragments]
>> file:
>> 
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
>> extents 768 disk size 21504000 logical size 100663296 ratio 4.68
>> 
>> It's compressed! OK??
>> 
>> OK delete that file, and add +c to the temp folder.
>> 
>> $ lsattr --------c-------C-- ./temp
>> 
>> Copy another test file into temp.
>> 
>> $ lsattr --------c-------C--
>> ./
system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
>> 
>> $ sudo ~/Applications/btrfs-debugfs -f
>> 
system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
>> (290739 0): ram 83886080 disk 21764243456 disk_size 83886080 file:
>> 
system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
>> extents 1 disk size 83886080 logical size 83886080 ratio 1.00
>> 
>> Not compressed. Hmmm. So somehow btrfs fi defrag -c will force
>> compression even on nocow files? I've also done this without -c option,
>> with a Btrfs mounted using compress option; and the file does compress
>> also. I thought nocow files were always no compress, but it seems
>> there's exceptions.
>>
>>
> Good catch.
> 
> Btrfs defragment depends on COW to do the job, thus nocow inode are
> forced to COW when processing defraged range, and the compress also
> depends on COW, so btrfs filesystem defrag -c becomes an exception.

Thanks for the explanation. =:^)

> Speaking of which, this exception seems to be not harmful other than
> confusing users.

My question is, what does it do then when a new modification-write comes 
in to the compressed no-cow file, and the modification isn't as 
compressible as the data it replaced?

Actually, do new writes to a defrag-compressed nocow file compress at 
all, or not, and/or does nocow effectively become cow1 (as when a nocow 
file is snapshotted) or even get effectively ignored entirely (as I 
believe happens when a normal cow file is marked nocow after it has been 
written)?

Is this likely to be a source of some of the unreproduced bugs we've 
seen, simply because much like a metadata-inline block followed by extent-
tree blocks, it wasn't supposed to happen and thus wasn't designed for or 
tested for?

(FTR, this shouldn't affect me ATM as AFAIK I have no nocow files; 
systemd is set to produce temporary/tmpfs files only, no permanent 
journal, so its journal files don't even hit btrfs, and I no of no others 
set nocow by default, neither have I set anything nocow.  But that 
doesn't mean I'm not concerned, as it certainly affects others, and could 
hypothetically affect me should I discover I have a reason to nocow 
something.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

