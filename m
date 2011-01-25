From: Josef Bacik <josef@redhat.com>
Subject: Re: flush-btrfs-1 hangs when building openwrt
Date: Tue, 25 Jan 2011 10:30:56 -0500
Message-ID: <20110125153055.GA2598@localhost.localdomain>
References: <4D3E8EF5.1050008@poelzi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Daniel Poelzleithner <poelzi@poelzi.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3E8EF5.1050008@poelzi.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 25, 2011 at 09:51:01AM +0100, Daniel Poelzleithner wrote:
> Hi,
> 
> Since update to 2.6.37 I can't build openwrt on my btrfs buildroot anymore.
> I'm not sure if this is related to the other flush-btrfs-1 thread.
> 
> plenty of diskspace is free:
> 
> /dev/mapper/cruor-build
>                        97G   68G   27G  73% /opt/build
> 
> It always hangs when openwrt builds the ext4 image and runs tune2fs on it.
> 
> /opt/build/fahrenheit/openwrt/staging_dir/host/bin/tune2fs -O
> extents,uninit_bg,dir_index
> /opt/build/fahrenheit/openwrt/build_dir/linux-x86_kvm_guest/root.ext4
> tune2fs 1.41.13 (13-Dec-2010)
> 
> the processes can't be killed.
> 
> alt-sysctl-t does not show anything, nor is there a oops.
> 
> I put the the openwrt config I'm using at https://gist.github.com/794593
> , maybe it is reproduceable.
> 
> Linux cruor 2.6.37 #2 SMP Thu Jan 20 02:09:59 CET 2011 x86_64 GNU/Linux
> 

How about sysrq+w when it's hanging.  Also could you give the exact steps to
reproduce?  I went to the openwrt site to try and build, but it seems like
theres alot of moving parts.  If you can just tell me what to download and what
you run to reproduce I can try and reproduce locally.  Thanks,

Josef
