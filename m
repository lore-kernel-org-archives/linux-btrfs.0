Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47679 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466AbbLBNqd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 08:46:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a47jS-0006HO-OJ
	for linux-btrfs@vger.kernel.org; Wed, 02 Dec 2015 14:46:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 14:46:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 14:46:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: utils version and convert crash
Date: Wed, 2 Dec 2015 13:45:17 +0000 (UTC)
Message-ID: <pan$85c2b$46f55be$d534ced$bd1aab07@cox.net>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
	<pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
	<CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
	<565E0356.9030006@gmail.com>
	<CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
	<CA+WRLO_1bLpve50YkuGD4wDxyO_e=4u9xev8y4XxZT9L01KxDQ@mail.gmail.com>
	<pan$c5c73$162474d7$f06e12fa$496fb5f@cox.net> <565EE329.3050902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 02 Dec 2015 07:25:13 -0500 as
excerpted:

> On 2015-12-02 05:01, Duncan wrote:

[on unverified errors returned by scrub]
>>
>> Unverified errors are, I believe[1], errors where a metadata block
>> holding checksums itself has an error, so the blocks its checksums in
>> turn covered are not checksum-verified.
>>
>> What that means in practice is that once the first metadata block error
>> has been corrected in a first scrub run, a second scrub run can now
>> check the blocks that were recorded as unverified errors in the first
>> run, potentially finding and hopefully fixing additional errors[.]

>> ---
>> [1] I'm not a dev and am not absolutely sure of the technical accuracy
>> of this description, but from an admin's viewpoint it seems to be
>> correct at least in practice, based on the fact that further scrubs as
>> long as there were unverified errors often did find additional errors,
>> while once the unverified count dropped to zero and the last read
>> errors were corrected, further scrubs turned up no further errors.
>>
> AFAICT from reading the code, that is a correct assessment.  It would be
> kind of nice though if there was some way to tell scrub to recheck up to
> X many times if there are unverified errors...

Yes.  For me as explained it wasn't that big a deal as another scrub was 
another minute or less, but definitely on terabyte-scale filesystems on 
spinning rust, where scrubs take hours, having scrub be able to 
automatically track just the corrected errors along with their 
unverifieds, and rescan just those, should only take a matter of a few 
minutes more, while a full rescan of /everything/ would take the same 
number of hours yet again... and again if there's a third scan required, 
etc.

I'd say just make it automatic on corrected metadata errors as I can't 
think of a reason people wouldn't want it, given the time it would save 
over rerunning a full scrub over and over again, but making it an option 
would be fine with me too.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

