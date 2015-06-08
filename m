Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phd-imap.ethz.ch ([129.132.80.51]:41211 "EHLO phd-imap.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbbFHNMr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jun 2015 09:12:47 -0400
Received: from localhost (phd-mailscan.ethz.ch [192.168.127.2])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 3m4vxS49PBzh71
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2015 15:07:08 +0200 (CEST)
Received: from phd-mxin.ethz.ch ([IPv6:::ffff:192.168.127.53])
	by localhost (phd-mailscan.ethz.ch [::ffff:192.168.127.2]) (amavisd-new, port 10024)
	with LMTP id C158VHOzomu9 for <linux-btrfs@vger.kernel.org>;
	Mon,  8 Jun 2015 15:07:08 +0200 (CEST)
Received: from [192.33.96.28] (auror.ethz.ch [192.33.96.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: schmid@phd-mxin.ethz.ch)
	by phd-mxin.ethz.ch (Postfix) with ESMTPSA id 3m4vxS2r7FzQ4j
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2015 15:07:08 +0200 (CEST)
Message-ID: <5575937C.4040805@phys.ethz.ch>
Date: Mon, 08 Jun 2015 15:07:08 +0200
From: Patrick Schmid <schmid@phys.ethz.ch>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-progs: btrfs replace status show 139,3% done
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I started a disk replacement around 11:00 with following command:

	btrfs replace start /dev/iscsi/diskA /dev/diskB /export/backup

The disks has a size of 10TiB.

Now (15:00)i`ve checked the status and get

	btrfs replace status -1 /export/backup/
	143.7% done, 0 write errs, 0 uncorr. read errs

but it`s still running.

I use btrfs-progs version 4.0.1 (master) from
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

and im running a 4.1.-rc5 kernel from
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git

I there a factor error in cmds-replace.c on progress2string or something
else?

Regards Patrick
-- 
Patrick Schmid  <schmid@phys.ethz.ch>     support: +41 44 633 2668
IT Services Group, HPT H 8                voice:   +41 44 633 3997
Departement Physik, ETH Zurich
CH-8093 Zurich, Switzerland
