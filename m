From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Date: Thu, 27 May 2010 08:59:52 -0400
Message-ID: <20100527125952.GQ3108@think>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
 <1274461422-18433-6-git-send-email-josef@redhat.com>
 <4BFDE1CE.4030100@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4BFDE1CE.4030100@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 27, 2010 at 11:06:54AM +0800, liubo wrote:
> On 05/22/2010 01:03 AM, Josef Bacik wrote:
> > In order for AIO to work, we need to implement aio_write.  This patch converts
> > our btrfs_file_write to btrfs_aio_write.  I've tested this with xfstests and
> > nothing broke, and the AIO stuff magically started working.  Thanks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> >   
> 
> Hi, Josef,
> 
> I've tested your patch(May 22) with my tools, and one case triggered a bug
> which made writev operation hang up, more information is followed.
> 
> - Steps to trigger it:
>   # mount /dev/sda8 /home/btrfsdisk -o nodatacow
>   # gcc direct-io.c -o direct-io
>   # ./direct-io O_DIRECT writev /home/btrfsdisk/testrw 4M

Thanks for sending along this test program and bug report.  We've fixed
a few bugs in the O_DIRECT patches, and this is working now.

The merged result is in the for-linus branch of the btrfs unstable tree.

-chris
