From: Martin Schitter <ms@mur.at>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 16:06:58 +0200
Message-ID: <4DC15D82.40802@mur.at>
References: <4DC07A10.7070200@mur.at> <1304512672-sup-1948@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304512672-sup-1948@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am 2011-05-04 14:39, schrieb Chris Mason:
> What OS is inside these virtual machines?  The btrfs unstable tree has
> some fixes for windows based OSes.

we have only linux guests of different flavor, no windows guests.

both corruptions during this last weeks belong to different virtual 
block device images of the same guest instance.

> Is your kvm config using O_DIRECT?

yes -- the kvm/qemu option cache="none" implies O_DIRECT.

> I've also got patches here that force us to honor nodatasum even when
> the file has csums, that can help if the contents of the file are
> actually good.

that sounds interessting! in our case it may be easier do use same 
recent backup data, but it could be very helpful in similar situations.

i would really like to help isolating the reasons of this failure and a 
find a practical strategy to prevent additional breakdowns.

thanks
martin
