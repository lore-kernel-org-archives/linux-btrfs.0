Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50097 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdKXBEa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 20:04:30 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eI2Pk-0001bX-67
        for linux-btrfs@vger.kernel.org; Fri, 24 Nov 2017 02:04:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: notification about corrupt files from "btrfs scrub" in cron
Date: Fri, 24 Nov 2017 01:04:08 +0000 (UTC)
Message-ID: <pan$8e7ae$4b4e3128$927e4775$98a81465@cox.net>
References: <1511380450.1675.94.camel@gmail.com>
        <pan$f10dc$17d1769f$63e482de$53d19a75@cox.net>
        <1511437679.14360.14.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ST posted on Thu, 23 Nov 2017 13:47:59 +0200 as excerpted:

>> > I have following cron job to scrub entire root filesystem (total ca.
>> > 7.2TB and 2.3TB of them used) once a week:
>> > /bin/btrfs scrub start -r / > /dev/null
>> > 
>> > Such scrubbing takes ca. 2 hours. How should I get notified that a
>> > corrupt file was discovered? Does this command return some error code
>> > back to cron so it can send an email as usual? Will cron wait 2 hours
>> > to get that code?
>> > 
>> > I tried that command once without "> /dev/null" but got no email
>> > notification about the results (eventhough the check was OK) - why?
>> 
>> See the btrfs-scrub manpage...
>> 
>> Note that normally btrfs scrub start is asynchronous and should return
>> effectively immediately, the only possible errors therefore being for
>> example if the given path doesn't point to a btrfs or btrfs-device
>> (which would return a status code of 1, scrub couldn't be performed),
>> etc.
>> 
>> Status can be checked via btrfs scrub status, and/or, or you can use
>> the btrfs scrub start's -B (don't background) switch, which will cause
>> it to wait until the scrub is finished and print a summary report. 
>> That should allow you to check for a status code of 3, scrub found
>> uncorrectable errors, as well.
> 
> Thank you for the response! Does it mean that if write:
> 
> /bin/btrfs scrub start -r -B /
> 
> cron will hang for 2 hours (is it problematic?) and then send me an
> email with the summary report (even if everything was OK), and if I
> write:
> 
> /bin/btrfs scrub start -r -B / > /dev/null
> 
> after 2 hours it will send an email, only if there was an error with
> whatever error code (1-3)?

I /did/ say see the manpage...  There's a -q/quiet option as well, so 
redirecting to /dev/null isn't necessary.  There are other options you 
might find useful as well, that I didn't mention but that are covered in 
the manpage.  That's why I said see it. =:^)

Tho since you obviously didn't look at it yet, it occurs to me that 
perhaps you need to know /how/ to "see the btrfs-scrub manpage".  Try 
simply "man btrfs-scrub" (without the quotes) at a terminal command-
prompt.  FWIW, you can try simply "man btrfs" to get a more general 
overview as well, or "man 5 btrfs", since there's more than one "btrfs" 
manpage, and the 5 will give you the one from section 5, generally format 
documentation, etc, as opposed to section 1 (user commands) and section 8 
(superuser/admin commands, which is where most btrfs manpages are), which 
will normally appear before a section 5 manpage of the same name.  Of 
course you could try "man man" to get more information about man, as well.

As for cron, note that there's many different implementations that 
presumably act somewhat differently, and many distros don't tend to 
configure cron to directly start most of their stuff anyway, because 
cron, at least originally, would only start scheduled jobs if it (and 
thus the computer) were actually running at the time the job was 
scheduled -- it had no built-in mechanism to check for overdue items and 
run them when it was restarted after being off for awhile.  Because many 
users actually turn their computers off... or suspend or hibernate 
them... when they're not in use, that didn't work so well, so most 
distros I've seen actually have cron run a script say every 10 minutes or 
every hour, that checks if any scheduled jobs have passed their trigger 
time, and starts them if so.

And of course these days, on most distros systemd is taking over 
scheduling tasks with its timers, including one that runs "legacy" cron 
jobs as necessary.

So I'd suggest reading up on whatever your cron implementation happens to 
be, as well.  Maybe start with the manpages...  And then check the 
existing jobs to see what they actually do.  But as Mike says, cron 
typically runs async regardless of the implementation, so it doesn't 
"hang" while running a scheduled job.

And of course, typically when setting up a cron job, admins will normally 
run the command manually to see that it does what they expect and need, 
before scheduling it, and then, when setting it up as a cron job, they 
may first schedule it right away and monitor it to see how things go, 
before setting it up with a more permanent schedule.  IOW, they'll do a 
test run.  That way they know what to expect from the permanently 
scheduled job.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

