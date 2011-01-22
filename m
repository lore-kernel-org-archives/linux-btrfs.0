From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: [PATCH] Add -v option to btrfsctl to control verbosity: Be quiet
 unless requested.
Date: Sat, 22 Jan 2011 13:46:39 +0100
Message-ID: <20110122124639.GB2564@scooter>
References: <4D3AC69A.2080302@gmx.de>
 <20110122121124.GA2564@scooter>
 <4D3ACD0B.6050800@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3ACD0B.6050800@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there is a patch that marks it deprecated:

http://www.spinics.net/lists/linux-btrfs/msg06625.html

But it's not in git yet :/ Last commit is from oct. 2010, hopefully all new patches
will be pulled soon.


Regards,
Felix


On 22. January 2011 - 13:26, Maximilian Mehnert wrote:
> Date:	Sat, 22 Jan 2011 13:26:51 +0100
> From: Maximilian Mehnert <maximilian.mehnert@gmx.de>
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: Re: [PATCH] Add -v option to btrfsctl to control verbosity: Be
>  quiet unless requested.
> 
> On 22/01/11 13:11, Felix Blanke wrote:
> > Hi,
> >
> > btrfsctl is deprecated, why you're adding new options to it? :)
> 
> 
> Well, I did not know that it's deprecated ;-)
> Neither the manpage nor the program itself said so and the messages 
> annoyed logcheck...
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
