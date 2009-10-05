From: Chris Mason <chris.mason@oracle.com>
Subject: Re: system hang with btrfs master
Date: Mon, 5 Oct 2009 09:13:00 -0400
Message-ID: <20091005131300.GA25969@think>
References: <200910051440.50155.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910051440.50155.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2009 at 02:40:49PM +0200, Johannes Hirte wrote:
> I'm using btrfs on two devices here, /usr on sda3 and /home on sdb (dm-crypt 
> device on the whole disk). With btrfs-master the whole system hangs when 
> accessing /home. The system hangs when I'm logging in into my account with KDE 
> and is easily reproducible with dbench. On /usr the hangs appeared also but 
> not as often as on the /home-device. I've tested on a third device with new 
> created btrfs on top of dm-crypt, but wasn't able to reproduce the hangs. The 
> filesystems are created without metadata-mirroring (-m single). I've bisected 
> this to:
> 
> commit 11833d66be94b514652466802100378046c16b72
> Author: Yan Zheng <zheng.yan@oracle.com>
> Date:   Fri Sep 11 16:11:19 2009 -0400
> 
>     Btrfs: improve async block group caching

Hello,

Could you please capture the output of sysrq-l and sysrq-t during the
hang?

-chris

