From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Safe fsck / consistent backup while mounted
Date: Sat, 04 Jun 2011 15:46:12 +0200
Message-ID: <4DEA3724.8070007@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Now I thought about a way to safely backup a MySQL or other database -
> without long service interruption:
>
> - Tell DB to turn itself into consistent state and freeze there
> - sync / btrfs filesystem sync ; fsfreeze -f /mountpoint
> - btrfs subvolume snapshot
> - fsfreeze -u /mountpoint

Hmm, I don't think fsfreeze works properly with btrfs?


-- 
Tomasz Chmielewski
http://wpkg.org

