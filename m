Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34575 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752812AbdKWM7H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 07:59:07 -0500
Received: by mail-oi0-f50.google.com with SMTP id a75so13116097oib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 04:59:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511437679.14360.14.camel@gmail.com>
References: <1511380450.1675.94.camel@gmail.com> <pan$f10dc$17d1769f$63e482de$53d19a75@cox.net>
 <1511437679.14360.14.camel@gmail.com>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Thu, 23 Nov 2017 12:59:06 +0000
Message-ID: <CAMU1PDj+ovqRXOrcnRkr8rP4L+e=g9FXeTmaKBHQ-2o+r2+5vw@mail.gmail.com>
Subject: Re: notification about corrupt files from "btrfs scrub" in cron
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 November 2017 at 11:47, ST <smntov@gmail.com> wrote:
>
>> > I have following cron job to scrub entire root filesystem (total ca.
>> > 7.2TB and 2.3TB of them used) once a week:
>> > /bin/btrfs scrub start -r / > /dev/null
>> >
>> > Such scrubbing takes ca. 2 hours. How should I get notified that a
>> > corrupt file was discovered? Does this command return some error code
>> > back to cron so it can send an email as usual? Will cron wait 2 hours to
>> > get that code?
>> >
>> > I tried that command once without "> /dev/null" but got no email
>> > notification about the results (eventhough the check was OK) - why?
>>
>> See the btrfs-scrub manpage...
>>
>> Note that normally btrfs scrub start is asynchronous and should return
>> effectively immediately, the only possible errors therefore being for
>> example if the given path doesn't point to a btrfs or btrfs-device (which
>> would return a status code of 1, scrub couldn't be performed), etc.
>>
>> Status can be checked via btrfs scrub status, and/or, or you can use the
>> btrfs scrub start's -B (don't background) switch, which will cause it to
>> wait until the scrub is finished and print a summary report.  That should
>> allow you to check for a status code of 3, scrub found uncorrectable
>> errors, as well.
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

Cron starts configured jobs at the scheduled time asynchronously.
I.e. It doesn't block waiting for each command to finish.  Cron notices
when the job finishes and any output produced, written to stdout and/or
stderr, by the job is emailed to the user.  So no, a 2 hour job is not a
problem for cron.

With you redirecting btrfs scrub stdout to /dev/null only any stderr
output will be captured by cron and emailed to you.
(Unfortunately I don't know btrfs scrub well enough to know if it
reports errors to stderr).

Mike
