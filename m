From: Josef Bacik <josef@redhat.com>
Subject: Re: [BUG] btrfs: report a direct-IO bug
Date: Wed, 5 May 2010 21:56:42 -0400
Message-ID: <20100506015641.GA5672@localhost.localdomain>
References: <4BE21FC1.1010901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jim owens <owens6336@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	"Yan, Zheng" <zheng.yan@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BE21FC1.1010901@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 06, 2010 at 09:47:45AM +0800, liubo wrote:
> When we tested the series of jim owens' direct-IO patch, a bug occured.
> 
> It could be reproduced on a 2.6.34-rc6 kernel with
> direct-IO patch by the following steps...
> 
> # mkfs.btrfs /dev/sdb
> # mount /dev/sdb /home/btrfsdisk
> # cd /home/btrfsdisk
> # create test.c
> # dd if=/dev/zero of=file bs=7K count=1
> # gcc test.c -o test
> # ./test
> 

I'm in the middle of re-working the DIO code.  You can pull from my git tree

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-unstable-josef.git;a=summary

Pull from the my-dio branch.  It survives fsx, but it fails on 5 out of 7 AIO
tests in xfstests, which I'm tracking down.  Thanks,

Josef
