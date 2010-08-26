From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [2.6.35.3] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Thu, 26 Aug 2010 07:53:36 -0400
Message-ID: <20100826115336.GW14190@think>
References: <20100826095357.GA7202@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100826095357.GA7202@Pilar.aei.mpg.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 26, 2010 at 11:53:57AM +0200, Carlos R. Mafra wrote:
> Hi,
> 
> I've just got this BUG: message in dmesg which I think is btrfs related.
> 
> I have a btrfs filesystem in a memory card which I use to contain the 
> cache and config of chromium (to avoid writing to much in the SSD):
> 
> /dev/mmcblk0p1 on /home/mafra/mmc type btrfs (rw,noexec,nosuid,nodev,noatime,noacl,compress)
> 
> and the last message before the bug is about the memory card.

Hmmm it is definitely btrfs related.  Do you continue to get it after
rebooting?

-chris
