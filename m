Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35955 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbcF2RlR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 13:41:17 -0400
Received: by mail-wm0-f42.google.com with SMTP id f126so191001874wma.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 10:41:16 -0700 (PDT)
Received: from system (dslb-092-074-022-141.092.074.pools.vodafone-ip.de. [92.74.22.141])
        by smtp.gmail.com with ESMTPSA id el4sm4744072wjd.23.2016.06.29.10.41.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 10:41:15 -0700 (PDT)
Date: Wed, 29 Jun 2016 19:41:14 +0200
From: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160629194114.6baf58ba@system>
In-Reply-To: <20160629115055.29018e6a@system>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
	<CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
	<20160628010618.58e235fa@system>
	<CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
	<20160628024940.3b323b26@system>
	<CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
	<20160629005208.5e9addcf@system>
	<CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
	<20160629115055.29018e6a@system>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 29 Jun 2016 11:50:55 +0200, Saint Germain <saintger@gmail.com>
wrote :

> So if I understand correctly, you advise to use check --repair
> --init-csum-tree and delete the files which were reported as having
> checksum error ?
> After that I can compare the important files to a backup, but there is
> always the non-important files which are not backuped.
> 
> Is there anyway I can be sure afterwards that the volume is indeed
> completely correct and reliable ?
> If there is no way to be sure, I think it is better that I cp/rsync
> all data to a new BTRFS volume.
> 

Oh and I forgot to add that rsync doesn't support reflink yet, so I am
bit reluctant to rsync all data to a new volume instead of repairing
the existing BTRFS volume.

