Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:37964 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2ICOdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2012 10:33:04 -0400
Received: from [192.168.24.208] (droopy.dyn.ducie.codethink.co.uk [192.168.24.208])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTPSA id DF27F4625C4
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Sep 2012 15:25:39 +0100 (BST)
Message-ID: <5044BD53.5080106@codethink.co.uk>
Date: Mon, 03 Sep 2012 15:23:15 +0100
From: Sam Thursfield <sam.thursfield@codethink.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Advice on FS corruption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I've been running btrfs in various VMs for a while, and periodically 
I've experienced corruption in the filesystems being used. None of the 
data is important, but I'd like to track down how the corruption 
occurred in the first place.

Trying to mount any of the corrupt filesystems fails with an error of 
this form:

[   47.805146] device label baserock devid 1 transid 90 /dev/sdb1
[   47.810073] btrfs: disk space caching is enabled
[   47.817261] parent transid verify failed on 1636728832 wanted 76 found 95
[   47.818081] parent transid verify failed on 1636728832 wanted 76 found 95
[   47.818522] Failed to read block groups: -5
[   47.826103] btrfs: open_ctree failed

This is with Linux master as of 29/Aug/2012, so including the latest 
'for-linus' branch from the btrfs tree. Attempts to run btrfs-debug-tree 
on the disk images fail with the same error, and btrfsck segfaults.

I've not yet been able to reliably reproduce the cause of the 
corruption, but I know that in at least one case the VM was compiling 
code and then had a forced power-off. However, in at least one case the 
corruption appeared after a clean shut down. I have a suspicion that it 
may be linked with suspending the host machine and thus causing weird 
things to happen to time in the VM's universe, since btrfs has been 
working fine with the same kernel in a VM on a machine that is never 
suspended or powered off, but I've not yet managed to prove anything.

I'll keep trying to reproduce the issue, in the mean time I'm interested 
how common this sort of issue is and if anyone has any tips for 
repairing the image, or if there is work in progress to prevent or fix 
the corruption.

Thanks
Sam
