Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:46325 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAER14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 12:27:56 -0500
Received: from gardel-login.0pointer.net (gardel.0pointer.net [85.214.157.71])
	by gardel.0pointer.net (Postfix) with ESMTP id 7E639E80F5C
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 18:27:54 +0100 (CET)
Date: Mon, 5 Jan 2015 18:27:54 +0100
From: Lennart Poettering <lennart@poettering.net>
To: linux-btrfs@vger.kernel.org
Subject: RFE: per-subvolume timestamp that is updated on every change to a
 subvolume
Message-ID: <20150105172754.GC19126@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heya!

I am looking for a nice way to query the overall last modification
timestamp of a subvolume. i.e. the most recent mtime of *any* file or
directory within a subvolume. Ideally, I think, there was a
btrfs_timespec field for this in "struct btrfs_root_item", alas there
isn't afaics. Any chance this can be added?

Or is there another workable way to query this value? Maybe determine
it from the current generation of a subvolume or so? Is that tracked?
Ideas?

Lennart
