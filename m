Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752730AbcJNRIj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 13:08:39 -0400
Date: Fri, 14 Oct 2016 19:08:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Abhay Sachan <lkp.abhay@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs build fails for 4.8
Message-ID: <20161014170837.GD11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
 <20161012172657.GV11398@twin.jikos.cz>
 <eabfbf45-6cca-043d-b60b-34bede02dfc7@cn.fujitsu.com>
 <20161014154942.GB11398@twin.jikos.cz>
 <3caf7539-5eae-d085-1fc6-b48ce0ae99a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3caf7539-5eae-d085-1fc6-b48ce0ae99a2@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 14, 2016 at 12:00:56PM -0500, Eric Sandeen wrote:
> On 10/14/16 10:49 AM, David Sterba wrote:
> > On Thu, Oct 13, 2016 at 03:25:57PM +0800, Qu Wenruo wrote:
> >> At 10/13/2016 01:26 AM, David Sterba wrote:
> >>> On Wed, Oct 12, 2016 at 10:01:27PM +0800, Qu Wenruo wrote:
> >>>>
> >>>>
> >>>> On 10/12/2016 09:58 PM, Abhay Sachan wrote:
> >>>>> Hi,
> >>>>> I tried building latest btrfs progs on CentOS 6, "./configure" failed
> >>>>> with the error:
> >>>>>
> >>>>> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
> >>>>> configure: error: no definition of FIEMAP_EXTENT_SHARED found
> >>>>>
> >>>>> Any ideas what am I lacking in the system?
> >>>>
> >>>> Your kernel is too old and its header doesn't support
> >>>> FIEMAP_EXTENT_SHARED flag for fiemap ioctl.
> >>>
> >>> As this is not the first time, I wonder if we could provide a defintion
> >>> of the macro in progs, regardless of the installed headers. Note that
> >>> this does not mean the running kernel is old. Previously the user said
> >>> he was running a 4.4 kernel [1] (or it could be any other kernel
> >>> version). For that combination of headers and running kernel, I think
> >>> it's ok to add a fallback definition.
> >>
> >> Yes, fallback definition is good for case like running kernel supports 
> >> SHARED_EXTENT flag, but not kernel header.
> >>
> >> But I'm a little concerned about such fallback definition will lead to 
> >> corrupted result for "fi du".
> > 
> > Well, not corrupted bug wrong. The shared data will be reported as
> > exclusive.
> > 
> >>>> And since that flag is very important for tools like "btrfs filesystem
> >>>> du", for old kernel doesn't support EXTENT_SHARED flag, we have no
> >>>> choice but abort configuration.
> >>>
> >>> The check was added to configure so it's caught earlier than during
> >>> build. The 'fi du' command is useful, but not IMO critical to stop the
> >>> build.
> >>
> >> What about just disabling subcommands using SHARED_EXTENT flag?
> >> Like "fi du".
> > 
> > This would need to be checked at runtime, based only on kernel version.
> > I think we can do that, print a warning in 'fi du' but otherwise let it
> > continue.
> 
> Checking kernel version is pretty unreliable - distro kernels that backport
> will quite possibly fail the version test.  Sure, it's possible to patch
> the check back out of userspace in the distro, but one must first know that
> such things exist, and look out for them...
> 
> Maybe warn on kernel version < 2.6.33 /and/ no shared extents found.

Yeah version is not reliable, 'fi du' will just warn. As the warning is
printed at the beginning, we don't know if there will be any shared
extent.

> Or, why not just:
> 
> 1) #ifndef FIEMAP_EXTENT_SHARED / #define FIEMAP_EXTENT_SHARED 0x00002000 / #endif
> 2) carry on as usual.
> 
> Worst case is that you don't get shared accounting on very old kernels.

Yes, implemented it that way.

> And FIEMAP_EXTENT_SHARED has been around since 2.6.33 so it's not going
> to bite too many people, right?

Right, I want to avoid another report that the build failed on centos 6.
