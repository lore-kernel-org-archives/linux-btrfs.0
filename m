Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56167 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbaAIQtt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 11:49:49 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so3385925pdj.23
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 08:49:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	<20140109104247.GH15634@carfax.org.uk>
	<pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
	<52CE9B9C.2040006@gmail.com>
	<pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net>
Date: Thu, 9 Jan 2014 17:49:48 +0100
Message-ID: <CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com>
Subject: Re: How does btrfs handle bad blocks in raid1?
From: George Eleftheriou <eleftg@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan,

As a silent reader of this list (for almost a year)...
As an anonymous supporter of the BAARF (Battle Against Any RAID
Four/Five/Six/ Z etc...) initiative...

I can only break my silence and applaud your frequent interventions
referring to N-Way mirroring (searching the list for the string
"n-way" brings up almost exclusively your posts, at least in recent
times).

Because that's what I' m also eager to see implemented in BTRFS and
somehow felt disappointed that it wasn't given priority over the
parity solutions...

I currently use ZFS on Linux in a 4-disk RAID10 (performing pretty
good by the way) being stuck with the 3.11 kernel because of DKMS
issues and not being able to share by SMB or NFS because of some bugs.

I'm really looking forward to the day that typing:

mkfs.btrfs -d raid10 -m raid10  /dev/sd[abcd]

will do exactly what is expected to do. A true RAID10 resilient in 2
disks' failure. Simple and beautiful.

We're almost there...

Best regards to all BTRFS developers/contributors
