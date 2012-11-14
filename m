Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:62759 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab2KNWkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 17:40:03 -0500
Received: from extserver.intern.prnet.org (ip-213-135-240-128.static.luxdsl.pt.lu [213.135.240.128])
	by extserver1.prnet.org (8.14.5/8.14.5) with ESMTP id qAEMYPEG006215
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 23:34:26 +0100 (CET)
	(envelope-from admin@prnet.org)
Received: from [192.168.1.1] (server.intern.prnet.org [192.168.1.1])
	(authenticated bits=0)
	by extserver.intern.prnet.org (8.14.4/8.14.4) with ESMTP id qAEMYPhC011199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 23:34:25 +0100
Message-ID: <50A41C71.1060504@prnet.org>
Date: Wed, 14 Nov 2012 23:34:25 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive symlink bug
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using kernel 3.7.0-rc5 and latest btrfs-progs git.

I am trying btrfs send/receive. When I have a filesystem containing a
symlink pointing to a nonexistent destination or a destination created
after the symlink was created, btrfs receive aborts with: ERROR: chown
link1.txt failed. No such file or directory.

Steps to reproduce (/dev/loop0 and /dev/loop1 are test images):

mkfs.btrfs /dev/loop0
mount /dev/loop0 /u00
btrfs subvolume create /u00/test
cd /u00/test
ln -s test1.txt link1.txt
btrfs subvolume snapshot -r /u00/test /u00/test.snapshot
mkfs.btrfs /dev/loop1
mount /dev/loop1 /u01
btrfs send /u00/test.snapshot | btrfs receive /u01
ERROR: chown link1.txt failed. No such file or directory

Bye,
David Arendt

