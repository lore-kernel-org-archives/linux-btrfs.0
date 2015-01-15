Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63560 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbAOSCk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 13:02:40 -0500
Received: by mail-pa0-f50.google.com with SMTP id bj1so18859010pad.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 10:02:39 -0800 (PST)
Date: Thu, 15 Jan 2015 10:02:37 -0800
From: Zach Brown <zab@zabbo.net>
To: dsterba@suse.cz, Sandy McArthur Jr <sandymac@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs scrub status reports not running when it is
Message-ID: <20150115180237.GA28510@lenny.home.zabbo.net>
References: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
 <20150114222717.GA9900@lenny.home.zabbo.net>
 <20150115112441.GA3685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150115112441.GA3685@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 15, 2015 at 12:24:41PM +0100, David Sterba wrote:
> On Wed, Jan 14, 2015 at 02:27:17PM -0800, Zach Brown wrote:
> > On Wed, Jan 14, 2015 at 04:06:02PM -0500, Sandy McArthur Jr wrote:
> > > Sometimes btrfs scrub status reports that is not running when it still is.
> > > 
> > > I think this a cosmetic bug. And I believe this is related to the
> > > scrub completing on some drives before others in a multi-drive btrfs
> > > filesystem that is not well balanced.
> > 
> > Boy, I don't really know this code, but it looks like:
> > 
> > if (ss->in_progress)
> > 	printf(", running for %llu seconds\n", ss->duration);
> > else
> > 	printf(", interrupted after %llu seconds, not running\n",
> > 			ss->duration);
> > 
> > in_progress = is_scrub_running_in_kernel(fdmnt, di_args, fi_args.num_devices);
> > 
> > static int is_scrub_running_in_kernel(int fd,
> >                 struct btrfs_ioctl_dev_info_args *di_args, u64 max_devices)
> > {
> >         struct scrub_progress sp;
> >         int i;
> >         int ret;
> > 
> >         for (i = 0; i < max_devices; i++) {
> >                 memset(&sp, 0, sizeof(sp));
> >                 sp.scrub_args.devid = di_args[i].devid;
> >                 ret = ioctl(fd, BTRFS_IOC_SCRUB_PROGRESS, &sp.scrub_args);
> >                 if (ret < 0 && errno == ENODEV)
> >                         continue;
> >                 if (ret < 0 && errno == ENOTCONN)
> >                         return 0;
> > 
> > It says that scrub isn't running if any devices have completed.  If you drop
> > all those ret < 0 conditional branches that are either noops or wrong, does it
> > work like you'd expect?
> 
> Why wrong? The ioctl callback returns -ENODEV or -ENOTCONN that get
> translated to the errno values and ioctl(...) returns -1 in both cases.

Wrong because returning 0 on the first ENOTCONN, instead of continuing
to find more devices which might still be scrubbing, leads to this
confusing status message.

That's my working theory having spent 15 seconds reading code.  I would
be not surprised at all if I'm missing something here.


- z
