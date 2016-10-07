Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43335 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751959AbcJGQFx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 12:05:53 -0400
Date: Fri, 7 Oct 2016 18:05:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is is possible to submit binary image as fstest test case?
Message-ID: <20161007160551.GD11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
 <20161007091838.GG9806@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161007091838.GG9806@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 08:18:38PM +1100, Dave Chinner wrote:
> On Thu, Oct 06, 2016 at 04:12:56PM +0800, Qu Wenruo wrote:
> > Hi,
> > 
> > Just as the title says, for some case(OK, btrfs again) we need to
> > catch a file system in special timing.
> > 
> > In this specific case, we need to grab a btrfs image undergoing
> > balancing, just before the balance finished.
> > 
> > Although we can use flakey to drop all write, we still don't have
> > method to catch the timing of the that transaction.
> > 
> > 
> > On the other hand, we can tweak our local kernel, adding
> > msleep()/message and dump the disk during the sleep.
> > And the image I dumped can easily trigger btrfs kernel and user-space bug.
> > 
> > So I'm wondering if I can just upload a zipped raw image as part of
> > the test case?
> 
> Preferably not. We've managed to avoid pre-built images in xfstests
> for 15 years, so there'd have to be a really good reason to start
> doing this, especially as once we open that floodgate we'll end up
> with everyone wanting to do this and it will blow out the size of
> the repository in now time.
> 
> If the issue is just timing or being unable to trigger an error
> at the right time, this is what error injection frameworks or
> debug-only sysfs hooks are for. The XFS kernel code has both,
> xfstests use both, and they pretty much do away with the need for
> custom binary filesystem images for such testing...

Error injection framework may not be alwasy available, eg. in kernels
built for production. Yet I'd like to make the test possible.

Also, I find it useful to keep the exact images that are attached to a
report and not necessarily try to recreate it to trigger a bug. If the
images are small, hosting them with the sources makes testing easy.
Big images would probably go to own repository and be linked.

I don't really expect fstests to store crafted images and would advise
Qu to not even try to propose that, because the answer was quite
predictable.
