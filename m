Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39264 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3BRRgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 12:36:47 -0500
Message-ID: <512266F5.7000109@die-jansens.de>
Date: Mon, 18 Feb 2013 18:37:57 +0100
From: Arne Jansen <lists@die-jansens.de>
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel panic when scrub is used
References: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
In-Reply-To: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/18/13 18:14, Jérôme Poulin wrote:
> I experience a kernel panic with "General protection fault" when doing
> a scrub on Kernel 3.8-rc7.
> 
> Here is a screenshot: http://tinypic.com/r/34r6nad/6

I'd love to see the first stacktrace...

> 
> The weird part is that the scrub completes from initramfs, but when
> system is fully booted, is kernel panics every time in the low
> percentage. (<10%)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

