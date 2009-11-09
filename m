From: John Dong <jdong@ubuntu.com>
Subject: Re: rootfs snapshots and rollback (i.e. testing updates)
Date: Mon, 9 Nov 2009 11:24:31 -0500
Message-ID: <D567FA1E-67BA-495D-A311-426468FF07EB@ubuntu.com>
References: <4AF82E78.1010200@wpkg.org>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AF82E78.1010200@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I asked this question about a month ago, and the answer is roughly  
"It's theoretically possible with minor feature implementations to  
btrfs, though nobody's done it yet"
On Nov 9, 2009, at 10:00 AM, Tomasz Chmielewski wrote:

> Is it possible, with current btrfs:
>
> - to take a rootfs snapshot (i.e. prior to a major update),
>
> - do changes in the root filesystem (i.e. install major update),
>
> - if we don't like what the major update did to the system (rootfs),  
> "rollback" the snapshot and make it the "original" rootfs again  
> (perhaps, with a reboot in between).
>
>
>
> If it's possible, what would be the steps/commands?
>
>
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

