Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933121AbcJGQQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 12:16:47 -0400
Date: Fri, 7 Oct 2016 18:16:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is is possible to submit binary image as fstest test case?
Message-ID: <20161007161645.GE11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
 <20161007091838.GG9806@dastard>
 <f5f273e4-6d78-9ccd-64bf-480be7f05fbc@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f5f273e4-6d78-9ccd-64bf-480be7f05fbc@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 05:26:27PM +0800, Qu Wenruo wrote:
> > Preferably not. We've managed to avoid pre-built images in xfstests
> > for 15 years, so there'd have to be a really good reason to start
> > doing this, especially as once we open that floodgate we'll end up
> > with everyone wanting to do this and it will blow out the size of
> > the repository in now time.
> 
> Makes sense.
> For btrfs-progs, which includes test images, it already takes about 77M, 
> even we have tried our best to reduce image size.

The number 77M is bogus. Clean checkout of the kernel.org repository is
15M in total, the .git directory is 5M and all the images are 7.3MB in
total. We're not close to any scary numbers yet. Should we need large
images, I'll create a separate repository for that.

> > If the issue is just timing or being unable to trigger an error
> > at the right time, this is what error injection frameworks or
> > debug-only sysfs hooks are for. The XFS kernel code has both,
> > xfstests use both, and they pretty much do away with the need for
> > custom binary filesystem images for such testing...
> 
> So again, btrfs is lacking infrastructure for debug.

Depends what exactly you need. IIRC Filipe once submitted a patch for
transaction failure injection but then realzied that he could achieve
the same using the flaky device. You can try to take a snapshot of the
block device after using the freeze syscall. More specific tasks would
need code support. You definetelly know about the btrfs-corrupt-block
utility so you can use it to creatively damage the filesystem structures.
