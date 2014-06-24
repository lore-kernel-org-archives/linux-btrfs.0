Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:44561 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaFXVss (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 17:48:48 -0400
Message-ID: <53A9F246.2040509@nv-systems.net>
Date: Tue, 24 Jun 2014 23:48:54 +0200
From: Gerald Hopf <gerald.hopf@nv-systems.net>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: "-d single" for data blocks on a multiple devices doesn't work
 as it should
References: <53A955F8.8090101@nv-systems.net> <20140624170236.28d5bfa9@natsu>
In-Reply-To: <20140624170236.28d5bfa9@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 24.06.2014 13:02, Roman Mamedov wrote:
> If you want to join multiple devices with a per-file granularity (so 
> that a single file is wholely stored on one given device), check out 
> the FUSE filesystem called mhddfs; I wrote an article about it some 
> time ago: https://romanrm.net/mhddfs 
Thank you very much for this excellent recommendation. I had never heard 
of this layered "filesystem" before. And I have to admit, I was 
initially quite skeptical of your mhddfs recommendation, because of... 
well... FUSE :-)

But I read your article and the mhddfs documentation and it is exactly 
the solution I had in mind (where trouble on one of the disks does never 
ever affect data on other disks). mhddfs performance is also great, 
130MB/s at only 50% load on one of the cpu's cores - it does only seem 
to be limited by the disk and not by the CPU or FUSE.

Thanks again. I will now use mhddfs for my backups. And even though I'm 
now not using btrfs for my backups, having a perfectly working backup 
solution will make it much more likely for me to use BTFS on my main 
disk array once the btrfs RAID5/6 support is slightly more complete :-)

Thanks again,
Gerald

