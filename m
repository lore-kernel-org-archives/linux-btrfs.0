From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix recursive auto-defrag
Date: Thu, 6 Oct 2011 11:53:34 -0400
Message-ID: <20111006155334.GC5716@shiny.elevennetworks.com>
References: <4E8D230A.4040801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8D230A.4040801@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2011 at 11:39:54AM +0800, Li Zefan wrote:
> Follow those steps:
> 
>   # mount -o autodefrag /dev/sda7 /mnt
>   # dd if=/dev/urandom of=/mnt/tmp bs=200K count=1
>   # sync
>   # dd if=/dev/urandom of=/mnt/tmp bs=8K count=1 conv=notrunc
> 
> and then it'll go into a loop: writeback -> defrag -> writeback ...
> 
> It's because writeback writes [8K, 200K] and then writes [0, 8K].
> 
> I tried to make writeback know if the pages are dirtied by defrag,
> but the patch was a bit intrusive. Here I simply set writeback_index
> when we defrag a file.

Really nice and small fix.  I'll definitely send this for 3.1

-chris
