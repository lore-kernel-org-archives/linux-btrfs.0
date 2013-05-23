Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58530 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3EWQIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 12:08:37 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support ("N-way mirror code")
Date: Thu, 23 May 2013 18:08:35 +0200
Message-ID: <1823670.hMFQUu2mCu@merkaba>
In-Reply-To: <knfoof$u08$1@ger.gmane.org>
References: <518CFE3A.3080900@chinilu.com> <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net> <knfoof$u08$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 21. Mai 2013, 13:19:31 schrieb Martin:
> Yep, ReiserFS has stood the test of time very well and I'm still using
> and abusing it still on various servers all the way from something like
> a decade ago!

Very interesting. I only used it for a short time and it worked.

But co-workers lost several ReiserFS filesystems completely.

Well, if you search for the terms corrupt and your favorite filesystem, you 
will always find hits.

Anyway, I won´t use ReiserFS 3 today for several reasons:

1) It is not yet actively developed anymore, but more in a maintenance. I know 
for some that might be a reason to use it, but I think this basically 
increases the risk of breakages instead of reducing it. That said, I didn´t 
hear of any, and also JFS is in maintenance, but appears to work as well.

2) As to my knowledge a fsck.reiserfs cannot tell the filesystem I check and 
possible ReiserFS3 filesystems in virtual machine image files on it appart, 
happily mixing them together in a huge big mess.

3) As to my knowledge mount times of large partitions can be quite long with 
ReiserFS 3.

That said, I am using BTRFS on my main laptop even for /home now after having 
used it on several other machines for more than a year. Despite from that 
wierd scrub issue that I "fixed" by redoing the filesystem, rsync backup 
appeared t be okay, I am ready to trust my data to BTRFS. Also my backup 
harddisks are BTRFS.

I like BTRFS for some reasons, two that immediately come to my mind:

1) It can prove to me that the data is intact. I find this rather valuable.

2) Due to snapshots I know have well snapshots for my backup. And even on SSD 
for my /home. I am not yet creating those in an automated way, but well I do 
use them.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
