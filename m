Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbcEQMmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 08:42:47 -0400
Date: Tue, 17 May 2016 14:42:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
Message-ID: <20160517124218.GK511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com>
 <20160510074203.GP29353@twin.jikos.cz>
 <57319541.7000300@oracle.com>
 <20160510082120.GQ29353@twin.jikos.cz>
 <57319E9A.8070003@oracle.com>
 <20160510142856.GV29353@twin.jikos.cz>
 <5731F771.2060509@oracle.com>
 <20160511105619.GZ29353@twin.jikos.cz>
 <57331DCD.2090600@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57331DCD.2090600@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 07:55:57PM +0800, Anand Jain wrote:
> > * current default is to print the device name -- so this would mean a
> >    forced change in defaults
> > * the FSID is not very human friendly. I can remember several device
> >    names and I'll probably know which filesystem is on which
> > * the FSID is very long, consumes half of the line before the actual
> >    message starts
> 
>    Yes, indeed. I think we discussed that there isn't any other
>    alternative as well. Also I was thinking something like in
>    the 'git log --online' output but that might conflict in some
>    cases ? (recently there was a progs patch which fixed the short fsid
>    hash conflict).

You mean a shorter UUID? The first four bytes (8 hexa digits) seem
unique enough. That can be optinal I think.

> > I understand the benefits of automated filtering by FSID, but we have
> > conflicting interests here. If you're going to deploy automated log
> > scanning, you probably have automated the filesystem mkfs & mount, so
> > it's a matter of configuration to get it done and in one place.
> 
>    Makes sense.
> 
>    Actually automated scripts wasn't in my discussion, I was thinking
>    of support engineers debugging customer issues using hand written
>    scripts.

I'm not sure how far should we forsee problems that somebody else may
theoretically encounter. Providing grounds for easy navigation and
searchability in the logs is on our side, but if somebody does not know
how to properly look for them, that's not our problem.

>    Probably we could taken an experimental project, to have these
>    logs in cvs format, and use external scripts to monitor and
>    debug. Make something like splunk.com an easy job.

As far as the format stays parseable, everybody should be ok. CSV does
not sound like a good idea to me though.

> >>    Just my understanding:
> >>    For real end users we need to provide everything at the cli output.
> >>    That is without asking them to refer to dmesg in the cli out put. IMO.
> >>    (I could be wrong). Troubleshooters are the people looking at dmesg.
> >>    So finding the FSID can be expected ?
> >
> > I don't think that looking up device names is making troubleshooting
> > significantly harder and never found it to be a problem in my past
> > experienes.
> >
> > Besides, errors from lower layers report the device names, so bad
> > sectors or failed writes pop up very quickly in the searches.
> 
>   Right. FSID won't provide that advantage.
> 
> > Either way, I'm willing to make it configurable so it addresses all
> > usecases.
> 
> 
> > Another way came to my mind: make it a module parameter, so
> > even the mount option or sysfs settings is not needed and the defaults
> > are system-wide.
> 
>   Yep. This helps.
>   I was thinking from the angle of support engineers, who would
>   solve customers issues (it happens at most of the Linux vendors),
>   They would write/run scripts on their own to understand the problem
>   from the kernel logs. So now it can be assured that logs format
>   would remain same per distribution/vendor.

I was working in support for a few years and have an experience with
digging in the logs. There was a lot of custom scripting and grepping
needed as the problem reports were mostly unique. Some tasks were common
so one script doing an initial analysis could be reused without
modifications, but otherwise it's not like running a script that would
do all the work.  Anyway, this is getting too abstract, I'd like to
address specific problems. I'm fine with adding the configurable logging
options.
