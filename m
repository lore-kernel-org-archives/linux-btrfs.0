From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Set/change label
Date: Tue, 24 Aug 2010 18:39:38 +0200
Message-ID: <201008241839.38446.kreijack@libero.it>
References: <20100824091841.GC24929@scooter>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100824091841.GC24929@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 24 August, 2010, Felix Blanke wrote:
> Hi,
> 
> is there any way to set/change the label after the filesystem has been 
created?

There was a patch to do that. But AFAICT this patch was never merged.
If you are interested look at

[Repost] btrfslabel - kernel space

https://kerneltrap.org/mailarchive/linux-btrfs/2010/1/4/6683133/thread

IIRC the user space utility, in case of a *unmounted* filesystem, is able to 
change a LABEL without patching the kernel.

Goffredo

> 
> 
> Best regards,
> Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
