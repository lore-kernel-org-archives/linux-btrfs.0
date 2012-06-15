Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52366 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab2FOKuN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 06:50:13 -0400
Date: Fri, 15 Jun 2012 12:50:06 +0200
From: David Sterba <dave@jikos.cz>
To: Andrei Popa <ierdnah@gmail.com>
Cc: linux-btrfs@vger.kernel.org, arnd@arndnet.de
Subject: Re: [PATCH] Btrfs: add "nocompress" mount option
Message-ID: <20120615105006.GV32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339754209.2212.22.camel@ierdnac-hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339754209.2212.22.camel@ierdnac-hp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2012 at 12:56:49PM +0300, Andrei Popa wrote:
> In btrfs if we mount with "compress" we have no way to disable
> compressing by remounting 
> (mount -o remount /mnt/btrfs), only by unmounting and mounting without
> "compress".
> This patch adds "nocompress" mount option which can be used to remount
> the filesystem without compression:
> # mount -o remount,nocompress /mnt/btrfs
> This option is usefull in cases when we have a filesystem mounted with
> "compress" and we want to disable compression but we don't want to
> umount and mount it.


Arnd Hannemann sent a patch for this
http://lkml.indiana.edu/hypermail/linux/kernel/1204.2/00231.html

that takes a different approach: setting compression to '=no' disables
compression. I prefer this over adding an extra option to disable. This
way there's no confusion if the compression is on or off.

  mount -o compress,nocompress /dev /mnt

Is it on or off? Yeah we can document that nocompress has higher
priority. But then I can't turn a nocompress option back to compress via
remount. This is possible with Arnd's patch.


david
