Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52149 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753402AbaGHV1G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jul 2014 17:27:06 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:58569 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X4cun-003MOS-R2
	for linux-btrfs@vger.kernel.org; Tue, 08 Jul 2014 15:27:05 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs and mount in gentoo linux
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53BC597D.3030107@xunil.at>
Date: Tue, 8 Jul 2014 15:27:04 -0600
Message-Id: <BB94E56C-6089-4691-A4D2-F8A812B4581A@colorremedies.com>
References: <53BC4172.8080300@xunil.at> <A8D31CAA-14AC-407E-96BB-34E0ACF7F452@colorremedies.com> <53BC597D.3030107@xunil.at>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 8, 2014, at 2:50 PM, Stefan G. Weichinger <lists@xunil.at> wrote:

> Am 08.07.2014 22:20, schrieb Chris Murphy:
>> 
>> On Jul 8, 2014, at 1:07 PM, Stefan G. Weichinger <lists@xunil.at> wrote:
>>> 
>>> Can you tell me where the problem/solution might be located?
>>> Is it a known behavior in a way … ?
>> 
>> It's known. Ubuntu has a patch so that mount shows subvolume names. 
>> This information is probably available on Gentoo with cat /proc/self/mountinfo.
> 
> 
> Unfortunately no.
> 
> See example from my laptop:
> 
> # grep btrfs /proc/self/mountinfo
> 14 0 0:14 /rootfs / rw,noatime shared:1 - btrfs /dev/sda3
> rw,compress=lzo,ssd,space_cache
> 
> 51 14 0:14 / /mnt/uncow rw,noatime shared:19 - btrfs /dev/sda3
> rw,compress=lzo,ssd,space_cache
> 
> 156 14 0:35 / /home/sgw rw,noatime shared:117 - btrfs
> /dev/mapper/_dev_sda4 rw,compress=lzo,ssd,space_cache

Well it looks to me you have used mount -o subvol=rootfs for the first instance, but you've not mounted a subvolume at /mnt/uncow and /home/sgw.

What kernel version is this? And I thought the kernel was entirely responsible for the contents of /proc?

http://ur1.ca/hpk57
The fourth column lists subvol names.

> 
> What does the Ubuntu patch apply to? util-linux?

No idea.

Chris Murphy