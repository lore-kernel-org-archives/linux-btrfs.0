Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44735 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJFTCI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 15:02:08 -0400
Received: from extserver.intern.prnet.org (extserver.prnet.org [192.168.11.2])
	by extserverfr1.prnet.org (8.14.9/8.14.9) with ESMTP id s96IrLwr018139
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Oct 2014 20:53:22 +0200
Received: from [192.168.1.1] (server.intern.prnet.org [192.168.1.1])
	(authenticated bits=0)
	by extserver.intern.prnet.org (8.14.9/8.14.9) with ESMTP id s96IoEHV007328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Oct 2014 20:50:15 +0200
Message-ID: <5432E466.9070604@prnet.org>
Date: Mon, 06 Oct 2014 20:50:14 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs send and kernel 3.17
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

After upgrading to kernel 3.17 btrfs send has stopped working.

ERROR: send ioctl failed with -5: Input/output error

The following message is printed by kernel:

[75322.782197] BTRFS error (device sda2): did not find backref in
send_root. inode=461, offset=0, disk_byte=1094713344 found extent=1094713344

btrfs inspect-internal inode-resolve -v 461 /u00/root.snapshot returns:

/var/log/emerge-fetch.log

After removing this file, the error moves on to another file.

btrfs scrub output:

scrub status for bc31b068-2c36-4ff2-ac5c-7ce55af5371d
    scrub started at Mon Oct  6 19:49:25 2014 and finished after 1748
seconds
    total bytes scrubbed: 94.21GiB with 0 errors

Other then the btrfs send problem, the filesystem works normally.

Is this a bug in btrfs-send or is my filesystem corrupted and should be
restored from backup ?

Please tell me if I can do anything else to help debugging this issue.

Thanks in advance,
David Arendt
