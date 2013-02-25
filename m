Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:54598
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3BYRix (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 12:38:53 -0500
Message-ID: <512BA1AA.4000309@orcaware.com>
Date: Mon, 25 Feb 2013 09:38:50 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix overhead check for qgroupid in the kernel
References: <1361802632-2491-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1361802632-2491-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2013 06:30 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>
> As we implement the strict hierarchy quota in the userspace,
> it is sufficient to check this ruler in the userspace.remove
> the special check for qgroup 0.

I haven't done any kernel coding so I'm curious, but is this a safe 
change?  When I code, I always have the authoritative code do a check, 
e.g. in web programing, the browser can do data validation but you 
always have the web server check incoming data also, so it doesn't hurt 
to have it in the kernel itself.

The other thing is that it is possible for people and distributions to 
upgrade the kernel without upgrading the btrfs tools, so there could be 
a window when there is no check on somebody's system.

Regards,
Blair

