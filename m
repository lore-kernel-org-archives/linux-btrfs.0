Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37185 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbaLaEA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 23:00:29 -0500
Message-ID: <54A374C1.2030401@cn.fujitsu.com>
Date: Wed, 31 Dec 2014 12:00:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Dave Stevens <geek@uniserve.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: should I use btrfs on Centos 7 for a new production server?
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
In-Reply-To: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

-------- Original Message --------
Subject: should I use btrfs on Centos 7 for a new production server?
From: Dave Stevens <geek@uniserve.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: 2014年12月31日 11:29
> I have a well tested and working fine Centos5-Xen system. Accumulated 
> cruft from various development efforts make it desirable to redo the 
> install. Currently a RAID-10 ext4 filesystem with LVM and 750G of 
> storage. There's a hot spare 750 drive in the system.
>
> I'm thinking of migrating the web sites (almost the only use of the 
> server) to a spare then installing Centos-7 and btrfs, then migrating 
> the sites back.
>
> I see RH marks btrfs in C7 as a technology preview but don't 
> understand what that implies for future support and a suitably stable 
> basis for storage.
Technology preview means no full official Red Hat support, just preview 
for technology.
https://access.redhat.com/support/offerings/techpreview

It may comes to full support in later version if it matures.
>
> The demand on the system is low and not likely to change in the near 
> future, storage access speeds are not likely to be dealbreakers and it 
> would be nice to not need to use LVM, btrfs seems to have a better 
> feature set and more intuitive command set. But I'm uncertain about 
> stability. Anyone have an opinion?
If I am sysadmin, I will still prefer the mature linux soft raid/LVM.

Less bug, mature kernel/user-land tools and use case,and you don't need 
to always update kernel/btrfs-progs
to address known bugs or fix corrupted fs
(if stay away from 
scrub/replace/balance/almost-full-disk/sudden-power-failure, it will 
shouldn't happen though)

But, if you want to contribute to btrfs, such production environment may 
expose some problem we didn't find.
Although you may take a lot time compiling latest kernel/btrfs-progs and 
doing btrfs-image dump, not to mention
the offline time...

Thanks,
Qu
>
> Dave
>

