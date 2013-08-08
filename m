Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f68.google.com ([209.85.216.68]:60032 "EHLO
	mail-qa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796Ab3HHQNG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 12:13:06 -0400
Received: by mail-qa0-f68.google.com with SMTP id j11so205220qag.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 09:13:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Aug 2013 09:13:04 -0700
Message-ID: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
Subject: Why does btrfs benchmark so badly in this case?
From: John Williams <jwilliams4200@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phoronix periodically runs benchmarks on filesystems, and one thing I
have noticed is that btrfs always does terribly on their fio "Intel
IOMeter fileserver access pattern" benchmark:

http://www.phoronix.com/scan.php?page=article&item=linux_310_10fs&num=2

Here, btrfs is more than 6 times slower than ext4, and about 3 times
slower than XFS.

Lest we attribute it to an unavoidable downside of COW filesystems and
move on...no, we cannot do that, because ZFS does well here -- btrfs
is about 6 times slower than ZFS!

Note that btrfs does quite well in the other Phoronix benchmarks. It
is just the fio fileserver benchmark that btrfs has problems with.

What is going on here? Why is btrfs doing so poorly?
