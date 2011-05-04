From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs csum failed
Date: Tue, 3 May 2011 20:28:15 -0400
Message-ID: <20110504002815.GA27861@dhcp231-156.rdu.redhat.com>
References: <4DC07A10.7070200@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC07A10.7070200@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 03, 2011 at 11:56:32PM +0200, Martin Schitter wrote:
> since my last debian kernel-update to 2.6.38-2-amd64 i got troubles with  
> csum failures. it's a volume full of huge kvm-images on md-RAID1 and  
> LVM, so i used the mount options: 'noatime,nodatasum' to maximize the  
> performance.
>
> it happened two weeks ago for the fist time. and now again a kvm-image  
> isn't readable again. i have to use an older snapshot to substitute the  
> virtual machine.
>
> this are the entries in dmesg/kernel-log on any access:
> ...
>  [2412668.409442] btrfs csum failed ino 258 off 2331529216 csum  
> 3632892464 private 2115348581
> ...
>
> it's a production machine, so i can not make to much experiments on it.
> do you see an obvious way to solve this problem?
>

Wait why are you running with btrfs in production?  What OS is in this vm image?
Thanks,

Josef
