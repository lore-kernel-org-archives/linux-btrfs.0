Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36908 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbcBJKQE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 05:16:04 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so19773372wme.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 02:16:03 -0800 (PST)
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
To: Mackenzie Meyer <snackmasterx@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
From: Psalle <psalleetsile@gmail.com>
Message-ID: <56BB0DE0.5020102@gmail.com>
Date: Wed, 10 Feb 2016 11:16:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/16 20:36, Mackenzie Meyer wrote:
> RAID 6 stability?
I'll say more: currently, btrfs is in a state of flux where if you don't 
have a very recent kernel that's the first recommendation you're going 
to receive in case of problems. This means going out of stable packages 
in most distros.

Once you're in the bleeding kernel edge, you are obviously more likely 
to run into undiscovered bugs. I even see here people that has to patch 
the kernel with still non-mainline patches when trying to recover.

So don't for anything but testing.
