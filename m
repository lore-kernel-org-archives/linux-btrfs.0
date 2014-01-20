Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob15.myregisteredsite.com ([209.17.115.53]:34214 "EHLO
	atl4mhob15.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbaATQHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 11:07:51 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob15.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0KG7nT5011686
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 11:07:49 -0500
Message-ID: <52DD49F3.8050100@chinilu.com>
Date: Mon, 20 Jan 2014 08:08:19 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com> <52DC9453.4000705@gmail.com> <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de> <52DD426A.5020104@shiftmail.org>
In-Reply-To: <52DD426A.5020104@shiftmail.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reading the recent posts on this topic I am beginning to think 
there is some real confusion between "check sums" and "parity". These 
are two different things which serve two different purposes. In each 
case, bad RAM would have different repercussions.  But I still fail to 
see how, in the case of either btrfs or zfs, bad RAM could damage data 
via the checksum process.  In fact, I would expect that checksum would 
guard against that very thing.  If not, checksum is very badly 
implemented.  Most of the world uses non-ECC RAM.  I simply cannot 
believe that a file system like zfs would expose the user to more risk 
than ext4.  I think there is some very inappropriate panic going on over 
this thing.  Just because one source has asserted that something like 
this can happen does not make it fact.  As it concerns zfs, it needs to 
be brought up at a zfs forum, not here.  As it concerns btrfs, I think 
it has been made clear by some of the sharpest contributors here that 
this is not going to pose any risk with btrfs.  If a btrfs checksum 
fails, btrfs is not going to change anything if it cannot find a copy 
that passes checksum, and bad RAM is not going to cause bad data to pass 
checksum.  But I CAN see how bad RAM could affect parity calculations 
and resulting data IN THE ABSENCE of protective checksums and cannot 
help but wonder if THAT is what the original article is describing.
