Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753574AbcJNPtp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 11:49:45 -0400
Date: Fri, 14 Oct 2016 17:49:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Abhay Sachan <lkp.abhay@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs build fails for 4.8
Message-ID: <20161014154942.GB11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
 <20161012172657.GV11398@twin.jikos.cz>
 <eabfbf45-6cca-043d-b60b-34bede02dfc7@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eabfbf45-6cca-043d-b60b-34bede02dfc7@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 03:25:57PM +0800, Qu Wenruo wrote:
> At 10/13/2016 01:26 AM, David Sterba wrote:
> > On Wed, Oct 12, 2016 at 10:01:27PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 10/12/2016 09:58 PM, Abhay Sachan wrote:
> >>> Hi,
> >>> I tried building latest btrfs progs on CentOS 6, "./configure" failed
> >>> with the error:
> >>>
> >>> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
> >>> configure: error: no definition of FIEMAP_EXTENT_SHARED found
> >>>
> >>> Any ideas what am I lacking in the system?
> >>
> >> Your kernel is too old and its header doesn't support
> >> FIEMAP_EXTENT_SHARED flag for fiemap ioctl.
> >
> > As this is not the first time, I wonder if we could provide a defintion
> > of the macro in progs, regardless of the installed headers. Note that
> > this does not mean the running kernel is old. Previously the user said
> > he was running a 4.4 kernel [1] (or it could be any other kernel
> > version). For that combination of headers and running kernel, I think
> > it's ok to add a fallback definition.
> 
> Yes, fallback definition is good for case like running kernel supports 
> SHARED_EXTENT flag, but not kernel header.
> 
> But I'm a little concerned about such fallback definition will lead to 
> corrupted result for "fi du".

Well, not corrupted bug wrong. The shared data will be reported as
exclusive.

> >> And since that flag is very important for tools like "btrfs filesystem
> >> du", for old kernel doesn't support EXTENT_SHARED flag, we have no
> >> choice but abort configuration.
> >
> > The check was added to configure so it's caught earlier than during
> > build. The 'fi du' command is useful, but not IMO critical to stop the
> > build.
> 
> What about just disabling subcommands using SHARED_EXTENT flag?
> Like "fi du".

This would need to be checked at runtime, based only on kernel version.
I think we can do that, print a warning in 'fi du' but otherwise let it
continue.
