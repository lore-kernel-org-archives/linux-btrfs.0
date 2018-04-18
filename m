Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47089 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750961AbeDRQsw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 12:48:52 -0400
Subject: Re: Filesystem full with unallocated space?
To: Matthew Lai <m@matthewlai.ca>, linux-btrfs@vger.kernel.org
References: <89d90bb8-dbe3-1789-60eb-a29f9d1e3a64@matthewlai.ca>
 <b7c2b3f9-89cf-9ae4-7d73-cfdd274f56cd@matthewlai.ca>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aa9580ac-eba2-038c-1e60-a57a05eb544d@suse.com>
Date: Wed, 18 Apr 2018 19:48:49 +0300
MIME-Version: 1.0
In-Reply-To: <b7c2b3f9-89cf-9ae4-7d73-cfdd274f56cd@matthewlai.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.04.2018 19:08, Matthew Lai wrote:
> Hello!
> 
> I am getting ENOSPC on my root filesystem with plenty of unallocated
> space according to "fi usage". Any idea why that may be? This is a root
> partition for Debian Stable. Not doing anything unusual that I'm aware
> of. No snapshots.
> 
> Thanks!
> 
> Matthew
> 
> uname -a:
> Linux bigfoot 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3+deb9u1 (2017-12-23)
> x86_64 GNU/Linux
> 
> btrfs --version:
> btrfs-progs v4.7.3
> 
> btrfs fi show:
> Label: none  uuid: 2364c63f-e20c-410f-90b4-05f722ee1c77
>     Total devices 1 FS bytes used 176.27GiB
>     devid    1 size 246.33GiB used 185.01GiB path /dev/sda2
> 
> btrfs fi df /:
> Data, single: total=183.00GiB, used=175.78GiB
> System, single: total=4.00MiB, used=48.00KiB
> Metadata, single: total=2.01GiB, used=504.81MiB
> GlobalReserve, single: total=211.39MiB, used=0.00B
> 


You haven't shown "btrfs fi usage". In any case there were some patches
in more recent kernels which deal with premature ENOSPC:


996478ca9c46 ("btrfs: change how we decide to commit transactions during
flushing")
17024ad0a0fd ("Btrfs: fix early ENOSPC due to delalloc")


I'd advise you update to 4.14 stable. Otherwise running:
git log --oneline --grep "enospc" fs/btrfs/

will shows you likely candidates.
