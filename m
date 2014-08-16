Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:55368 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaHPKP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 06:15:58 -0400
Received: by mail-qg0-f42.google.com with SMTP id j5so3038343qga.29
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Aug 2014 03:15:57 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 Aug 2014 15:45:57 +0530
Message-ID: <CAH-HCWUonzQ0ynToWOf3FBayUVWbwcx6JZsAN+OXfCpo0RjDZg@mail.gmail.com>
Subject: Limitation of nocow set via chattr +C?
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello again. As I mentioned in my previous mail, I am not yet using
BTRFS for my real data. I'd like to know a few more things before
doing so.

Per my understanding of snapshots, unless I specifically mount the
subvolume and make changes to it, its contents will not change.
However, my understanding of nocow setting via chattr +C seems to
indicate that files marked with nocow are updated in place, which
means that if two snapshots point to the same file, if the contents
are modified via one snapshot, then it would change the other file,
which contradicts with the definition of a snapshot.

I tried this out, and sure enough, just because chattr +C was applied,
my change in the snapshot did not reflect in the original subvolume.
So nocow via chattr +C only means "don't do COW unless this file
exists in another snapshot", right?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
