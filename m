Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55248 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3DAMui (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 08:50:38 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 812CB9A0691
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 06:50:38 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id Kj8PdUA99cK1HxP6 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 06:50:36 -0600 (MDT)
Date: Mon, 1 Apr 2013 08:50:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC] Online dedup for Btrfs
Message-ID: <20130401125034.GG1876@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was bored this weekend so I hacked up online dedup for Btrfs.  It's working
quite well so I think it can be more widely tested.  There are two ways to use
it

1) Compatible mode - this is a bit slower but will handle being used by older
kernels.  We use the csum tree to find duplicate blocks.  Since it is relatively
easy to have crc32c collisions this also involves reading the block from disk
and doing a memcmp with the block we want to write to verify it has the same
data.  This is way slow but hey, no incompat flag!

2) Incompatible mode - so this is the way you probably want to use it if you
don't care about being able to go back to older kernels.  You select your
hashing function (at the momement I only support sha1 but there is room in the
format to have different functions).  This creates a btree indexed by the hash
and the bytenr.  Then we lookup the hash and just link the extent in if it
matches the hash.  You can use -o paranoid-dedup if you are paranoid about hash
collisions and this will force it to do the memcmp() dance to make sure that the
extent we are deduping really matches the extent.

So performance wise obviously the compat mode sucks.  It's about 50% slower on
disk and about 20% slower on my Fusion card.  We get pretty good space savings,
about 10% in my horrible test (just copy a git tree onto the fs), but IMHO not
worth the performance hit.

The incompat mode is a bit better, only 15% drop on disk and about 10% on my
fusion card.  Closer to the crc numbers if we have -o paranoid-dedup.  The space
savings is better since it uses the original extent sizes, we get about 15%
space savings.  Please feel free to pull and try it, you can get it here

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git dedup

Thanks!

Josef
