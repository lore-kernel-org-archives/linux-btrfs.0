Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:52295 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbbI0Pnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 11:43:51 -0400
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
	by mail.bouton.name (Postfix) with ESMTP id DED3EB943
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Sep 2015 17:34:50 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Subject: btrfs fi defrag interfering (maybe) with Ceph OSD operation
Message-ID: <56080C9A.6030102@bouton.name>
Date: Sun, 27 Sep 2015 17:34:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we use BTRFS for Ceph filestores (after much tuning and testing over
more than a year). One of the problem we've had to face was the slow
decrease in performance caused by fragmentation.

Here's a small recap of the history for context.
Initially we used internal journals on the few OSDs where we tested
BTRFS, which meant constantly overwriting 10GB files (which is obviously
bad for CoW). Before using NoCoW and eventually moving the journals to
raw SSD partitions, we understood autodefrag was not being effective :
the initial performance on a fresh, recently populated OSD was great and
slowly degraded over time without access patterns and filesystem sizes
changing significantly.
My idea was that autodefrag might focus its efforts on files not useful
to defragment in the long term. The obvious one was the journal
(constant writes but only read again when restarting an OSD) but I
couldn't find any description of the algorithms/heuristics used by
autodefrag so I decided to disable it and develop our own
defragmentation scheduler. It is based on both a slow walk through the
filesystem (which acts as a safety net over one week period) and a
fatrace pipe (used to detect recent fragmentation). Fragmentation is
computed from filefrag detailed outputs and it learns how much it can
defragment files with calls to filefrag after defragmentation (we
learned compressed files and uncompressed files don't behave the same
way in the process so we ended up treating them separately).
Simply excluding the journal from defragmentation and using some basic
heuristics (don't defragment recently written files but keep them in a
pool then queue them and don't defragment files below a given
fragmentation "cost" were defragmentation becomes ineffective) gave us
usable performance in the long run. Then we successively moved the
journal to NoCoW files and SSDs and disabled Ceph's use of BTRFS
snapshots which were too costly (removing snapshots generated 120MB of
writes to the disks and this was done every 30s on our configuration).

In the end we had a very successful experience, migrated everything to
BTRFS filestores that were noticeably faster than XFS (according to Ceph
metrics), detected silent corruption and compressed data. Everything
worked well until this morning.

I woke up to a text message signalling VM freezes all over our platform.
2 Ceph OSDs died at the same time on two of our servers (20s appart)
which for durability reason freezes writes on the data chunks shared by
these two OSDs.
The errors we got in the OSD logs seem to point to an IO error (at least
IIRC we got a similar crash on an OSD where we had invalid csum errors
logged by the kernel) but we couldn't find any kernel error and btrfs
scrubs finished on the filesystems without finding any corruption. I've
yet to get an answer for the possible contexts and exact IO errors. If
people familiar with Ceph read this here's the error on Ceph 0.80.9
(more logs available on demand) :

2015-09-27 06:30:57.373841 7f05d92cf700 -1 os/FileStore.cc: In function
'virtual int FileStore::read(coll_t, const ghobject_t&, uint64_t,
size_t, ceph::bufferlist&, bool)' thread 7f05d92cf700 time 2015-09-27
06:30:57.260978
os/FileStore.cc: 2641: FAILED assert(allow_eio || !m_filestore_fail_eio
|| got != -5)

Given that the defragmentation scheduler treats file accesses the same
on all replicas to decide when triggering a call to "btrfs fi defrag
<file>", I suspect this manual call to defragment could have happened on
the 2 OSDs affected for the same file at nearly the same time and caused
the near simultaneous crashes.

It's not clear to me that "btrfs fi defrag <file>" can't interfere with
another process trying to use the file. I assume basic reading and
writing is OK but there might be restrictions on unlinking/locking/using
other ioctls... Are there any I should be aware of and should look for
in Ceph OSDs? This is on a 3.8.19 kernel (with Gentoo patches which
don't touch BTRFS sources) with btrfs-progs 4.0.1. We have 5 servers on
our storage network : 2 are running a 4.0.5 kernel and 3 are running
3.8.19. The 3.8.19 servers are waiting for an opportunity to reboot on
4.0.5 (or better if we have the time to test a more recent kernel before
rebooting : 4.1.8 and 4.2.1 are our candidates for testing right now).

Best regards,

Lionel Bouton
