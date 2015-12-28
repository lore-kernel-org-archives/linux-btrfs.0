Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37891 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbL1KfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 05:35:02 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDV8l-0004y4-H2
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 11:34:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 11:34:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 11:34:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: https://btrfs.wiki.kernel.org having OCSP issues?
Date: Mon, 28 Dec 2015 10:34:49 +0000 (UTC)
Message-ID: <pan$59692$556172e2$cc197921$a67a7f3f@cox.net>
References: <pan$d5d71$dbb2da33$97fb9c4d$f6fd4df8@cox.net>
	<20151228142943.3ea78db6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Mon, 28 Dec 2015 14:29:43 +0500 as excerpted:

> On Mon, 28 Dec 2015 09:20:09 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> Firefox is currently giving me OCSP errors for the wiki.  Links has no
>> problem, presumably because it doesn't validate the cert or ignores
>> OCSP timeouts, but lynx is throwing errors as well, so it's not just
>> firefox.
> 
> Do you get the same problem with https://www.kernel.org/ ?

That one works fine.
 
> Or any other wiki listed at https://wiki.kernel.org/ ?

That one doesn't.  Same sec_error_ocsp_bad_signature error.

> Can you download http://crl.startssl.com/crt2-crl.crl at your machine?

That works fine.  But according to wikipedia (where https is working 
fine, BTW), OCSP was created as an alternative to CRLs.

https://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol

Based on the sequence outlined there and the error firefox is returning, 
seems the OCSP responder is returning responses that don't verify against 
its public key.  So assuming no MitM attack, it'd be the OCSP responder 
that's badly configured, not (directly) wiki.kernel.org or its cert.

> In general this seems to be a kernel.org webmasters concern, not for
> Btrfs developers to do anything about.

Agreed.  But bugzilla.kernel.org is failing with the same error, so I 
can't report the bug there... or even look to see if anyone else has in 
the hour or two since I started seeing issues.  And this is the only vger 
list I follow, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

