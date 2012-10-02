Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56013 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2JBTC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 15:02:29 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Tue, 2 Oct 2012 15:02:28 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q92J2PAt162638
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Oct 2012 15:02:25 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q92J2OGe023712
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Oct 2012 15:02:25 -0400
Message-ID: <506B3A3E.1060003@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 12:02:22 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: tytso@mit.edu
CC: "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org
Subject: [e2fsprogs] ext2_dir_entry To ext2_dir_entry_2 Casting
References: <506B31B7.40405@linux.vnet.ibm.com>
In-Reply-To: <506B31B7.40405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Theodore Ts'o,

Is there a function similar to ext2fs_dir_iterate2() that will call a hook
function on an ext2_dir_entry_2 structure and not an ext2_dir_entry
structure?

The reason I ask is because btrfs-convert currently tries to do a cast
between the two structures as such:

	static int dir_iterate_proc(..., struct ext2_dir_entry *old, ...)
	{
	...
		struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;

which works fine on little-endian machines, but breaks on big-endian machines.

If there isn't, would you be interested in a patch that adds a function, say,
ext2_dir_entry_upgrade(struct ext2_dir_entry *old, struct ext2_dir_entry_2 *new)
that will convert one structure to the other and take into account the endianness
of the machine? This would be better than just ad-hoc fixing the code in btrfs.

Thank you,
Wade Cline

