Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35678 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbcAZAoi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 19:44:38 -0500
Received: by mail-io0-f180.google.com with SMTP id 77so170011927ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 16:44:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
References: <56A230C3.3080100@netcologne.de>
	<CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
	<56A6082C.3030007@netcologne.de>
	<CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
	<CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
Date: Mon, 25 Jan 2016 18:44:37 -0600
Message-ID: <CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
Subject: Fwd: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to
 one cpu core?
From: Justin Brown <justin.brown@fandingo.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Does anyone suspect a kernel regression here? I wonder if its worth it
> to suggest testing the current version of all fairly recent kernels:
> 4.5.rc1, 4.4, 4.3.4, 4.2.8, 4.1.16?

I don't have any useful information about parity RAID modes or large
arrays, so this might be totally useless. Nonetheless, just last week
I added a 2TB drive to an existing Btrfs raid10 array (5x 2TB before
addition) and did a balance afterwards. I don't take any numbers, but
I was frequently looking at htop and iotop. I thought the numbers were
extremely good: 100-120MB/s sustained for each drive with the "total"
reported by iotop exceeding 600MB/s. That's with integrated sata
controller on an Intel Z97 mini-ITX motherboard (cpu i4770).
Significantly faster than anticipated. I started it one evening, and
it was finished when I awoke the next morning.

That was on 4.2.8-300.fc23.x86_64 with btrfs-progs 4.3.1.
