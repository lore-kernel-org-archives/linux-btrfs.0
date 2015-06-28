Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f46.google.com ([209.85.216.46]:36126 "EHLO
	mail-vn0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbF1QdV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 12:33:21 -0400
Received: by vnbg1 with SMTP id g1so21214658vnb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 09:33:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <558EC1F4.1050301@profihost.ag>
References: <558EC1F4.1050301@profihost.ag>
Date: Sun, 28 Jun 2015 10:33:19 -0600
Message-ID: <CAJCQCtTFsAXz1WoM=nYrVUdQOZnhN_G3AYE0BXW2qqz5wnOUSA@mail.gmail.com>
Subject: Re: kernel 4.1: no space left on device
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 27, 2015 at 9:32 AM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> Hi,
>
> while having some big btrfs volumes (44TB + 37TB).
>
> I see on a regular basis the "no space left on device" message. I'm only
> able to "fix" this. By running btrfs balance AND unmounting and remounting
> the btrfs volume.
>
> Is there any way to debug / workaround this one?

What kernel version?
Have you tried to reproduce with a newer kernel and an older kernel? I
suggest trying 4.1 for newer, and at oldest 3.18.16 for regression
testing.
You see the message where/when?
And what's the workload happening at the time?
 If you pause/stop that work load, can you reproduce it by by cp'ing
some files? Does it happen with small files (less than 16KB) or medium
(100MB) or large (1+GB) files, or always?
About how many snapshots or reflink'd large files?


If it were me, after the above upgrade and regression testing, I'd do
the following and add all information thus far (version of kernel, and
btrfs-progs, and the workflow description) to a bugzilla.kernel.org
bug and *attach* the long output results as files to that bug:

1. btrfs check, without --repair, attach complete output to bug
2. mount with option enospc_debug
3. strace cp to reproduce the problem, attach output to bug
4. dmesg from the time of mount at #2, through the end of the strace
in 3, attach output to bug
5. remount with option clear_cache and see if you can reproduce the problem



-- 
Chris Murphy
