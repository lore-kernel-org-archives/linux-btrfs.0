Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38877 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaJJLCp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 07:02:45 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so1547691pab.2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 04:02:45 -0700 (PDT)
Date: Fri, 10 Oct 2014 19:02:40 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: don't report internal dev replace
 result if ioctl failed
Message-ID: <20141010110240.GH13950@dhcp-13-216.nay.redhat.com>
References: <1412761349-32721-1-git-send-email-guaneryu@gmail.com>
 <20141010082023.GF22943@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141010082023.GF22943@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 10, 2014 at 10:20:23AM +0200, David Sterba wrote:
> On Wed, Oct 08, 2014 at 05:42:28PM +0800, Eryu Guan wrote:
> > If BTRFS_IOC_DEV_REPLACE ioctl failed, there's no result returned to
> > fill args.result, it doesn't make sense to report this internal result
> > to user.
> > 
> > And the arg has been initialized with 0, the result is always 0, which
> > is BTRFS_IOCTL_DEV_REPLACE_REPLACE_NO_ERROR, and the resulting error
> > message looks confusing too:
> > 
> > ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/btrfs": No such file or directory, no error
> > 
> > So just skip the internal dev replace result if the whole ioctl failed.
> 
> The 'no error' is confusing there, but I'm afraid we're losing some
> information if the secondary result is completely dropped. How about
> intializing the replace result with, eg., -1 and then print an empty
> string from replace_dev_result2string instead?

I assume the secondary result won't be filled at all if the ioctl
itself failed due to some reason(indicated by errno). But yes, it's
relatively safer to check the replace result instead of dropping it
completely.

I'll send v2 out.

Thanks for your reivew!

Eryu
