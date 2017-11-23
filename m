Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:40847 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdKWLsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 06:48:03 -0500
Received: by mail-wm0-f50.google.com with SMTP id b189so15943173wmd.5
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 03:48:02 -0800 (PST)
Message-ID: <1511437679.14360.14.camel@gmail.com>
Subject: Re: notification about corrupt files from "btrfs scrub" in cron
From: ST <smntov@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 23 Nov 2017 13:47:59 +0200
In-Reply-To: <pan$f10dc$17d1769f$63e482de$53d19a75@cox.net>
References: <1511380450.1675.94.camel@gmail.com>
         <pan$f10dc$17d1769f$63e482de$53d19a75@cox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> > I have following cron job to scrub entire root filesystem (total ca.
> > 7.2TB and 2.3TB of them used) once a week:
> > /bin/btrfs scrub start -r / > /dev/null
> > 
> > Such scrubbing takes ca. 2 hours. How should I get notified that a
> > corrupt file was discovered? Does this command return some error code
> > back to cron so it can send an email as usual? Will cron wait 2 hours to
> > get that code?
> > 
> > I tried that command once without "> /dev/null" but got no email
> > notification about the results (eventhough the check was OK) - why?
> 
> See the btrfs-scrub manpage...
> 
> Note that normally btrfs scrub start is asynchronous and should return 
> effectively immediately, the only possible errors therefore being for 
> example if the given path doesn't point to a btrfs or btrfs-device (which 
> would return a status code of 1, scrub couldn't be performed), etc.
> 
> Status can be checked via btrfs scrub status, and/or, or you can use the 
> btrfs scrub start's -B (don't background) switch, which will cause it to 
> wait until the scrub is finished and print a summary report.  That should 
> allow you to check for a status code of 3, scrub found uncorrectable 
> errors, as well.

Thank you for the response! Does it mean that if write:

/bin/btrfs scrub start -r -B /

cron will hang for 2 hours (is it problematic?) and then send me an
email with the summary report (even if everything was OK), and if I
write:

/bin/btrfs scrub start -r -B / > /dev/null

after 2 hours it will send an email, only if there was an error with
whatever error code (1-3)?

Thank you!

