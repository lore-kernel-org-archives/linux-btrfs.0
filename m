Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36118 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaHABzU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 21:55:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XD23z-0004jY-DG
	for linux-btrfs@vger.kernel.org; Fri, 01 Aug 2014 03:55:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 03:55:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 03:55:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs on bcache
Date: Fri, 1 Aug 2014 01:55:08 +0000 (UTC)
Message-ID: <pan$a04fa$5cd7ad2f$4c951447$c4e27df6@cox.net>
References: <1731942750.1162128.1406757898913.JavaMail.ngmail@webmail06.arcor-online.net>
	<1028108337.2120293.1406820944449.JavaMail.ngmail@webmail09.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dptrash posted on Thu, 31 Jul 2014 17:35:44 +0200 as excerpted:

> Concerning http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018,
> does this "bug" still exists?
> 
> Kernel 3.14 B: 2x HDD 1 TB C: 1x SSD 256 GB
> 
> # make-bcache -B /dev/sda /dev/sdb -C /dev/sdc
> --cache_replacement_policy=lru
> # mkfs.btrfs -d raid1 -m raid1 -L "BTRFS_RAID" /dev/bcache0 /dev/bcache1
> 
> I still have no "incomplete page write" messages in "dmesg | grep btrfs"
> and the checksums of some manually reviewed files are okay.
> 
> Who has more experiences about this?

See the reply (not mine) to your earlier post of the question:

http://permalink.gmane.org/gmane.linux.kernel.bcache.devel/2602

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

