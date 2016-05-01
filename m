Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41397 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbcEAXWn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 19:22:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ax0hF-00014E-BM
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 01:22:41 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 01:22:41 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 01:22:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Sun, 1 May 2016 23:22:35 +0000 (UTC)
Message-ID: <pan$366ac$fef69b67$e706653c$74397472@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
	<20160501185418.5a148cdd@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 01 May 2016 18:54:18 +0200 as excerpted:

>> > I created a backtrace in dmesg using sysrq+w. Here's the log:
>> > (https://gist.github.com/kakra/8e6a2b7ac4047fa9e345648664f5667b)  
>> 
>> FWIW, that link give me the github "this is not the web page you are
>> looking for" 404 error...  Do you have it set private or something?
> 
> Yes it's private but it's working for me in an incognito window of
> Chromium. So maybe you copied the closing bracket or something into the
> URL? Or some temporary error?

FWIW I didn't actually copy it, I just clicked the link, but my client is 
dumb enough to include closing brackets/parenthesis in links, so...

And I'm dumb enough to have forgotten that irritating bug in my client,
tho I know about it and have caught and corrected it before, so...

Thanks for pointing that out, it was indeed that closing parenthesis.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

