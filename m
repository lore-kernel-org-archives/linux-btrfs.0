Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33374 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbcHKUXr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 16:23:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id o80so1354193wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 13:23:46 -0700 (PDT)
MIME-Version: 1.0
From: Dave T <davestechshop@gmail.com>
Date: Thu, 11 Aug 2016 16:23:45 -0400
Message-ID: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Duncan <1i5t5.duncan@cox.net>
Cc: Nicholas D Steeves <nsteeves@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What I have gathered so far is the following:

1. my RAM is not faulty and I feel comfortable ruling out a memory
error as having anything to do with the reported problem.

2. my storage device does not seem to be faulty. I have not figured
out how to do more definitive testing, but smartctl reports it as
healthy.

3. this problem first happened on a normally running system in light
use. It had not recently crashed. But the root fs went read-only for
an unknown reason.

4. the aftermath of the initial problem may have been exacerbated by
hard resetting the system, but that's only a guess

> The compression-related problem is this:  Btrfs is considerably less tolerant of checksum-related errors on btrfs-compressed data

I'm an unsophisticated user. The argument in support of this statement
sounds convincing to me. Therefore, I think I should discontinue using
compression. Anyone disagree?

Is there anything else I should change? (Do I need to provide
additional information?)

What can I do to find out more about what caused the initial problem.
I have heard memory errors mentioned, but that's apparently not the
case here. I have heard crash recovery mentioned, but that isn't how
my problem initially happened.

I also have a few general questions:

1. Can one discontinue using the compress mount option if it has been
used previously? What happens to existing data if the compress mount
option is 1) added when it wasn't used before, or 2) dropped when it
had been used.

2. I understand that the compress option generally improves btrfs
performance (via Phoronix article I read in the past; I don't find the
link). Since encryption has some characteristics in common with
compression, would one expect any decrease in performance from
dropping compression when using btrfs on dm-crypt? (For more context,
with an i7 6700K which has aes-ni, CPU performance should not be a
bottleneck on my computer.)

3. How do I find out if it is appropriate to use dup metadata on a
Samsung 950 Pro NVMe drive? I don't see deduplication mentioned in the
drive's datasheet:
http://www.samsung.com/semiconductor/minisite/ssd/downloads/document/Samsung_SSD_950_PRO_Data_Sheet_Rev_1_2.pdf

4. Given that my drive is not reporting problems, does it seem
reasonable to re-use this drive after the errors I reported? If so,
how should I do that? Can I simply make a new btrfs filesystem and
copy my data back? Should I start at a lower level and re-do the
dm-crypt layer?

5. Would most of you guys use btrfs + dm-crypt on a production file
server (with spinning disks in JBOD configuration -- i.e., no RAID).
In this situation, the data is very important, of course. My past
experience indicated that RAID only improves uptime, which is not so
critical in our environment. Our main criteria is that we should never
ever have data loss. As far as I understand it, we do have to use
encryption.

Thanks for the discussion so far. It's very educational for me.
