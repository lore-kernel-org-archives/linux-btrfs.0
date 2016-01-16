Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55537 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbcAPM10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jan 2016 07:27:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aKPwx-0008PF-2B
	for linux-btrfs@vger.kernel.org; Sat, 16 Jan 2016 13:27:23 +0100
Received: from 87-127-115-15.static.enta.net ([87.127.115.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 13:27:23 +0100
Received: from 6401e46d by 87-127-115-15.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 13:27:23 +0100
To: linux-btrfs@vger.kernel.org
From: Al <6401e46d@opayq.com>
Subject: Why is dedup inline, not delayed (as opposed to offline)? Explain like I'm five pls.
Date: Sat, 16 Jan 2016 12:27:16 +0000 (UTC)
Message-ID: <loom.20160116T132316-196@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This must be a silly question! Please assume that I know not much more than
nothing abou*t fs. 
I know dedup is traditionally costs a lot of memory, but I don't really
understand why it is done like that. Let me explain my question:

AFAICT dedup matches file level chunks (or whatever you call them) using a
hash function or something which has limited collision potential. The hash
is used to match blocks as they are committed to disk, I'm talking online
dedup*, and reflink/eliminate the duplicated blocks as necessary.  This
bloody great hash tree is saved in memory for speed of lookup (I assume).

But why?

Is there any urgency for dedup? What's wrong with storing the hash on disk
with the block and having a separate process dedup the written data over
time; dedup'ing data immediately when written to high-write-count data is
counter productive because no sooner has it been deduped then it is rendered
obsolete by another COW write.

There's also the problem of opening a potential problem window before the
commit to disk, hopefully covered by the journal, whilst we seek the
relevant duplicate if there is one.

Help me out peeps? Why is there a such an urgency to have online dedup,
rather than a triggered/delayed dedup, similar the current autodefrag process?

Thank you. I'm sure the answer is obvious, but not to me!

* dedup/dedupe/deduplication 




