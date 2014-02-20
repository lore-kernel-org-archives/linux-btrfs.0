Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59467 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaBTLRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 06:17:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGRcv-000177-GO
	for linux-btrfs@vger.kernel.org; Thu, 20 Feb 2014 12:17:13 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 12:17:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 12:17:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Meaning of "no_csum" field when scrubbing with -R option
Date: Thu, 20 Feb 2014 11:16:47 +0000 (UTC)
Message-ID: <pan$80644$31e17f17$3235a144$9c73675@cox.net>
References: <5304AA69.5020800@informatik.uni-bonn.de>
	<pan$165e8$a9517bbb$99fb7bd6$7e251ef6@cox.net>
	<5305DE1E.8080302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong posted on Thu, 20 Feb 2014 18:51:10 +0800 as excerpted:

> On 02/20/2014 06:31 PM, Duncan wrote:
>> Sebastian Ochmann posted on Wed, 19 Feb 2014 13:58:17 +0100 as
>> excerpted:
>>
>>> So my question is, why does scrub show a high (i.e. non-zero) value
>>> for no_csum? I never enabled nodatasum or a similar option.

> Did you enable nodatacow option? if  nodatacow option is enabled,
> data checksums will be also disabled at the same time.

I have not.  Everything here is standard checksummed COW, which is why I 
wondered why I was seeing the no_csum results.

Tho in my case there's few enough I thought it might have been triggered 
by some other abnormality.

(In particular, I was suspending-to-ram for awhile, and if I left the 
system suspended too long, the disks wouldn't wake up fast enough on 
resume and one of the raid1 pair would often drop out, forcing the 
filesystem to read-only and generally a pretty quick reboot, after which 
I'd have to do a scrub to sync the raid1 back up.  I had guessed the no-
csum instances might have been half-written at the suspend, but it 
bothered me.

That was a couple kernels ago, tho.  I decided to quit risking the 
suspend-to-ram since I was sometimes having to reboot anyway and I did 
end up with a file or two corrupted (even after scrub) as a result, so 
I've not had that issue or had any other scrub errors in some months 
now.  I've thought I should try it again and see if it works better now, 
but I haven't done so yet.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

