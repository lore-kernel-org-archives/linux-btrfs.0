Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54123 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbdKWJmP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 04:42:15 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eHo19-0000Fq-LM
        for linux-btrfs@vger.kernel.org; Thu, 23 Nov 2017 10:41:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: notification about corrupt files from "btrfs scrub" in cron
Date: Thu, 23 Nov 2017 09:41:50 +0000 (UTC)
Message-ID: <pan$f10dc$17d1769f$63e482de$53d19a75@cox.net>
References: <1511380450.1675.94.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ST posted on Wed, 22 Nov 2017 21:54:10 +0200 as excerpted:

> Hello,
> 
> I have following cron job to scrub entire root filesystem (total ca.
> 7.2TB and 2.3TB of them used) once a week:
> /bin/btrfs scrub start -r / > /dev/null
> 
> Such scrubbing takes ca. 2 hours. How should I get notified that a
> corrupt file was discovered? Does this command return some error code
> back to cron so it can send an email as usual? Will cron wait 2 hours to
> get that code?
> 
> I tried that command once without "> /dev/null" but got no email
> notification about the results (eventhough the check was OK) - why?

See the btrfs-scrub manpage...

Note that normally btrfs scrub start is asynchronous and should return 
effectively immediately, the only possible errors therefore being for 
example if the given path doesn't point to a btrfs or btrfs-device (which 
would return a status code of 1, scrub couldn't be performed), etc.

Status can be checked via btrfs scrub status, and/or, or you can use the 
btrfs scrub start's -B (don't background) switch, which will cause it to 
wait until the scrub is finished and print a summary report.  That should 
allow you to check for a status code of 3, scrub found uncorrectable 
errors, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

