Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:53221 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbcHCUUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Aug 2016 16:20:55 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 882839B96E
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 20:56:01 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 6892B5FBA1
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 20:56:01 +0100 (BST)
To: linux-btrfs@vger.kernel.org
From: Graham Cobb <g.btrfs@cobb.uk.net>
Subject: Extents for a particular subvolume
Message-ID: <57A24C51.2050302@cobb.uk.net>
Date: Wed, 3 Aug 2016 20:56:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Are there any btrfs commands (or APIs) to allow a script to create a
list of all the extents referred to within a particular (mounted)
subvolume?  And is it a reasonably efficient process (i.e. doesn't
involve backrefs and, preferably, doesn't involve following directory
trees)?

I am not looking to relate the extents to files/inodes/paths.  My
particular need, at the moment, is to work out how much of two snapshots
is shared data, but I can think of other uses for the information.

Graham
