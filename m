Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54347 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbbDYISj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 04:18:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlvIL-0003vP-AF
	for linux-btrfs@vger.kernel.org; Sat, 25 Apr 2015 10:18:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 10:18:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 10:18:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance start -dconvert=raid5 on raid1 not converting to
 raid5
Date: Sat, 25 Apr 2015 08:18:30 +0000 (UTC)
Message-ID: <pan$ef3f8$660eb017$117e7a5d$569a62fd@cox.net>
References: <20150425030040.GA4756@mew>
	<freemail.20150425055650.78792.2@fmxmldata05.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

None None posted on Sat, 25 Apr 2015 05:56:50 +0200 as excerpted:

> Omar Sandoval <osandov@osandov.com> írta:
>>On Sat, Apr 25, 2015 at 04:47:31AM +0200, None None wrote:
>>> I tried to convert my btrfs from raid1 to raid5 but after the balance
>>> command it&#39;s still raid1.
>>
>>This is a known bug in v4.0. I sent in a patch [1] to revert the commit
>>that caused the regression, but it didn&#39;t get any response. You
>>could apply that or just revert 2f0810880f08 ("btrfs: delete chunk
>>allocation attemp when setting block group ro") to fix your problem for
>>now.
>>
>>[1]: https://patchwork.kernel.org/patch/6238111/
>>
> I'll give it a try, thanks for the fast reply.

FWIW, while I've not been following this /too/ closely (as my use-case 
has zero reason to do a convert), I believe I saw Chris and others 
discussing the patch, and I /think/ it (or an update) may have actually 
been in the 4.1 upgrade window pull.

Presumably they'll queue it for stable too, once it's in 4.1 (or whatever 
if I'm wrong on the 4.1 pull).

A verify either way would be useful, but as I said I've not been 
following it /too/ closely, and I'm still on 4.0 here, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

