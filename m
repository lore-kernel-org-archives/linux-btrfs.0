Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59630 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3KNTy2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 14:54:28 -0500
Received: by mail-wi0-f179.google.com with SMTP id fb10so3252888wid.6
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 11:54:27 -0800 (PST)
Received: from android-dc17a983a0b2c4a9 (host86-132-102-132.range86-132.btcentralplus.com. [86.132.102.132])
        by mx.google.com with ESMTPSA id dz5sm1704456wib.7.2013.11.14.11.54.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 14 Nov 2013 11:54:26 -0800 (PST)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: "No space left on device"
From: Leonidas Spyropoulos <artafinde@gmail.com>
Date: Thu, 14 Nov 2013 19:54:21 +0000
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <ecb3dcc9-c636-4fa7-b41f-e9021411a09a@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've been following this list for years and I see during various situations
this message coming up. Some times it's a genuine problem that there is
actually not enough space. In other cases it's some by-product of something
else. I have seen this error personality on a broken system ( which I never
figured out what had happened).
I know this is still experimental but I just want to make sure my
expectations are not really out on sync with the others.

As an end user when I see an error like this the first thing I will do is
check the space (using 'df' command) [1]. If I see more that 7% I usually
think it's OK, (depends on the size of partition as well).

- Is this unreasonable in btrfs filesystem? Is there a formula to calculate
how much space btrfs _might_ need?
- It's probably not your job but can df reports correct sizes for btrfs?
I've seen some threads on trying to show the actual space occupied by data
and/or metadata with btrfs command. Can we expect this someone to be
incorporated into df command?
- In cases that btrfs reports this error but there's something else that's
causing it, can we expect better error handling from btrfs so the end user
is pointed to the correct direction?

[1]: one could argue that an end user should use the btrfs commands instead
but let's leave that for now.

Apologies if these have already been answered or are already on roadmap.

Thanks in advanced, your comments are appreciated.

Kind regards,
Leonidas

