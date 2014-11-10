Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52385 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751803AbaKJHyi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Nov 2014 02:54:38 -0500
Message-ID: <1415605990.21952.12.camel@localhost.localdomain>
Subject: Re: [PATCH 2/2] btrfs-progs: fix wrong num_devices for btrfs fi
 show with seed devices
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
CC: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Mon, 10 Nov 2014 15:53:10 +0800
In-Reply-To: <CAMU1PDjN0Q4Q=0kzrgjAKCmMdtMGBg-iMTONqQY3m0LuKDzJaA@mail.gmail.com>
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1415326063-8838-3-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20141107181628.GE25615@twin.jikos.cz>
	 <CAMU1PDjN0Q4Q=0kzrgjAKCmMdtMGBg-iMTONqQY3m0LuKDzJaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2014-11-08 at 19:47 +0000, Mike Fleetwood wrote:
> On 7 November 2014 18:16, David Sterba <dsterba@suse.cz> wrote:
> > On Fri, Nov 07, 2014 at 10:07:43AM +0800, Gui Hecheng wrote:
> >> The @fi_args->num_devices in @get_fs_info() does not include seed devices.
> >> We could just correct it by searching the chunk tree and count how
> >> many dev_items there are in total which includes seed devices.
> >>
> >> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> >> ---
> >> *Note*
> >> This is just a temporary workaround to fix this problem in order to
> >> make users happy, because a new ioctl or sysfs interface to handle this
> >> problem needs more discussions and efforts. After the work implemented
> >> and accepted, we could drop this.
> >
> > Nice, thanks. I agree that this kind of workaround is best possible for
> > the moment, and I'm glad to see that it's not that much code to get the
> > seeding devices right. This would also work with older kernels without
> > the updated sysfs/ioctl interfaces, so this is likely to stay for a long
> > time.
> >
> >> +u64 find_max_id(struct btrfs_ioctl_search_args *search_args, int nr_items)
> >
> > That's a very generic name for a function that does a very specialized
> > thing, but I don't have a suggestion right now.
> 
> Is find_max_device_id a suitable name?

I think this one is really more clear.

> >> +int correct_fs_info(int fd, struct btrfs_ioctl_fs_info_args *fi_args)
> >
> > Same here, make fs_info correct but in what way? A comment would be good
> > as well.
> 
> Sorry, no suggestion for this function name.

may be @search_chunk_tree_for_fs_info?

Thanks for the suggestions.

-Gui

> Thanks,
> Mike


