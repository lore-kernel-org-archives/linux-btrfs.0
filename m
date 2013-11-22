Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42755 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3KVQRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 11:17:34 -0500
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id rAMGHYAI014177
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 11:17:34 -0500
Date: Fri, 22 Nov 2013 11:17:34 -0500 (EST)
From: John Dulaney <jdulaney@redhat.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <1616992290.20969836.1385137054390.JavaMail.root@redhat.com>
In-Reply-To: <20131122142051.GA32192@stefanha-thinkpad.redhat.com>
References: <20131122142051.GA32192@stefanha-thinkpad.redhat.com>
Subject: Fwd: [virt-devel] btrfs NOCOW for VM disk images
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



----- Forwarded Message -----
From: "Stefan Hajnoczi" <stefanha@redhat.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Cc: virt-devel@redhat.com, "Kevin Wolf" <kwolf@redhat.com>
Sent: Friday, November 22, 2013 9:20:51 AM
Subject: [virt-devel] btrfs NOCOW for VM disk images

Hi,
In upstream QEMU we're discussing patches that set the NOCOW flag on
disk image files.  We're told that this increases btrfs performance
greatly since the file system will modify data in-place like ext4/xfs.

During testing I found that the NOCOW flag prevents file cloning from
working.  cp --reflink fails with EINVAL when the source file has the
NOCOW flag set.

It is not possible to toggle NOCOW back and forth later on since it can
only be set when no data has been allocated for the file yet.

This leaves us with the choice between performance (NOCOW) and snapshots
(default).  Both are important for VM disk images!

Questions:

 * Would it be possible to extend btrfs so that cp --reflink works on
   NOCOW files?  (Clueless idea: quiesce I/O to the NOCOW file and clone
   it, then resume I/O and COW only writes to shared blocks.)

 * Does NOCOW prevent any other functionality besides file-level cloning?

 * Does NOCOW increase risk of data loss/corruption?  (I guess yes since
   overwriting in place puts data at risk of power failure or drive
   failure.)

Thanks,
Stefan


-- 
John Dulaney, RHCE
IRC: handsome_pirate
jdulaney.wordpress.com
