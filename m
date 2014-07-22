Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbaGVOn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 10:43:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X9bIL-0000Ln-41
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 16:43:57 +0200
Received: from athedsl-372136.home.otenet.gr ([79.131.5.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 16:43:57 +0200
Received: from tmjuju by athedsl-372136.home.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 16:43:57 +0200
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Tue, 22 Jul 2014 14:43:45 +0000 (UTC)
Message-ID: <loom.20140722T164042-111@post.gmane.org>
References: <loom.20140720T102642-239@post.gmane.org> <53CC6B39.1060705@cn.fujitsu.com> <loom.20140721T155907-291@post.gmane.org> <53CDBBC7.6000609@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong <wangsl.fnst <at> cn.fujitsu.com> writes:


> The latest btrfs-progs include man page of btrfs-replace. Actually, you 
> could use it
> something like:
> 
> btrfs replace start  <srcdev>|<devid> <targetdev> <mnt>
> 
> You could use 'btrfs file show' to see missing device id. and then run 
> btrfs replace.
> 

Hi Wang,

  I physically removed the drive before the rebuild, having a failing device
as a source is not a good idea anyway.
  Without the device in place, the device name is not showing up, since the
missing device is not under /dev/sdXX or anything else. 

  That is why I asked if the special parameter 'missing' may be used in a
replace. I can't say if it is supported. But I guess not, since I found no
documentation on this matter.

  So I guess replace is not aimed at fault tolerance / rebuilding. It's just
a convenient way to lets lay replace the disks with larger disks , to extend
your array. A convenience tool, not an emergency tool.

TM

> Thanks,
> Wang


