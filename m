Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:38753 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbcAVNiO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 08:38:14 -0500
Received: from cc-smtpin2.netcologne.de (cc-smtpin2.netcologne.de [89.1.8.202])
	by cc-smtpout3.netcologne.de (Postfix) with ESMTP id 61AC812685
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 14:38:11 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin2.netcologne.de (Postfix) with ESMTP id 5E52E11E08
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 14:38:11 +0100 (CET)
Received: from [194.8.193.239] (helo=cc-smtpin2.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.9)
	(envelope-from <crohmann@netcologne.de>)
	id 56a230c3-0b77-7f0000012729-7f000001e185-1
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 14:38:11 +0100
Received: from [194.8.193.239] (sys-239.netcologne.de [194.8.193.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin2.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 14:38:11 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Christian Rohmann <crohmann@netcologne.de>
Subject: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one cpu
 core?
Message-ID: <56A230C3.3080100@netcologne.de>
Date: Fri, 22 Jan 2016 14:38:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs-folks,

I am currently doing a big "btrfs balance" to extend a 8 drive RAID6 to
12 drives using
 "btrfs balance start -dstripes 1..11 -mstripes 1..11"

With kernel 4.4 and btrfs progs 4.4 it's running fine for a few days now
and the new disks are slowing getting more and more extents.
But somehow the process is VERY slow (3% in 3 days) and there is almost
no additional disk utilization.

The process doing the balance is doing 100% cpu (one core) so apparently
the whole thing is very much single threaded and therefore CPU-bound in
this case.

Is this a known issue or is there anything I can do to speed this up? I
mean the disks have plenty of iops left to work with and the box has
many more CPU cores idling away.



Regards


Christian

