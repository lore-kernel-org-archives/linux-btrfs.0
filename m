From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 0/6] random bugfixes of the space management
Date: Wed, 22 Dec 2010 14:22:54 -0500
Message-ID: <20101222192254.GB1669@dhcp231-156.rdu.redhat.com>
References: <4D11D72C.7010704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D11D72C.7010704@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 22, 2010 at 06:47:08PM +0800, Miao Xie wrote:
> Hello,
> 
> I have a bunch of random fixes of the space management in
> 
> git://repo.or.cz/linux-btrfs-devel.git space-manage
> 
> They are the ENOSPC fixes, as well as fixes for df command.
> The first one and the last one fixed the wrong free space information reported
> by df command. The second one fixed ENOSPC when there is tiny space in the
> filesystem. And The third fixed wrong calculation of stripe size. And the 4th
> and 5th patches fixed the chunk allocation problem when the block devices have
> no enough space to allocate a default-size chunk.
>

I'll review the rest of them when I have more time, thanks for these Miao.

Josef 
