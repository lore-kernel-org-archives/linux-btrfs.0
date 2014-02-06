Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-caryn.wadns.net ([196.220.39.178]:53987 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbaBFHid (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 02:38:33 -0500
Message-ID: <52F33BE7.4020708@swiftspirit.co.za>
Date: Thu, 06 Feb 2014 09:38:15 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
References: <20140206021516.304732cd@natsu>
In-Reply-To: <20140206021516.304732cd@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/02/05 10:15 PM, Roman Mamedov wrote:
> Hello,
>
> On a freshly-created RAID1 filesystem of two 1TB disks:
>
> # df -h /mnt/p2/
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2
>
> I cannot write 2TB of user data to that RAID1, so this estimate is clearly
> misleading. I got tired of looking at the bogus disk free space on all my
> RAID1 btrfs systems, so today I decided to do something about this:
...
> After:
>
> # df -h /mnt/p2/
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda2       1.8T  1.1M  912G   1% /mnt/p2
>
> Until per-subvolume RAID profiles are implemented, this estimate will be
> correct, and even after, it should be closer to the truth than assuming the
> user will fill their RAID1 FS only with subvolumes of single or raid0 profiles.
This is a known issue: 
https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

Btrfs is still considered experimental - this is just one of those 
caveats we've learned to adjust to.

The change could work well for now and I'm sure it has been considered. 
I guess the biggest end-user issue is that you can, at a whim, change 
the model for new blocks - raid0/5/6,single etc and your value from 5 
minutes ago is far out from your new value without having written 
anything or taken up any space. Not a show-stopper problem, really.

The biggest dev issue is that future features will break this behaviour, 
such as the "per-subvolume RAID profiles" you mentioned. It is difficult 
to motivate including code (for which there's a known workaround) where 
we know it will be obsoleted.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

