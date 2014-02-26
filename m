Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaBZDkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 22:40:24 -0500
Message-ID: <530D61B6.7040106@cn.fujitsu.com>
Date: Wed, 26 Feb 2014 11:38:30 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0rc3: btrfs send ioctl failed with -5: Input/output error
References: <20140225063652.GD3521@merlins.org> <530C4B37.9000402@cn.fujitsu.com> <20140225173022.GF3521@merlins.org>
In-Reply-To: <20140225173022.GF3521@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

On 02/26/2014 01:30 AM, Marc MERLIN wrote:
> On Tue, Feb 25, 2014 at 03:50:15PM +0800, Wang Shilong wrote:
>> Hi Marc,
>>
>> This seems a regression which has been fixed by the following
>> commit(only pushed into btrfs-next):
>>
>> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=1334bebe71bebbca47b3b92f25511ea980fdeab8
> I'll revert this, thanks.
>
> Mmmh, but I just found another problem I didn't have before upgrading to 3.14.0-rc3
> (on my laptop this time):
What is your previous version, give a double check whether the following 
commit exists:

Btrfs: remove transaction from btrfs send(commitid: 41ce9970)

This regression should exist in 3.14 Sine chris firstly pull big btrfs 
request for Linux 3.14.
>
> + btrfs send -p /mnt/btrfs_pool1/var_ro.20140224_14:01:54 var_ro.20140225_09:27:57
> + btrfs receive /mnt/btrfs_pool2//
> At subvol var_ro.20140225_09:27:57
> At snapshot var_ro.20140225_09:27:57
> ERROR: send ioctl failed with -5: Input/output error
> ERROR: unexpected EOF in stream.
Did dmesg output the same things like before?

Hm, we can esaily trigger that regression if there is snapshot and send 
running concurrently.
(balance/scrub ...device operations can also trigger send failure.)

Thanks,
Wang
>
> Is it another different regression?
>
> Currently it's only happening on one of my subvolumes. The other ones
> are still syncing ok.
>
> Thanks,
> Marc

