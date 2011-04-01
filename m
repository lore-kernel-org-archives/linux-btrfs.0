From: arand <ienorand@gmail.com>
Subject: Re: Cannot set-default back to ID 0
Date: Fri, 1 Apr 2011 15:32:18 +0000 (UTC)
Message-ID: <loom.20110401T172201-433@post.gmane.org>
References: <ijrt29$onm$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Bernhard Schmidt <berni <at> birkenwald.de> writes:

> 
> Hi,
> 
> a recent Ubuntu upgrade killed my system. Luckily I had done a btrfs
> snapshot before, so I set the particular subvolume as default using
> 
> # btrfs subvolume set-default 261 /mnt
> 
> from a rescue system and was back up in no time. I then mounted the
> original volume with subvolid=0 and repaired it. So far so good.
> However, I fail to set the default volume back to the original.
> 
> # btrfs subvolume set-default 0 /
> 
> apparently does nothing, I don't get an error but I'm still on the
> snapshot after reboot. Currently I'm working around this adding
> rootflag=subvolid=0 on the kernel command line, but that is kind of
> inconvenient.
> 
> Is this expected?
> 
> Ubuntu natty amd64, Kernel 2.6.38-rc5, btrfs-tools 0.19+20100601 
> 
> Thanks
> Bernhard
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

I was asking a similar question in IRC, and the answer I got was:
"The "0" alias for the top-level subvol is implemented in the kernel, not the
userspace tools."

I was however able to do this using:
# btrfs subvolume set-default 5 /
Using 5 for "the _real_ subvolid"

Or alternatively:
# mount -o defaults,subvolid=0 /mnt
# btrfsctl -m /mnt/

It's a bit odd, agreed, and the people I spoke to seemed to agree as well =)

- arand

