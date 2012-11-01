Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52700 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2KASNt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 14:13:49 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1422148eek.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 11:13:47 -0700 (PDT)
Date: Thu, 1 Nov 2012 19:13:45 +0100
From: Tobias Franke <ttfranke@googlemail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
Message-ID: <20121101191345.3a3adf26@googlemail.com>
In-Reply-To: <5092638C.2070505@jan-o-sch.net>
References: <20121031005736.306fd86b@googlemail.com>
 <50907514.3060400@oracle.com>
 <20121031210032.303c1c36@googlemail.com>
 <5091E0E4.5080804@oracle.com>
 <5092638C.2070505@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been trying to get some sysrq output, but I am only getting hard
hangs right now. So no reaction to sysrq-w.

Here is some sysrq-w output from around 15 minutes before the crash:
https://www.dropbox.com/s/386ifyoxh8eppia/sysrqw_2012-11-1.log
I don't know if this will be helpful.

Tobias

On Thu, 01 Nov 2012 12:57:00 +0100
Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:

> On Thu, November 01, 2012 at 03:39 (+0100), Liu Bo wrote:
> > On 11/01/2012 04:00 AM, Franke wrote:
> >> Hi,
> >>
> >> since yesterday I have run a balance while asleep/at work. Now I
> >> experimented a bit, and the situation has changed.
> >>
> >> I am now getting hard hangs ( system is gone without even writing
> >> anything to syslog ), some time ( minutes to an hour ) into
> >> running a scrub.
> >>
> >> Those hangs happen with 3.6.2 , 3.6.4 and Jan's unstable version.
> >> It hasn't hung yet without running a scrub.
> >>
> >> I have no idea if this is part of the same problem or something
> >> else. Do you have any idea either way?
> >>
> > 
> > Well, thanks for testing.
> > 
> > We may need your sysrq-w output(maybe screen output) to locate
> > where we hard hangs.
> > 
> > Besides, I recommend you pick Jan's patches out, and apply them on
> > the latest btrfs upstream and run another round to see if it get
> > better, since there might be some fixes for the very hang already
> > in the upstream.
> > 
> > Right now the latest btrfs upstream's top commit is
> > 
> > commit f46dbe3dee853f8a860f889cb2b7ff4c624f2a7a
> > Author: Chris Mason <chris.mason@fusionio.com>
> > Date:   Tue Oct 9 11:17:20 2012 -0400
> > 
> >     btrfs: init ref_index to zero in add_inode_ref
> >     
> >     Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> 
> This is an old top commit. The current cmason/master state is
> 
> commit c37b2b6269ee4637fb7cdb5da0d1e47215d57ce2
> Author: Josef Bacik <jbacik@fusionio.com>
> Date:   Mon Oct 22 15:51:44 2012 -0400
> 
> and includes my recent fixes. I don't really expect them to prevent
> getting stuck anywhere. sysrq+w output would be really helpful. I'm
> trying to reproduce the problems in the meantime.
> 
> -Jan
