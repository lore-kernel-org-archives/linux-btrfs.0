Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55862 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbbLETig (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 14:38:36 -0500
Received: from guidonb ([79.194.183.215]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LkgEO-1afjPa35Qy-00aSrW for
 <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 20:38:34 +0100
From: <guido_kuenne@gmx.de>
To: "'linux-btrfs'" <linux-btrfs@vger.kernel.org>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
In-Reply-To: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
Subject: RE: compression disk space saving - what are your results?
Date: Sat, 5 Dec 2015 20:38:34 +0100
Message-ID: <011f01d12f94$88412110$98c36330$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Subject: compression disk space saving - what are your results?
> 
> What are your disk space savings when using btrfs with compression?

I checked that for some folders when I moved from ext4 to btrfs. I compared
du with df** just to get some numbers. I use lzo since btrfs-wiki said its
better for speed.


Percent_saving=(1-df/du)*100:
47% (mostly endless text files, source code etc., total amount of data is
about 1TB)
2%-10% (for data which is mostly in the form of large (several hundred MB up
to fewGB) binary files, total amount is about 4TB)
23% (for something in between, total amount is 0.4TB)

Result indicate pretty clearly: large binary files are almost not compressed
- without understanding much of it that's what I would intuitively expect
(afaik lzo is dictionary based and those binary files have little for that).


** du -s on the folder I copied to the btrfs drive. df is the difference in
between a df before and after the copy. Based on casual checking results
were consistent with the space needed on the old ext4 drive.


