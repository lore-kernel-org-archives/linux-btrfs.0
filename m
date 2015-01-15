Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbbAOLYn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 06:24:43 -0500
Date: Thu, 15 Jan 2015 12:24:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: Sandy McArthur Jr <sandymac@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs scrub status reports not running when it is
Message-ID: <20150115112441.GA3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
 <20150114222717.GA9900@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150114222717.GA9900@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 02:27:17PM -0800, Zach Brown wrote:
> On Wed, Jan 14, 2015 at 04:06:02PM -0500, Sandy McArthur Jr wrote:
> > Sometimes btrfs scrub status reports that is not running when it still is.
> > 
> > I think this a cosmetic bug. And I believe this is related to the
> > scrub completing on some drives before others in a multi-drive btrfs
> > filesystem that is not well balanced.
> 
> Boy, I don't really know this code, but it looks like:
> 
> if (ss->in_progress)
> 	printf(", running for %llu seconds\n", ss->duration);
> else
> 	printf(", interrupted after %llu seconds, not running\n",
> 			ss->duration);
> 
> in_progress = is_scrub_running_in_kernel(fdmnt, di_args, fi_args.num_devices);
> 
> static int is_scrub_running_in_kernel(int fd,
>                 struct btrfs_ioctl_dev_info_args *di_args, u64 max_devices)
> {
>         struct scrub_progress sp;
>         int i;
>         int ret;
> 
>         for (i = 0; i < max_devices; i++) {
>                 memset(&sp, 0, sizeof(sp));
>                 sp.scrub_args.devid = di_args[i].devid;
>                 ret = ioctl(fd, BTRFS_IOC_SCRUB_PROGRESS, &sp.scrub_args);
>                 if (ret < 0 && errno == ENODEV)
>                         continue;
>                 if (ret < 0 && errno == ENOTCONN)
>                         return 0;
> 
> It says that scrub isn't running if any devices have completed.  If you drop
> all those ret < 0 conditional branches that are either noops or wrong, does it
> work like you'd expect?

Why wrong? The ioctl callback returns -ENODEV or -ENOTCONN that get
translated to the errno values and ioctl(...) returns -1 in both cases.
