Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36919 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbHRRjO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 13:39:14 -0400
Received: by igui7 with SMTP id i7so85585172igu.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 10:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8CM59URzw1VzpbZEKCTKSakwaRyv0NJ9N0vV3dVyFC9g@mail.gmail.com>
References: <CAK7bmU8CM59URzw1VzpbZEKCTKSakwaRyv0NJ9N0vV3dVyFC9g@mail.gmail.com>
Date: Tue, 18 Aug 2015 13:39:13 -0400
Message-ID: <CAK7bmU8eJz+k7ZryS_d6Rx_64S87mm__w9OxeAO7Hx=a2jSQoA@mail.gmail.com>
Subject: Re: chattr +C on subvolume
From: Timothy Normand Miller <theosib@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another weird thing I've noticed.  I did this:

chattr +C /mnt/btrfs/vms

But both of these report nothing:

lsattr /mnt/btrfs/vms
lsattr /mnt/vms

Shouldn't at least one show the C attribute?


On Tue, Aug 18, 2015 at 1:36 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> Maybe this is a dumb question, but there are always corner cases.
>
> I have a subvolume where I want to disable CoW for VM disks.  Maybe
> that's a dumb idea, but that's a recommendation I've seen here and
> there.  Now, in the docs I've seen, +C applies to a directory.  Does
> it apply to subvolumes?  And do I apply it to the subvolume within the
> main volume, or do I apply it to the mount point where I've mounted
> the subvolume separately?  Are there any cases where the flag applies
> or not depending on how you access the files?
>
> The same subvolume for me is accessible via /mnt/btrfs/vms (via the
> /mnt/btrfs mount point) and /mnt/vms (where the subvolume is mounted).
> I applied +C to /mnt/btrfs/vms.  So what I'm trying to find out is if
> it also applies when files are accessed via /mnt/vms.
>
> Thanks.
>
>
> --
> Timothy Normand Miller, PhD
> Assistant Professor of Computer Science, Binghamton University
> http://www.cs.binghamton.edu/~millerti/
> Open Graphics Project



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
