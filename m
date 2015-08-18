Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38067 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbbHRRgh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 13:36:37 -0400
Received: by igfj19 with SMTP id j19so85902601igf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 10:36:37 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Aug 2015 13:36:37 -0400
Message-ID: <CAK7bmU8CM59URzw1VzpbZEKCTKSakwaRyv0NJ9N0vV3dVyFC9g@mail.gmail.com>
Subject: chattr +C on subvolume
From: Timothy Normand Miller <theosib@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe this is a dumb question, but there are always corner cases.

I have a subvolume where I want to disable CoW for VM disks.  Maybe
that's a dumb idea, but that's a recommendation I've seen here and
there.  Now, in the docs I've seen, +C applies to a directory.  Does
it apply to subvolumes?  And do I apply it to the subvolume within the
main volume, or do I apply it to the mount point where I've mounted
the subvolume separately?  Are there any cases where the flag applies
or not depending on how you access the files?

The same subvolume for me is accessible via /mnt/btrfs/vms (via the
/mnt/btrfs mount point) and /mnt/vms (where the subvolume is mounted).
I applied +C to /mnt/btrfs/vms.  So what I'm trying to find out is if
it also applies when files are accessed via /mnt/vms.

Thanks.


-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
