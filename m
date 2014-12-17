Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53099 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaLQLPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 06:15:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y1CYy-0003Jq-B3
	for linux-btrfs@vger.kernel.org; Wed, 17 Dec 2014 12:14:40 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:14:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:14:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Quota limit question
Date: Wed, 17 Dec 2014 11:13:28 +0000 (UTC)
Message-ID: <pan$d0df9$15eccc0$adce85d2$8664a8de@cox.net>
References: <20141217011537.GA1114@anthem.async.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Robottom Reis posted on Tue, 16 Dec 2014 23:15:37 -0200 as
excerpted:

>     # btrfs qgroup limit 2000m 0/261 . && touch x
>     touch: cannot touch ‘x’: Disk quota exceeded
> 
> The strange thing is that it doesn't seem to be actually out of space:
> 
>     # btrfs qgroup show -p -r -e /var | grep 261
>     0/261    1111810048  391114752   2097152000  0          ---

>     # btrfs --version Btrfs v3.12
> 
>     # uname -a
>     Linux riff 3.13.0-43-generic #72-Ubuntu SMP
>     Mon Dec 8 19:35:06 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

Does the problem still exist with a current 3.18 series kernel and 3.17 
series btrfs userspace?  The quota code in the versions you appear to be 
running had some (rather severe, quotes could go negative at times!) 
known bugs and was rewritten recently.  I don't use quotas here and don't 
know for sure whether the quota rewrite made it into kernel 3.17, but 
current 3.18 should have it, and current userspace is I believe 3.17.3, 
so you should consider upgrading it as well.

More in general, consider your use-case.  While btrfs is no longer the 
experimental filesystem it once was (tho the warnings weren't removed 
until after the old 3.12/3.13 you're running, AFAIK), it's still 
maturing, and running year-old code still means running code with bugs 
that are known and have been fixed for a year.  There's a place for being 
conservative and running old and known stable code, but btrfs is still 
young and maturing and doesn't match that use-case very well.  Either you 
need stable and mature and an equally stable and mature filesystem is a 
better fit, at least for a couple more years, or you want newer 
technology/code and running year-old stuff is behind the curve.  Either 
way, running year-old btrfs code, both kernel and userspace, doesn't make 
a lot of sense.  Perhaps in a couple years it will, after btrfs is more 
mature and stable and year-old code doesn't mean year-stale bugs, but not 
currently.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

