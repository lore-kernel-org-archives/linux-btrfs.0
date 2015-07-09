Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40339 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbbGIO6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 10:58:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZDDH9-0001mB-1d
	for linux-btrfs@vger.kernel.org; Thu, 09 Jul 2015 16:58:11 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 16:58:11 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 16:58:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Date: Thu, 9 Jul 2015 14:58:00 +0000 (UTC)
Message-ID: <pan$80db3$57bc5aa6$1bb3a1f9$e86b9507@cox.net>
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
	<CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
	<559E6411.6090109@gmail.com> <20150709124121.GA25033@panda>
	<559E6D80.7010607@gmail.com>
	<pan$808e5$18b28ebb$f039d1c6$8c98ba86@cox.net>
	<20150709135448.GH10539@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 09 Jul 2015 13:54:48 +0000 as excerpted:

> On Thu, Jul 09, 2015 at 01:43:53PM +0000, Duncan wrote:
>> I could have sworn btrfs property -t subvolume can get/set that
>> snapshot bit.  I know I saw the discussion and I think patch for it go
>> by, but again, as I don't use them, I haven't tracked closely enough to
>> see if it ever got in.
> 
> Are you thinking of the read-only flag? That's not the same thing
> as the various UUID properties (e.g. parent) which can be used to
> detemine if a subvolume was made using a snapshot.

Perhaps, but I was sure there was a snapshot property too, because I 
remember discussion of being able to unset it in ordered to remove it 
from the snapshot (only) list.

But maybe that's all it was, discussion, it wasn't implemented, and I 
ended up conflating it with the read-only bit, which /can/ be set/unset 
that way.  Like I said I can't check as I don't have any subvolumes/
snapshots available to do a listing on and see, and the property manpage 
doesn't have a properties list to check on, it wants you to use the list 
option to get the list.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

