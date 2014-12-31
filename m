Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47248 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaLaEDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 23:03:20 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so20684449pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 20:03:20 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: should I use btrfs on Centos 7 for a new production server?
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
Date: Wed, 31 Dec 2014 12:03:13 +0800
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <B12D4A1D-8EB5-4C9B-A8DC-7280D333E2BC@gmail.com>
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
To: Dave Stevens <geek@uniserve.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> 
> I have a well tested and working fine Centos5-Xen system. Accumulated cruft from various development efforts make it desirable to redo the install. Currently a RAID-10 ext4 filesystem with LVM and 750G of storage. There's a hot spare 750 drive in the system.
> 
> I'm thinking of migrating the web sites (almost the only use of the server) to a spare then installing Centos-7 and btrfs, then migrating the sites back.
> 
> I see RH marks btrfs in C7 as a technology preview but don't understand what that implies for future support and a suitably stable basis for storage.
> 
> The demand on the system is low and not likely to change in the near future, storage access speeds are not likely to be dealbreakers and it would be nice to not need to use LVM, btrfs seems to have a better feature set and more intuitive command set. But I'm uncertain about stability. Anyone have an opinion?
> 

I used CentOS7 btrfs myself, just doing some tests..it crashed easily.
I don’t know how much efforts that Redhat do on btrfs for 7 series.


> Dave
> 
> -- 
> "As long as politics is the shadow cast on society by big business,
> the attenuation of the shadow will not change the substance."
> 
> -- John Dewey
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

