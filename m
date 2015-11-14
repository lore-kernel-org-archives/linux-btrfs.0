Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34340 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbKNKnf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 05:43:35 -0500
Received: by wmvv187 with SMTP id v187so114564019wmv.1
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 02:43:34 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 14 Nov 2015 12:43:34 +0200
Message-ID: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
Subject: Using Btrfs on single drives
From: audio muze <audiomuze@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm looking to make a "production copy" of my music and video library
for use in our media server.  It is not my intent to create any form
of RAID array, but rather to treat each drive independently where
filesystem is concerned and then to create a single view of the drives
using mhddfs.  As the data will remain relatively static I may also
deploy Snapraid in conjunction with mhddfs.

I'm considering using Btrfs as the underlying filesystem on each of
the individual drives, principally to take advantage of metadata
redundancy.  Am I corect in surmising that ?I can turn checksumming
off given it's of no utility where a Btrfs volume is comprised of a
single device only?
