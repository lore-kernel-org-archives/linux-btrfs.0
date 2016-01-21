Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34418 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbcAUC2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 21:28:36 -0500
Received: by mail-io0-f175.google.com with SMTP id 1so40314863ion.1
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 18:28:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHRikPEe9JVRmBysLQ8r1OhwXsSpfJOXy4EWU8m=egbkt9zE7w@mail.gmail.com>
References: <CAHRikPEe9JVRmBysLQ8r1OhwXsSpfJOXy4EWU8m=egbkt9zE7w@mail.gmail.com>
Date: Wed, 20 Jan 2016 19:28:35 -0700
Message-ID: <CAJCQCtSyc1YAsVgNcPCeA5fW8cofwqSVuF69acZo+GYm2rUx4A@mail.gmail.com>
Subject: Re: Out of space on small-ish partition, clobber and other methods
 haven't worked
From: Chris Murphy <lists@colorremedies.com>
To: Jerry Steinhauer <jerry.steinhauer@singlewire.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 2:22 PM, Jerry Steinhauer
<jerry.steinhauer@singlewire.com> wrote:

> % rm a.file
> rm: cannot remove 'a.file': No space left on device
> % cat /dev/null > a.file
> -sh: a.file: No space left on device
> % btrfs fi df /data
> System, single: total=32.00MiB, used=4.00KiB
> Data+Metadata, single: total=506.00MiB, used=500.39MiB
> GlobalReserve, single: total=12.00MiB, used=6.45MiB


I see somewhere between 6MiB and 12MiB that should be available for
file removal. Since delete is cow, the fs still needs free space. But
I'd think rm would need very little cow metadata space to work and
then free things up.

I can't say for sure but sounds like a bug, or at least an unintended behavior.


> We encountered this on 3.1, so we upgraded as far as our distro would
> take us (yocto) to 4.1.  Same issue persists.

I suggest two things, neither of which fixes the problem:

1. Remount with -o enospc_debug, and reproduce the problem.
2. See if you can go to 4.1.15. There are quite a few Btrfs backports
from the 4.1.8 you're using up until 4.1.15.



-- 
Chris Murphy
