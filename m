Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:32785 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaJOHI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 03:08:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.miceliux.com (Postfix) with ESMTP id 3686F19773B
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 09:08:16 +0200 (CEST)
Received: from mx2.miceliux.com ([127.0.0.1])
	by localhost (mx2.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id js7pus9-YG5B for <linux-btrfs@vger.kernel.org>;
	Wed, 15 Oct 2014 09:08:15 +0200 (CEST)
Received: from miceliux.com (unknown [IPv6:2a00:dcc0:dead:a8bb::1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx2.miceliux.com (Postfix) with ESMTPSA id 5776B197738
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 09:08:15 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 15 Oct 2014 09:08:14 +0200
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Random file system corruption in 3.17 (not BTRFS
 =?UTF-8?Q?related=2E=2E=2E=3F=29?=
In-Reply-To: <543D555B.50708@pobox.com>
References: <543D555B.50708@pobox.com>
Message-ID: <eff13bd09ee6883785a4be3ab005886b@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El 2014-10-14 18:54, Robert White escribió:
> Howdy,
> 
> So I run several gentoo systems and I upgraded two of them to kernel 
> 3.17.0
> 
> One using BTRFS for root.
> One using ext3 for root (via the ext4 driver)
> 
> _Both_ systems exhibited strange behavior (long pauses and then hangs
> requiring hard-power) within several hours. Both then had random
> filesystem damage.
> 
> On the BTRFS system much of my browser settings for firefox were
> trashed, particularly the cookies and saved conifigurations for
> add-ons (like which sites had scripts enabled/disabled in no-script)
> etc.
> 
> On the ext3/4 system there were several corruptions including a
> pipe/special file with a large non-zero size that required I do a
> "fsck -fyD /dev/sda3" to repair. (one comment from fsck was that the
> pipe/special file "looked like a directory" or some such)
> 
> So I can say that corruption is taking place, but I suspect it is
> _not_ happening in the BTRFS specific code.
> 
> (ASIDE: both systems are older amd64 using built-in radeon display 
> hardware.)
> 

I've also experienced Btrfs corruptions with 3.17.0 (Fedora 21 alpha). 
It has happened two times, each one after a clean reinstall and a wipe 
of the old fs. In less than a day, both installations got corrupted and 
the filesystems went readonly. When listing the contents, I saw many 
directories with question marks.

My system has 4 drives and 2 fs:
- 1 SSD in single
- 3 HDD in RAID1

I do readonly snapshots every hour of all the subvolumes, so I have 
hundreds of snapshots.

Now I'm back in 3.16.4 without any problems. I'm trying to reproduce my 
setup in a virtual machine. If the corruption happens again, I'll send 
you more data on this problem.

-- 
Juan Orti
https://miceliux.com

