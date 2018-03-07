Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933386AbeCGQin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:38:43 -0500
Date: Wed, 7 Mar 2018 17:36:22 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: Add unprivileged subvolume search ioctl
Message-ID: <20180307163622.GL23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
 <62ce1ddf-a7cd-f770-b4c8-5d47b8d4d31d@jp.fujitsu.com>
 <4de7f3e0-49c3-4fb8-8e66-b7829bf7dc5d@libero.it>
 <e72916b4-9261-b9d9-ab25-e3d38e46fe3b@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e72916b4-9261-b9d9-ab25-e3d38e46fe3b@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 07, 2018 at 09:40:18AM +0900, Misono, Tomohiro wrote:
> On 2018/03/07 5:29, Goffredo Baroncelli wrote:
> > On 03/06/2018 09:30 AM, Misono, Tomohiro wrote:
> >> Add new unprivileged ioctl (BTRFS_IOC_GET_SUBVOL_INFO) which searches
> >> and returns only subvolume related item (ROOT_ITEM/ROOT_BACKREF/ROOT_REF)
> >> from root tree. The arguments of this ioctl are the same as treesearch
> >> ioctl and can be used like treesearch ioctl.
> > 
> > Is it a pro ? The treesearch ioctl is tightly coupled to the btrfs internal structure, this means that if we would change the btrfs internal structure, we have to update all the clients of this api. For the treesearch it is an acceptable compromise between flexibility and speed of developing. But for a more specialized API, I think that it would make sense to provide a less coupled api to the internal structure.
> 
> Thanks for the comments.
> 
> The reason I choose the same api is just to minimize the code change in btrfs-progs.

That's not IMO a good reason. We can cahnge the code in btrfs-progs and
that's not going to be the only user of the ioctl so the interfact (ie.
the structures) should be adapted for the needs of the ioctl.
