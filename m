Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38822 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbcAZFR0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 00:17:26 -0500
Received: by mail-ig0-f182.google.com with SMTP id mw1so45537553igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 21:17:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
References: <56A230C3.3080100@netcologne.de>
	<CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
	<56A6082C.3030007@netcologne.de>
	<CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
	<CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
	<CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
Date: Mon, 25 Jan 2016 22:17:25 -0700
Message-ID: <CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 5:44 PM, Justin Brown <justin.brown@fandingo.org> wrote:
>> Does anyone suspect a kernel regression here? I wonder if its worth it
>> to suggest testing the current version of all fairly recent kernels:
>> 4.5.rc1, 4.4, 4.3.4, 4.2.8, 4.1.16?
>
> I don't have any useful information about parity RAID modes or large
> arrays, so this might be totally useless. Nonetheless, just last week
> I added a 2TB drive to an existing Btrfs raid10 array (5x 2TB before
> addition) and did a balance afterwards. I don't take any numbers, but
> I was frequently looking at htop and iotop. I thought the numbers were
> extremely good: 100-120MB/s sustained for each drive with the "total"
> reported by iotop exceeding 600MB/s. That's with integrated sata
> controller on an Intel Z97 mini-ITX motherboard (cpu i4770).
> Significantly faster than anticipated. I started it one evening, and
> it was finished when I awoke the next morning.
>
> That was on 4.2.8-300.fc23.x86_64 with btrfs-progs 4.3.1.

That's been my experience also with raid0 and 10. Because p+q
computation is more expensive with raid6, it may need specifically
testing with a raid6. If Christian can successfully cancel balance,
umount, then reboot another kernel version and retry, it might be
useful in tracking down the problem (or someone else willing to test).
I'd do it but I don't have enough drive space at the moment to do it
with anything other than VM and qcow2 files on a single SSD, although
that should at least saturate the SSD or close to it. If so, it would
still be faster than what Christian is reporting.


-- 
Chris Murphy
