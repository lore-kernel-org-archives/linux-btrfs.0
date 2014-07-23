Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15416 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754749AbaGWB0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 21:26:03 -0400
Message-ID: <53CF0F28.4020606@cn.fujitsu.com>
Date: Wed, 23 Jul 2014 09:26:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: Add mount point output for 'btrfs fi
 df' command.
References: <1404889017-31426-1-git-send-email-quwenruo@cn.fujitsu.com> <20140722175617.GF1553@twin.jikos.cz>
In-Reply-To: <20140722175617.GF1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-------- Original Message --------
Subject: Re: [PATCH v2] btrfs-progs: Add mount point output for 'btrfs 
fi df' command.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月23日 01:56
> On Wed, Jul 09, 2014 at 02:56:57PM +0800, Qu Wenruo wrote:
>> Add mount point output for 'btrfs fi df'.
>> Also since the patch uses find_mount_root() to find mount point,
>> now 'btrfs fi df' can output more meaningful error message when given a
>> non-btrfs path.
> If a non-btrfs path is passed, the "Mounted on" line is printed,
> followed by 2 ERROR: lines. I suggest to print it only if get_df
> succeeds, ie. right before print_df.
Thanks for mentioning, I'll update the patchset soon.

Thanks,
Qu
