Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbcEQNOr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:14:47 -0400
Date: Tue, 17 May 2016 15:14:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v10 11/21] btrfs: dedupe: Add ioctl for inband
 dedupelication
Message-ID: <20160517131420.GO511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-12-git-send-email-quwenruo@cn.fujitsu.com>
 <8321f238-764e-d833-969f-e3d09723371a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8321f238-764e-d833-969f-e3d09723371a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 09:29:29AM +0800, Qu Wenruo wrote:
> > @@ -5542,6 +5606,10 @@ long btrfs_ioctl(struct file *file, unsigned int
> >  		return btrfs_ioctl_get_fslabel(file, argp);
> >  	case BTRFS_IOC_SET_FSLABEL:
> >  		return btrfs_ioctl_set_fslabel(file, argp);
> 
> Would you mind me to add a new kernel config "Btrfs experimental 
> features-> dedupe ioctl" for case like dedupe and further experimental 
> btrfs features?
> 
> The BTRFS_DEBUG seems quite odd for me.
> Although in-band dedupe is quite good at exposing bugs of 
> backref/qgroup/delayed_refs, but I still think it's not a debug tool.
> 
> So I hope to use "BTRFS_EXPERIMENTAL_DEDUPE_IOCTL" and add corresponding 
> Kconfig interfaces.

The point was not to add new config options, but if you find _DEBUG odd
we can rethink the "hide it under config option" approach. The alternate
way is to get the code into a good shape and add it to for-next. I don't
want to track yet another set of branches with the too experimental
stuff.
