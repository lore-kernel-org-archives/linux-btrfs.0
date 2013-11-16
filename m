Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43094 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3KPMGL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 07:06:11 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so1569848eek.33
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 04:06:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMFOmWB0ojMDAFF=AJti6Nit+3UUutYDYaAVgnfM113aVRVGg@mail.gmail.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
	<CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
	<CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com>
	<CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
	<CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
	<CAOMFOmWB0ojMDAFF=AJti6Nit+3UUutYDYaAVgnfM113aVRVGg@mail.gmail.com>
Date: Sat, 16 Nov 2013 04:06:10 -0800
Message-ID: <CAOMFOmUXKntgXnOTV=ZVPs==1Tun4KZg-_oGxaiM5Xc5NpP2zA@mail.gmail.com>
Subject: Re: How to fix/remove "csum failed ino" error
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Follow-up for the issue. I stuck with this "invalid csum for free
space extent" error. Could anyone explain what does it mean? If this
is not data and just a free space, why do we care about its checksum?
And if we do really care then btrfs should have a way to fix this
error. I can "fix" a file checksum error by removing the file, but how
to "fix" free space extent checksum error?

I decided to run --init-csum-tree to see if it fixes the issue with
free space csum. I expected that it will recalculate csum for data.
And found that it cleared csum tree completely and made my fs became
unusable. Any read returns csum error. The data is still on disk - I
can read it with filefrag+btrfs-map-logic+dd - it is just csum
information that got dropped. So I want to echo the request from Robin
http://www.spinics.net/lists/linux-btrfs/msg25271.html
Information about --init-csum-tree should be documented. What is the
use-case for this feature? In fact I expected that it will recalculate
the csum tree based on the data, not clear the tree.

So I endup with reinstalling my system and copying data from backups.

Despite all my complains I still think btrfs is a great filesystem. I
really enjoy their multi-device support that allows me to use all my
different HDDs that I have. Thanks for your work, everyone!
