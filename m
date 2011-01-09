From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Swap file on btrfs fails ("swapfile has holes")
Date: Sun, 9 Jan 2011 19:19:44 +0100
Message-ID: <201101091919.44129.diegocg@gmail.com>
References: <AANLkTimF8y+yBwcs3S0UQxDV=xWyTQRKxzKxR7ZHZnFL@mail.gmail.com>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Paul Richards <paul.richards@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimF8y+yBwcs3S0UQxDV=xWyTQRKxzKxR7ZHZnFL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Domingo, 9 de Enero de 2011 18:21:02 Paul Richards escribi=C3=B3:
> For now I've set up a swap file under /boot (ext4), but is swap on
> btrfs expected to work?  I'm using the stock Debian linux kernel
> 2.6.32-5-amd64.

AFAIK swapfiles are not supported, at least for now.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
