Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:64231 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbbLHWw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 17:52:58 -0500
From: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub can neither start nor cancel
Date: Tue, 08 Dec 2015 23:52:55 +0100
Message-ID: <2077001.YIOJ0kAoma@i5>
In-Reply-To: <20151208205108.GD2376@carfax.org.uk>
References: <31519331.YQjdnfjTR6@i5> <20151208205108.GD2376@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 8. Dezember 2015, 20:51:08 schrieb Hugo Mills:
> On Tue, Dec 08, 2015 at 09:46:48PM +0100, Wolfgang Rohdewald wrote:
> > Anyway now I can neither cancel nor start btrfs scrub. Rebooting did not help.
> 
>    It might be that the userspace tools has got confused and left
> behind a lock/pid/progress file in /var/lib/btrfs/
> 
>    Take a look in there and see if there's anything that you can
> delete to good effect?

root@s5:/var/lib/btrfs# ls -l
insgesamt 4
srwxr-xr-x 1 root root   0 Dez  8 21:05 scrub.progress.700900de-e35f-4264-8f5d-1b2b249a5c3a
-rw------- 1 root root 394 Dez  8 21:05 scrub.status.700900de-e35f-4264-8f5d-1b2b249a5c3a

that fixed it, thanks!

I would have expected that such temporary files are deleted at reboot, so
ẗo me this looks like a bug in user-space.


-- 
Wolfgang
