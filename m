Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbcD0WzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 18:55:25 -0400
Date: Thu, 28 Apr 2016 00:55:10 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Roman Mamedov <rm@romanrm.net>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, luisbg@osg.samsung.com
Subject: Re: [bug] df returns 100% used for empty mixed block group filesystem
Message-ID: <20160427225510.GQ29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtRzt-BeoW9KNQC3kmBXw8MoydJv7Qy8fu0HmF3hAOgFRQ@mail.gmail.com>
 <20160310133334.1528bc88@natsu>
 <20160310174054.GL18908@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160310174054.GL18908@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 06:40:54PM +0100, David Sterba wrote:
> On Thu, Mar 10, 2016 at 01:33:34PM +0500, Roman Mamedov wrote:
> > On Thu, 10 Mar 2016 01:24:44 -0700
> > Chris Murphy <lists@colorremedies.com> wrote:
> > 
> > > kernel 4.5.0 rc7
> > > btrfs-progs-4.4.1-1
> > > 
> > > Summary: A new empty mixed block group "-M" filesystem shows up as
> > > 100% full with regular df (gnu coreutils 8.24). Pretty sure this is
> > > not a regression, but no regression testing done.
> > > 
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=114281
> > 
> > Just guessing here, but this might be related?
> > 
> >   [PATCH] btrfs: statfs: report zero available if metadata are exhausted
> >   http://www.spinics.net/lists/linux-btrfs/msg48013.html
> > 
> > Maybe some maths there are wrong in case of a mixed blockgroup filesystem.
> 
> Yes it's caused by the referenced patch.  The statfs has been broken for
> mixed blockgroups but the 100% used on empty filesystem looks weird, so
> it's time to fix the mixed-bg case.

JFYI, fixed by Luis de Bethencourt and patches queued for 4.7
