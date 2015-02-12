Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52018 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbbBLEmm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:42:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YLlbp-0000Al-WA
	for linux-btrfs@vger.kernel.org; Thu, 12 Feb 2015 05:42:38 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 05:42:37 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 05:42:37 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Thu, 12 Feb 2015 05:33:41 +0100
Message-ID: <62ntqb-o2r.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com> <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net> <CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com> <pan$9532$65b1220e$320184ed$94bcf659@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> P. Remek posted on Tue, 10 Feb 2015 18:44:33 +0100 as excerpted:
> 
>> In the test, I use --direct=1 parameter for fio which basically does
>> O_DIRECT on target file. The O_DIRECT should guarantee that the
>> filesystem cache is bypassed and IO is sent directly to the underlaying
>> storage. Are you saying that btrfs buffers writes despite of O_DIRECT?
> 
> I'm out of my (admin, no claims at developer) league on that.  I see
> someone else replied, and would defer to them on this.

I don't think that O_DIRECT can work efficiently on COW filesystems. It 
probably has a negative effect and cannot be faster as normal access. Linus 
itself said one time that O_DIRECT is broken and should go away, and instead 
cache hinting should be used.

Think of this: For the _unbuffered_ direct-io request to be fulfilled the 
file system has to go through its COW logic first which it otherwise had 
buffered and done in background. Bypassing the cache is probably only a 
side-effect of O_DIRECT, not its purpose.

At least I'd try with a nocow-file for the benchmark if you still have to 
use O_DIRECT.

-- 
Replies to list only preferred.

