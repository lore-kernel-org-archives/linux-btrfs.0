Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:57368 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab2EQIpH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 04:45:07 -0400
Message-ID: <4FB4BA87.7090709@giantdisaster.de>
Date: Thu, 17 May 2012 10:44:55 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: ierdnah@gmail.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Btrfs-progs: support get/reset device stats via
 ioctl
References: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de> <1337187784.1525.6.camel@ierdnac-hp>
In-Reply-To: <1337187784.1525.6.camel@ierdnac-hp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/16/2012 19:03, Andrei Popa wrote:
> It would be nice if this function could show the file names affected by
> errors, in case of a single, non-redundant drive, btrfs-progs should
> show what files are affected by errors.
> Then, an admin could restore only those files from backup.
>
> On Wed, 2012-05-16 at 18:50 +0200, Stefan Behrens wrote:
>> "btrfs device stats" is used to retrieve and print the device stats.
>> "btrfs device stats -z" is used to atomically retrieve, reset and
>> print the stats.


In case of disk errors, it is recommended to run scrub on that disk. It 
checks the in-use disk contents for errors, repairs errors where 
possible, and the scrub tool does print the paths and filenames of 
errored files into the kernel log.
