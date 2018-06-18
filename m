Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35057 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934393AbeFRMEv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 08:04:51 -0400
Date: Mon, 18 Jun 2018 14:02:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: About more loose parameter sequence requirement
Message-ID: <20180618120200.GK24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 07:40:44PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年06月18日 19:34, David Sterba wrote:
> > On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
> >> I understand that btrfs-progs introduced restrict parameter/option order
> >> to distinguish global and sub-command parameter/option.
> >>
> >> However it's really annoying if one just want to append some new options
> >> to previous command:
> >>
> >> E.g.
> >> # btrfs check /dev/data/btrfs
> >> # !! --check-data-csum
> >>
> >> The last command will fail as current btrfs-progs doesn't allow any
> >> option after parameter.
> >>
> >>
> >> Despite the requirement to distinguish global and subcommand
> >> option/parameter, is there any other requirement for such restrict
> >> option-first-parameter-last policy?
> > 
> > I'd say that it's a common and recommended pattern. Getopt is able to
> > reorder the parameters so mixed options and non-options are accepted,
> > unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
> > strict requirement, 'btrfs' option parser works the same regardless of
> > that.
> 
> But currently it doesn't work.
> Just as the example, btrfs check /dev/data/btrfs --check-data-sum won't
> work.
> It's different from a lot of other common programs.

With POSIXLY_CORRECT set, it expectedly won't work. With POSIXLY_CORRECT
unset, it would work in general, but not for 'btrfs'.

As this is per-application decision I find it ok, besides that I also
find the 'options anywhere' pattern bad. Does it really save you that
much time while typing the commands with new arguments? There are
movement shortcuts to jump by words, you get the previous command by
up-arrow. About the same number of keystrokes.

New code needs to be tested, documented and maintained, that's the cost
I find too high for something that's convenience for people who are used
to some shell builtins.
