Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27418 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbaGWJIG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 05:08:06 -0400
Message-ID: <53CF7C41.5050408@oracle.com>
Date: Wed, 23 Jul 2014 17:11:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: code optimize use btrfs_get_bdev_and_sb()
 at btrfs_scan_one_device
References: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com> <20140722174241.GC1553@twin.jikos.cz>
In-Reply-To: <20140722174241.GC1553@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/23/2014 01:42 AM, David Sterba wrote:
> On Tue, Jul 08, 2014 at 02:38:37AM +0800, Anand Jain wrote:
>> (for review comments pls).
>>
>> btrfs_scan_one_device() needs SB, instead of doing it from scratch could
>> use btrfs_get_bdev_and_sb()
>
> Please see
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6f60cbd3ae442cb35861bb522f388db123d42ec1
>
> your patch actually reverts the changes. btrfs_get_bdev_and_sb does not
> work and it was a pretty nasty bug, we've spent a long afternoon
> catching it.

  Ah! It explains why we had a different btrfs_read_dev_super().

  Thanks.
Anand
