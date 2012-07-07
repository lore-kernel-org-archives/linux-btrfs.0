Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail49.e.nsc.no ([193.213.115.49]:33070 "EHLO mail49.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2GGTKo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Jul 2012 15:10:44 -0400
Received: from [10.0.0.22] (ti0036a380-dhcp0506.bb.online.no [88.89.32.253])
	by mail49.nsc.no (8.14.4/8.14.4) with ESMTP id q67ItCLp016287
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sat, 7 Jul 2012 20:55:14 +0200 (MEST)
Message-ID: <4FF88610.80101@middelthun.no>
Date: Sat, 07 Jul 2012 20:55:12 +0200
From: =?ISO-8859-1?Q?=D8ystein_S=E6ttem_Middelthun?=
	<oystein@middelthun.no>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Failed tree root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

After a short loss of contact with an underlying disk controller my 
btrfs partition is unmountable.

dmesg provides the following information:

[356850.853787] btrfs bad tree block start 0 14102771924992
[356850.853808] btrfs: failed to read tree root on dm-0
[356850.859218] btrfs: open_ctree failed

Is this type of error known to be fixable by the unstable btrfsck 
(20120328)? I am currently running kernel 3.2.0-25.

-- 
Best regards
Øystein Middelthun

