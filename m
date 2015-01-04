Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:59049 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbADXYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 18:24:15 -0500
Received: by mail-yh0-f54.google.com with SMTP id 29so10817150yhl.41
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 15:24:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ac53d9eeb92abf031b2b68c1b130215@pl1.haspere.com>
References: <4ac53d9eeb92abf031b2b68c1b130215@pl1.haspere.com>
Date: Sun, 4 Jan 2015 16:24:14 -0700
Message-ID: <CAJCQCtSqTzOywjiZXeSdrw2nLYzyMZBnWSMmzbtVgeZthizv4w@mail.gmail.com>
Subject: Re: BTRFS: Transaction aborted (error -5)
From: Chris Murphy <lists@colorremedies.com>
To: Y4BwxfPC4k5h@dyweni.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 4, 2015 at 7:50 AM, Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com> wrote:
> Hi All,
>
> Just wondering of a few things:
>
> 1. Has anyone seen a problem like this before (see below)?  This occurs when
> mounting the file system.  It mounts, but goes straight to read-only mode.
> 2. I've scanned the device (/dev/sdd) using 'badblocks -s v', which reports
> no bad blocks found.
> 3. What can be done to recover from this?  (I'm planning to upgrade to 3.18
> before trying recovery/repairs)

Try to mount with -o recovery with either kernel (newer is pretty much
always better). If that doesn't work then you should try upgrading
btrfs-progs to 3.18 (released dozens of hours ago) and run 'btrfs
check' on the volume and report the results. I don't recommend using
--repair option just yet.


> [32079.815291] BTRFS info (device sdd1): disk space caching is enabled
> [32082.419524] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 6E0D3115 level 0
> [32114.418433] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 6E0D3115 level 0
> [32125.951446] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 6E0D3115 level 0
> [32125.959497] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 24492BB3 level 0

Well I'm no expert, but it seems suspicious to me it doesn't find what
it wants on a particular block twice, but then on the 3rd attempt it
finds something different on the same block which also isn't what it
wants. So that sounds like a device problem to me. Is this an SSD?
What are your mount options (are you using discard)? And what's the
metadata profile, is it single or DUP? I'm gonna guess it's an SSD
with single copy of metadata which is why this isn't self-correcting.


-- 
Chris Murphy
