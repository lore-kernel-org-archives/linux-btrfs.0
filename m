Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58191 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbbJTTUt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 15:20:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZocSd-0008Ey-QG
	for linux-btrfs@vger.kernel.org; Tue, 20 Oct 2015 21:20:39 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 21:20:39 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 21:20:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
Date: Tue, 20 Oct 2015 19:20:27 +0000 (UTC)
Message-ID: <pan$6a87$d56eafce$4f04d0c$30b17c06@cox.net>
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
	<201510201545.50705.russell@coker.com.au> <56263B0B.4050502@gmail.com>
	<201510210015.54337.russell@coker.com.au> <562648B5.2020401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Tue, 20 Oct 2015 09:59:17 -0400 as
excerpted:


>>> It is worth clarifying also that:
>>> a. While BTRFS will not return bad data in this case, it also won't
>>> automatically repair the corruption.
>>
>> Really?  If so I think that's a bug in BTRFS.  When mounted rw I think
>> that every time corruption is discovered it should be automatically
>> fixed.
> That's debatable.  While it is safer to try and do this with BTRFS than
> say with MD-RAID, it's still not something many seasoned system
> administrators would want happening behind their back.  It's worth
> noting that ZFS does not automatically fix errors, it just reports them
> and works around them, and many distributed storage options (like Ceph
> for example) behave like this also.  All that the checksum mismatch
> really tells you is that at some point, the data got corrupted, it could
> be that the copy on the disk is bad, but it could also be caused by bad
> RAM, a bad storage controller, a loose cable, or even a bad power
> supply.

There's a significant difference between btrfs in dup/raid1/raid10 modes 
anyway and some of the others you mentioned, however.  Btrfs in these 
modes actually has a second copy of the data itself available.  That's a 
world of difference compared to parity, for instance.  With parity you're 
reconstructing the data and thus have dangers such as the write hole, and 
the possibility of bad-ram corrupting the data before it was ever saved 
(this last one being the reason zfs has such strong recommendations/
warnings regarding the use of non-ecc RAM, based on what a number of 
posters with zfs experience have said, here).  With btrfs, there's an 
actual second copy, with both copies covered by checksum.  If one of the 
copies verifies against its checksum and the other doesn't, the odds of 
the one that verifies being any worse than the one that doesn't are... 
pretty slim, to say the least.  (So slim I'd intuitively compare them to 
the odds of getting hit by lightning, tho I've no idea what the 
mathematically rigorous comparison might be.)

Yes, there's some small but not infinitesimal chance the checksum may be 
wrong, but if there's two copies of the data and the checksum on one is 
wrong while the checksum on the other verifies... yes, there's still that 
small chance that the one that verifies is wrong too, but that it's any 
worse than the one that does not verify?  /That's/ getting close to 
infinitesimal, or at least close enough for the purposes of a mailing-
list claim without links to supporting evidence by someone who has 
already characterized it as not mathematically rigorous... and for me, 
personally.  I'm not spending any serious time thinking about getting hit 
by lightening, either, tho by the same token I don't go out flying kites 
or waving long metal rods around in lightning storms, either.

Meanwhile, it's worth noting that btrfs itself isn't yet entirely stable 
or mature, and that the chances of just plain old bugs killing the 
filesystem are far *FAR* higher than of a verified-checksum copy being 
any worse than a failed-checksum copy.  If you're worried about that at 
this point, why are you even on the btrfs list in the first place?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

