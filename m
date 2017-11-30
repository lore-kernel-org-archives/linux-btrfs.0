Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdK3ScO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:32:14 -0500
Date: Thu, 30 Nov 2017 19:30:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs-progs: fi defrag: extend -c to drop
 nocompress flag on files
Message-ID: <20171130183016.GR3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171128091450.21789-3-suy.fnst@cn.fujitsu.com>
 <20171128160659.GV3553@twin.jikos.cz>
 <42224432-6a27-ea55-f6ee-660adb48e7f0@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <42224432-6a27-ea55-f6ee-660adb48e7f0@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 09:54:01AM +0800, Su Yue wrote:
> On 11/29/2017 12:07 AM, David Sterba wrote:
> > On Tue, Nov 28, 2017 at 05:14:50PM +0800, Su Yue wrote:
> >> Now, files which have nocompress flag also will be defraged
> >> with compression. However, nocompress flag is still existed
> >> and have to be cleared manually.
> >>
> >> So add an option '--clear-nocompress' to extend -c to drop
> >> nocompress flag after defragement.
> > 
> >> Suggested-by: David Sterba <dsterba@suse.com>
> >> Suggested-by: Anand Jain <anand.jain@oracle.com>
> > 
> > Do you have the pointer to the discussion? The whole idea sounds
> > familiar and seeing my name here means I must have been involved, but I
> > have only vague memories.
> > 
> 
> Here is the link:
> https://www.spinics.net/lists/linux-btrfs/msg67529.html

Thanks.

> >> +static int clear_nocompress_flag(int fd)
> >> +{
> >> +	unsigned int flags;
> >> +	int ret = 0;
> >> +
> >> +	ret = ioctl(fd, FS_IOC_GETFLAGS, &flags);
> >> +	if (ret < 0) {
> >> +		ret = -errno;
> >> +		error("failed to get flags: %s", strerror(-ret));
> >> +		goto out;
> >> +	}
> >> +
> >> +	if (!(flags & FS_NOCOMP_FL)) {
> >> +		ret = 0;
> >> +		goto out;
> >> +	}
> >> +	flags &= ~FS_NOCOMP_FL;
> >> +	ret = ioctl(fd, FS_IOC_SETFLAGS, &flags);
> > 
> > This is inherently racy, but the inode flags do not change that often so
> > concurrent change is unlikely.
> > 
> 
> I don't quite understand what you mean.
> Could you explain some details?

If the inode flags change externally between the set and get calls, but
there's not much we can do about it now.
