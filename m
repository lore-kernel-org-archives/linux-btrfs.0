Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42899 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbbHLF2d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 01:28:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZPOaU-0000ek-Hy
	for linux-btrfs@vger.kernel.org; Wed, 12 Aug 2015 07:28:30 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 07:28:30 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 07:28:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Damaged filesystem, can read, can't repair, error says to
 contact devs
Date: Wed, 12 Aug 2015 05:28:20 +0000 (UTC)
Message-ID: <pan$19db6$fb18a91a$2de24d40$7f0c3415@cox.net>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
	<CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
	<CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
	<CAK7bmU_fQhG2mP4x6n-Ga-WmiqJLU5cvRqAPk1Rr9JGYnyMZ2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timothy Normand Miller posted on Tue, 11 Aug 2015 17:32:12 -0400 as
excerpted:

> On Tue, Aug 11, 2015 at 5:24 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
> 
>>> There is still data redundancy.  Will a scrub at least notice that the
>>> copies differ?
>>
>> No, that's what I mean by "nodatasum means no raid1 self-healing is
>> possible". You have data redundancy, but without checksums btrfs has no
>> way to know if they differ. It doesn't do two reads and compares them,
>> it's just like md raid, it picks one device, and so long as there's no
>> read error from the device, that copy of the data is assumed to be
>> good.
> 
> Ok, that makes sense.  I'm guessing it wouldn't be worth it to add a
> feature like this because (a) few people use nodatacow or end up in my
> situation, and (b) if they did, and the two copies were inconsistent,
> what would you do?  I suppose for me, it would be nice to know which
> files were affected.

FWIW, nodatacow and nodatasum are intended to /eventually/ be per-
subvolume mount options.  The infrastructure is there to make it so.  
It's just that the code to actually handle those mount options separately 
per subvolume doesn't exist yet, so they apply globally.

Similarly, the intention is to eventually allow per-subvolume and 
possibly even per-file raid-level specifications, while currently, the 
whole filesystem must be set to the same raid level (except that data and 
metadata raid levels are set separately).  It is currently possible to 
have multiple raid levels, but only because a raid-level conversion was 
started (either due to a balance-convert, or due to adding a second 
device changing the metadata default to raid1 from dup, for instance) and 
never finished.

So it's not so much a question of "not worth it" to add the no-checksum 
data redundancy scrub feature, it's that nodatacow and nodatasum are 
really intended to be exceptions where the admin has specifically 
disabled the checksumming, and are not intended to ever apply to a full 
filesystem, only, at most, to a particular subvolume.  The fact that if 
the mount option is used today it applies to the full filesystem is 
simply a temporary situational accident of not having the per-subvolume 
mount-option code implemented yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

