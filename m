Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:51876 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKZTzb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 14:55:31 -0500
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by meiko.romanrm.net (Postfix) with SMTP id 1DC7417118
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 19:55:28 +0000 (UTC)
Date: Thu, 27 Nov 2014 00:55:27 +0500
From: Roman Mamedov <rm@romanrm.net>
To: <linux-btrfs@vger.kernel.org>
Subject: Can't cp --reflink files on a Ext4-converted FS w/o checksums
Message-ID: <20141127005527.42a7fe59@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I used btrfs-convert to switch my FS from Ext4 to Btrfs. As it was a rather
large 10 TB filesystem, to save on the conversion time, I used the "-d,
disable data checksum" option of btrfs-convert.

Turns out now I can't "cp --reflink" any files that were already on the FS
prior to conversion. The error message from cp is "failed to clone [...]
Invalid argument".

I assume this is because of the lack of checksums; the only way to make old
files cloneable is to plain copy them to a different place and then delete the
originals, but that's what I was trying to avoid in the first place.

Also I thought maybe defragmenting will help, but nope, doesn't seem to be the
case, even ordering it to recompress data to a different method doesn't fix
the problem. (Even if it did, it's still a lot of unnecessary rewriting).

Is there really a good reason to stop these files without checksums from being
cloneable? It's not like they have the noCoW attribute, so I'd assume any new
write to these files would cause a CoW and proper checksums for all new blocks
anyways.

-- 
With respect,
Roman
