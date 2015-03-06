Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33743 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbbCFAaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 19:30:15 -0500
Received: by igbhl2 with SMTP id hl2so231415igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2015 16:30:14 -0800 (PST)
MIME-Version: 1.0
From: Paul Harvey <csirac2@gmail.com>
Date: Fri, 6 Mar 2015 11:29:53 +1100
Message-ID: <CAB3_QuJVGezacw-yYqbfr2LHzF_Em4k1XFys02KMHemh1-sMsw@mail.gmail.com>
Subject: unstable atimes on empty dirs in read-only snapshots which were
 subvol parents
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Apologies for not confirming on a much more recent kernel, if anyone
could please try my test script for me on a newer kernel that would be
very much appreciated.

I'm working on reproducible builds, and part of this workflow involves
tar archiving parts of read-only btrfs snapshots. Problem is, some of
these tar archives are different from run to run when they capture an
empty directory that happened to be a subvol parent on the original
FS: the atimes on these empty dirs are always returning the current
time - which is not the case with an ordinary empty directory created
with mkdir; it's also not the same behaviour on the original FS (tar
archives are reproducible if we use the original FS rather than the
read-only snapshot). This all happens regardless of mounting noatime.

Perhaps this verbiage is convoluted, I'm writing this in a hurry with
limited internet connectivity - I have a reproducible test case here
at https://gist.github.com/csirac2/c2b5b2b9d0193b3c08a8

Again, I understand this is a pretty old kernel and perhaps this is
fixed by now, I'll try a more recent kernel with more assertive bug
report next week if nobody has time to try out my test case.

Cheers

--
Paul Harvey
