Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaJHTLv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Oct 2014 15:11:51 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s98JBoRu028053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 8 Oct 2014 15:11:51 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s98JBnhU025694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 8 Oct 2014 15:11:50 -0400
Message-ID: <54358C77.2070808@redhat.com>
Date: Wed, 08 Oct 2014 14:11:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: What is the vision for btrfs fs repair?
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was looking at Marc's post:

http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html

and it feels like there isn't exactly a cohesive, overarching vision for
repair of a corrupted btrfs filesystem.

In other words - I'm an admin cruising along, when the kernel throws some
fs corruption error, or for whatever reason btrfs fails to mount.
What should I do?

Marc lays out several steps, but to me this highlights that there seem to
be a lot of disjoint mechanisms out there to deal with these problems;
mostly from Marc's blog, with some bits of my own:

* btrfs scrub
	"Errors are corrected along if possible" (what *is* possible?)
* mount -o recovery
	"Enable autorecovery attempts if a bad tree root is found at mount time."
* mount -o degraded
	"Allow mounts to continue with missing devices."
	(This isn't really a way to recover from corruption, right?)
* btrfs-zero-log
	"remove the log tree if log tree is corrupt"
* btrfs rescue
	"Recover a damaged btrfs filesystem"
	chunk-recover
	super-recover
	How does this relate to btrfs check?
* btrfs check
	"repair a btrfs filesystem"
	--repair
	--init-csum-tree
	--init-extent-tree
	How does this relate to btrfs rescue?
* btrfs restore
	"try to salvage files from a damaged filesystem"
	(not really repair, it's disk-scraping)


What's the vision for, say, scrub vs. check vs. rescue?  Should they repair the
same errors, only online vs. offline?  If not, what class of errors does one fix vs.
the other?  How would an admin know?  Can btrfs check recover a bad tree root
in the same way that mount -o recovery does?  How would I know if I should use
--init-*-tree, or chunk-recover, and what are the ramifications of using
these options?

It feels like recovery tools have been badly splintered, and if there's an
overarching design or vision for btrfs fs repair, I can't tell what it is.
Can anyone help me?

Thanks,
-Eric
