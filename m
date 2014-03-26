Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.zenoss.com ([74.63.38.26]:33991 "EHLO zimbra1.zenoss.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbaCZUlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 16:41:46 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra1.zenoss.com (Postfix) with ESMTP id 9F3037E8342
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Mar 2014 16:33:28 -0400 (EDT)
Received: from zimbra1.zenoss.com ([127.0.0.1])
	by localhost (zimbra1.zenoss.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8VavP-FXIgTK for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Mar 2014 16:33:25 -0400 (EDT)
Received: from zimbra1.zenoss.com (zimbra1.zenoss.com [74.63.38.26])
	by zimbra1.zenoss.com (Postfix) with ESMTP id 769087E833D
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Mar 2014 16:33:25 -0400 (EDT)
Date: Wed, 26 Mar 2014 16:33:25 -0400 (EDT)
From: Evan Powell <epowell@zenoss.com>
To: linux-btrfs@vger.kernel.org
Subject: Some impossible benchmark results with LUKS - what am I missing?
Message-ID: <33f1e655-353f-4713-b508-7a15b90432b7@zimbra1.zenoss.com>
In-Reply-To: <b79dabff-f858-4380-914f-7c6e6da42534@zimbra1.zenoss.com>
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey folks,

I have been experimenting with btrfs on a home NAS box, and have some benchmark results that I don't believe. I'm hoping someone here has some insight on what I've missed that would cause such a result.

The short version: I'm seeing roughly a 36% (on write) to 55% (on read) performance *improvement* when using btrfs on LUKS containers over btrfs on raw disks. This should not be the case!

The test setup:
My test file is a large file that I previously generated from /dev/urandom. I saw similar results using /dev/zero as input, as well as a repeated copy of the whole Ubuntu 14.04 ISO (i.e., real-ish data).

My calculated MB/s numbers are based on the 'real' time in the output.

Live-booted Ubuntu 14.04 (nightly from 3/11/14, kernel 3.13.5)
4x 4TB WD Red drives in standard (no RAID) configuration
i3-4130 CPU (has AES-NI for accelerated encryption)
Default BTRFS options from the disk gui, always raid10.

Tested configurations:
Raw: btrfs raid10 on 4x raw drives
Encrypted: btrfs raid10 on 4 separate LUKS containers on 4x raw drives (default LUKS options)


Read command: $ time sh -c "dd if=test.out of=/dev/null bs=4k"
Raw:
5120000+0 records in
5120000+0 records out
20971520000 bytes (21 GB) copied, 149.841 s, 140 MB/s

real	2m29.849s
user	0m2.764s
sys	0m7.064s

= 133.467690809 MB/s

Encrypted:
$ time sh -c "dd if=test2.out of=/dev/null bs=4k"
5120000+0 records in
5120000+0 records out
20971520000 bytes (21 GB) copied, 96.6127 s, 217 MB/s

real	1m36.627s
user	0m3.331s
sys	0m9.518s

= 206.981485506 MB/s


Read+Write: $ time sh -c "dd if=test2.out of=test20grand.out bs=4k && sync"
Raw:
5120000+0 records in
5120000+0 records out
20971520000 bytes (21 GB) copied, 227.069 s, 92.4 MB/s

real	3m49.701s
user	0m2.854s
sys	0m15.936s

= 87.069712365 MB/s

Encrypted:
5120000+0 records in
5120000+0 records out
20971520000 bytes (21 GB) copied, 167.823 s, 125 MB/s

real	2m48.784s
user	0m2.955s
sys	0m17.956s

= 118.494644042 MB/s


Any ideas what could explain this result?

One coworker suggested that perhaps the LUKS container was returning from 'sync' early, before actually finishing the write to disk. This would seem to violate the assumptions of the 'sync' primitive, so I have my doubts.

I'm also interested in learning how I can reliably benchmark the real cost of running full-disk encryption under btrfs on my system.

Thanks!


Evan Powell | Technical Lead 
epowell@zenoss.com 
