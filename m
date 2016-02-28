Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47469 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975AbcB1KCI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 05:02:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aZyAr-0003E7-Uo
	for linux-btrfs@vger.kernel.org; Sun, 28 Feb 2016 11:02:02 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 11:02:01 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 11:02:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs equivalent for zfs send -R
Date: Sun, 28 Feb 2016 10:01:56 +0000 (UTC)
Message-ID: <pan$1bf37$b60b93d6$5072bdd4$eb5ad548@cox.net>
References: <56D18C3F.9000105@it.auth.gr>
	<pan$e2074$912b63a0$272af732$4acdc80a@cox.net>
	<56D2AD22.1030404@it.auth.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Γιώργος Πάλλας posted on Sun, 28 Feb 2016 10:17:38 +0200
as excerpted:

> On 28/02/16 05:45, Duncan wrote:
>> Γιώργος Πάλλας posted on Sat, 27 Feb 2016 13:45:03 +0200
>> as excerpted:
>>
>>> Hi all.
>>>
>>> If I have a btrfs subvolume 'subv' and then subvolumes subv/sub1,
>>> subv/sub2, subv/sub3, is there a way to snapshot all the subv tree and
>>> then recursively send it remotely?
>>>
>>> I think this would be the analogous of zfs snapshot -r, and then zfs
>>> send -R.
>> As a list regular and btrfs user myself, but not a dev...
>>
>> No idea about zfs and my own btrfs use-case doesn't use btrfs send/
>> receive either, so this is primarily from previous list posts, with a
>> quick look at the (v4.4.1) btrfs-send manpage as well...
>>
>> Recursive send isn't yet supported, only one at a time.
>>
>> Based on a previous comment from someone who apparently looked at the
>> code (but isn't a btrfs dev either), there's possibly some code for -r
>> (recursive) already in the repo (or maybe it's simply a comment 
reserving
>> the -r option?), but it doesn't work yet.
>>
>> However, it shouldn't be horribly difficult to hack up scripts that
>> automate the otherwise manual recursive-send/receive for you, as I'd 
very
>> likely do myself if I needed that functionality. =:^)
>>
> 
> Thanks for the reply Duncan.
> 
> The problem with scripting the recursive process, as I understand it,
> is that in the case of e.g. adding an identical file inside each one
> sub subvolume, this file would have to be transmitted during send, so
> many times as the number of the sub subvolumes, which of course is not 
> viable. Am I right?

As I understand it, no.  What you're looking for is the -c <clone-src> 
option.  While there can be only one parent, many clone-sources are 
allowed.  Send does transfer a bit more metadata for clone-sources than 
it does for parents, but where it finds a clone, it's just that metadata, 
not the whole file.

I /suspect/, however, that running dedup on the clone-sources first, such 
that the sources do share reflinks with the sent subvolume, will increase 
the hit-rate on the clones.  I suspect that if the same file is 
separately added, without dedup, so the sources have multiple copies, not 
a shared copy, btrfs send won't detect the dups at send-time because 
they're not reflinking the same extents and thus aren't, to btrfs, 
duplicates.

The inline dedup patches now being processed should help in that regard, 
however, avoiding having to run a separate dedup later, as has been the 
case with dedup so far.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

