From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Date: Mon, 28 Nov 2011 12:24:16 +0000
Message-ID: <20111128122416.GA25996@localhost>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
 <20111128121041.GA19498@elie.hsd1.il.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Ivan Vilata i Balaguer <ivan@selidor.net>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128121041.GA19498@elie.hsd1.il.comcast.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2011 at 06:11:06AM -0600, Jonathan Nieder wrote:
> Hi,
> 
> Andy Whitcroft wrote:
> 
> > When we mount a btrfs filesystem from read-only media there will be no
> > read/write devices; for example mounting an SD card with its lock enabled.
> > This triggers an immediate BUG during mount:
> >
> >   kernel BUG at .../fs/btrfs/super.c:984!
> [...]
> > BugLink: http://bugs.launchpad.net/bugs/816770
> > Signed-off-by: Andy Whitcroft <apw@canonical.com>
> > ---
> 
> Fixes http://bugs.debian.org/649847
> Tested-by: Ivan Vilata i Balaguer <ivan@selidor.net>
> 
> This patch fixes a regression introduced by 6d07bcec969a ("btrfs: fix
> wrong free space information of btrfs"), which hit mainline in
> v2.6.38-rc1.  Josef Bacik acked the patch, but I can't seem to find it
> in linux-next, linux-btrfs, or Josef's btrfs-work tree.  Maybe it was
> just forgotten.
> 
> What can I do to help this patch get unstuck?

I had completely forgotten about this one.  I wonder where it did get
to.  I seem to remember testing this in house successfully.

-apw
