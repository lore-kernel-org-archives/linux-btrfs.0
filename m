Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44804 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaEaHTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 03:19:07 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so2929652wgh.19
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 00:19:05 -0700 (PDT)
Received: from linux-suse.hu (540130F5.dsl.pool.telekom.hu. [84.1.48.245])
        by mx.google.com with ESMTPSA id gd5sm16293861wjb.40.2014.05.31.00.19.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 May 2014 00:19:04 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: All free space eaten during defragmenting (3.14)
Date: Sat, 31 May 2014 09:19:03 +0200
Message-ID: <1703083.hLnNuPsKpY@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

A tried to make a full defragmenting on my $HOME directory (which doesn't 
contain any snapshots). After some hours of running, it stopped with „No space 
left on device” error.

I checked and it ate about 50 GB of free space.
Before: Data, single: total=433.83GiB, used=~380.00GiB
After: Data, single: total=433.83GiB, used=~430.00GiB
Both times: Metadata, DUP: total=8.00GiB, used=7.08GiB

In the "btrfs fi df" man page I didn't find anything that is related to this 
phenomenon.

My questions are:
- Is it a bug or some consequence of the defrag process?
- Can I reclaim somehow the free space?

Command used: 
shopt -s dotglob
for i in *; do echo "$i"; btrfs fi defrag -clzo -r "$i"; done

Btrfs and kernel version:
Btrfs v3.12+20131125
Linux 3.14.4-1.gbebeb6f-desktop #1 SMP PREEMPT x86_64

Best regards,
Ákos
