Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36622 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaABW2f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2014 17:28:35 -0500
Received: by mail-wg0-f53.google.com with SMTP id k14so13179194wgh.32
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 14:28:34 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 2 Jan 2014 16:28:33 -0600
Message-ID: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
Subject: Managing large volumes
From: Tim Cuthbertson <ratcheer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am a bit confused and I have probably managed to outsmart myself.
For about 15 months, I have been running my system on a single, large
btrfs volume. It is RAID-0 on two SATA-III HDD's for a total of 1.9
TB. This is a home system running Siduction (Debian Sid) Linux. While
I have root, home, and a special data directory each as separate
subvolumes, I am beginning to wonder whether I should have made each
of these on separate partitions and separate btrfs filesystems.

Am am at a point where I would like to do a fresh install of my OS
without losing my home and data contents. And I do not think separate
btrfs subvolumes will help me on that. Is that correct? Is there a way
to prevent an OS installation from formatting the /home and /data
subvolumes while completely replacing the root subvolume? Or do I need
to completely repartition my drives so I don't get into this
situation, again?

Thank you,
Tim
