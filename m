Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37142 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933492AbcA0Xrl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 18:47:41 -0500
Received: by mail-ig0-f178.google.com with SMTP id h5so1254498igh.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 15:47:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A8EF4F.7060900@netcologne.de>
References: <56A8EF4F.7060900@netcologne.de>
Date: Wed, 27 Jan 2016 16:47:40 -0700
Message-ID: <CAJCQCtQ6RwedgskkT9EECdj_2aZVEZZhfNwvkqOWztzk-MyKTg@mail.gmail.com>
Subject: Re: Progress indicator when (slowly) mounting a btrfs filesystem?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2016 at 9:24 AM, Christian Rohmann
<crohmann@netcologne.de> wrote:
> Hey btrfs-folks,
>
> when one cuts the power to a machine with an 8 device RAID6 btrfs
> mounted, it takes about 15 - 20 minutes to mount the btrfs again
> afterwards. This is with kernel 4.4 and btrfs-progs 4.4 mind you. I
> looked at iotop and it was reading from all disks heavily, so it was
> doing something. The long mount time for such a rather expected case
> might be a problem in itself, but either way, a mount action that takes
> a while needs to present some sort of progress indication, so the user
> knows what btrfs is at work getting things mounted.

Might be a bug, but more likely might be a lack of optimization. If it
eventually mounts without errors that's a pretty good plus. Lots of
file systems can't handle power failures well at all.

Mount is part of util-linux, not btrfs-progs, so any change would
probably need to be there. I'm not sure the kernel even has an idea
during all of this what the end point is, so a progress indication is
probably not reliable. It's in the clouds on a long staircase, or
maybe it's a short one, who can be sure?


-- 
Chris Murphy
