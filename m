Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailsrv.ikr.uni-stuttgart.de ([129.69.170.2]:38496 "EHLO
	mailsrv.ikr.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712AbbEQPcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 11:32:55 -0400
Received: from netsrv1.ikr.uni-stuttgart.de (netsrv1-c [10.11.12.12])
	by mailsrv.ikr.uni-stuttgart.de (Postfix) with ESMTP id 9AE1060141
	for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 17:23:52 +0200 (CEST)
Received: from vpn-2-cl144 (vpn-2-cl144 [10.41.21.144])
	by netsrv1.ikr.uni-stuttgart.de (Postfix) with ESMTP id 871A76013B
	for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 17:23:52 +0200 (CEST)
From: Ulrich Gemkow <ulrich.gemkow@ikr.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: NFSv3-mounting of BTRFS-FS fails, gives ESTALE
Date: Sun, 17 May 2015 17:23:45 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201505171723.47140.ulrich.gemkow@ikr.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

we export a BTRFS-filesystem via NFSv3 and tried to mount
this share on a client (also NFSv3). The mount program on the
client hangs and the mount fails.

Server and client use vanilla Linux kernel 4.0.3, the distro
is Ubuntu 14.04.02, btrfs-progs are version 4.0.

Exporting of other filesystems (ext4) and mounting them in
the exactly same setup works, so this seems to be BTRFS-related.

strace-ing the mount-call on the client shows that the mount
syscall returns ESTALE errors and mount enters a loop which
leads to the hang of the mount-program in user land.

I applied the patch of Neil Brown (which should help with
NFS v2) in [1]. The behaviour without and with this patch
is the same.

This seems to be a regression because from the lists I
saw that NFS-exporting of BTRFS is supposed to work
(but NFSv3 is not explicitely mentioned there).

Is this a bug? I am more than willing to help with more
diagnosis.

Thank you and best regards

Ulrich



[1] https://lkml.org/lkml/2015/5/7/1013

-- 
|-----------------------------------------------------------------------
| Ulrich Gemkow
| University of Stuttgart, Germany
| Institute of Communication Networks and Computer Engineering (IKR)
|-----------------------------------------------------------------------
