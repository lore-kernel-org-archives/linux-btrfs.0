Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:60420 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3GHIIu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 04:08:50 -0400
Received: from frontend1.mail.m-online.net (frontend1.mail.intern.m-online.net [192.168.8.180])
	by mail-out.m-online.net (Postfix) with ESMTP id 3bpfSJ6b26z3hhWW
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 10:08:48 +0200 (CEST)
Received: from mail.kuther.net (ppp-46-244-135-46.dynamic.mnet-online.de [46.244.135.46])
	by mail.mnet-online.de (Postfix) with ESMTP id 3bpfSJ2Jdfzbbjy
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 10:08:48 +0200 (CEST)
Received: from kuther.net (kuther.net [192.168.1.2])
	by mail.kuther.net (Postfix) with ESMTPSA id A216A1096EE4
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 10:08:46 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 08 Jul 2013 10:08:46 +0200
From: Thomas Kuther <tom@kuther.net>
To: linux-btrfs@vger.kernel.org
Subject: Qemu disk images on BTRFS suffer checksum errors
Message-ID: <c48018584d78271b5958df996a72207f@kuther.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm about to migrate from VirtualBox to Qemu+VGA-Passthrough. All my 
virtual disk images are stored in a BTRFS subvolume on-top of a MDRAID 
1.
The host runs kernel 3.10, and Qemu 1.5.1. The Testing-VM is a Windows 7 
64bit, using a RAW virtio disk with cache=none, same happens for qcow2, 
though.

Using VirtualBox and in the past Vmware workstation I never had issues 
with corrupted diskimages, but now with Qemu all tries ended up with 
lots of errors like:

[ 4871.863009] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 3817758510 private 402306600
[ 4872.481013] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 3817758510 private 402306600
[ 4904.055514] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 4060166193 private 402306600
[ 4904.748130] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 4060166193 private 402306600
[ 4904.987540] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 3817758510 private 402306600
[ 4905.024700] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 3817758510 private 402306600
[ 4932.497793] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 4060166193 private 402306600
[ 4932.533634] BTRFS info (device md10): csum failed ino 687 off 
46213922816 csum 4060166193 private 402306600

Trying to copy the disk image elsewhere causes I/O errors at some point.

I found a thread about the issue 
(http://comments.gmane.org/gmane.comp.file-systems.btrfs/20538) and also 
a bug report against Qemu from Josef Bacik describing the exact same 
problem: https://bugzilla.redhat.com/show_bug.cgi?id=693530 - Josef 
states it should be fixed since quite a while.

Is this a regression in BTRFS, a problem with my setup (md raid1 layer 
below btrfs), or (still) a bug in Qemu?
Would cache=writethrough or writeback be an option with BTRFS?

Thanks in advance for any input.

Best regards,
Thomas

