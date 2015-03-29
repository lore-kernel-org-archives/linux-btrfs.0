Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbbC2Ooz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 10:44:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YcES7-0005Gk-Bz
	for linux-btrfs@vger.kernel.org; Sun, 29 Mar 2015 16:44:39 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 16:44:39 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 16:44:39 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Date: Sun, 29 Mar 2015 16:44:30 +0200
Message-ID: <enflub-up7.ln1@hurikhan77.spdns.de>
References: <meq6hm$lbh$1@ger.gmane.org> <20150323232212.GL31762@carfax.org.uk> <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com> <mf2701$d5k$1@ger.gmane.org> <CAGfcS_k=__EfJssYt9Ra77uAtW6PfqV1fqAX03VfJiPi_T5TBQ@mail.gmail.com> <d35lub-tec.ln1@hurikhan77.spdns.de> <CAGfcS_nG3gt=copDrWS9TEmZ-dn6WD+HODU1SyxNVvbBqLXQ0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman <r-btrfs@thefreemanclan.net> schrieb:

> On Sun, Mar 29, 2015 at 7:43 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
>>
>> With the planned performance improvements, I'm guessing the best way will
>> become mounting the root subvolume (subvolid 0) and letting duperemove
>> work on that as a whole - including crossing all fs boundaries.
>>
> 
> Why cross filesystem boundaries by default?  If you scan from the root
> subvolume you're guanteed to traverse every file on the filesystem
> (which is all that can be deduped) without crossing any filesystem
> boundaries.  Even if you have btrfs on non-btrfs on btrfs there must
> be some other path that reaches the same files when scanning from
> subvolid 0.

Yes, the chosen "default" is probably not the best for this kind of utility. 
But I suppose it follows the principle of least surprise. At least every 
utility I'm daily using (like find) follows this default route. By the way, 
I wrote "default" because one should keep in mind that it is not recursive 
by default (and thus crossing the boundary wouldn't even apply in the 
default configuration) which only strengthens my point for the principle of 
least surprise. And I'd leave that open for discussion here to change the 
default, all I suggested was that duperemove should not try to become smart 
about it as the only choice (behavior will be undefined otherwise when 
deploying this on a vast amount of individually configured systems). I could 
image that there was a cmdline option to make it smart.

The idea for subvolid 0: It is just pure intention how I would use it for my 
personal purpose. By no means this should be in any default deployments.

-- 
Replies to list only preferred.

