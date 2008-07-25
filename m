From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] async-thread: fix possible memory leak
Date: Fri, 25 Jul 2008 12:45:42 +0000
Message-ID: <1216989942.7572.21.camel@think.oraclecorp.com>
References: <488965CB.1000308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <488965CB.1000308@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-25 at 13:34 +0800, Li Zefan wrote:
> When kthread_run() returns failure, this worker hasn't been
> added to the list, so btrfs_stop_workers() won't free it.
> 

Thanks, I've queued this one up for inclusion.

-chris


