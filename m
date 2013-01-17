Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:21025 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3AQI05 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 03:26:57 -0500
Message-ID: <50F7B5CD.5020003@gmx.net>
Date: Thu, 17 Jan 2013 09:26:53 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: hopper@omnifarious.org
CC: linux-btrfs@vger.kernel.org
Subject: Re: Rendering a btrfs filesystem unmountable with the btrfs command
References: <20130115204436.GC18291@omnifarious.org>
In-Reply-To: <20130115204436.GC18291@omnifarious.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

thanks for reporting this. I sent a small patch series to the list
to fix this.
Sorry I forgot to CC you, will send the patches to you directly again.
It would be great if you could give it some testing.

Thanks,
Arne

On 15.01.2013 21:44, hopper@omnifarious.org wrote:
> mkfs.btrfs /dev/sdb
> mkdir /tmp/mnt
> mount /dev/sdb /tmp/mnt
> cd /tmp/mnt
> btrfs quota enable .
> btrfs subvol create foo
> btrfs qgroup create 1/0
> btrfs qgroup assign 0/257 1/0
> btrfs subvol snapshot foo bar
> btrfs qgroup assign 0/258 1/0
> cd ..
> umount /dev/sdb
> mount /dev/sdb /tmp/mnt
> # Still mountable!
> cd mnt
> btrfs qgroup destroy 1/0
> cd ..
> umount /dev/sdb
> mount /dev/sdb /tmp/mnt
> # Oops, no longer mountable, even in recovery mode!
> 
> Help!  BTW, I'm not a mailing list subscriber.
> 
> Thanks,

