Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf5.bahnhof.se ([213.80.101.29]:54439 "EHLO mxf5.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbbCCL5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 06:57:45 -0500
Received: from localhost (mxf5.local [127.0.0.1])
	by mxf5-reinject (Postfix) with ESMTP id 6D2FF95CA7A
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2015 12:57:43 +0100 (CET)
Received: from mxf5.bahnhof.se ([127.0.0.1])
	by localhost (mxf5.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BL0bj+cd0jCb for <linux-btrfs@vger.kernel.org>;
	Tue,  3 Mar 2015 12:57:37 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf5.bahnhof.se (Postfix) with ESMTP id 0692295CA72
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2015 12:57:36 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YSlSC-0002yg-Gl
	for linux-btrfs@vger.kernel.org; Tue, 03 Mar 2015 12:57:36 +0100
Date: Tue, 3 Mar 2015 12:57:36 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
In-Reply-To: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
Message-ID: <alpine.DEB.2.02.1503031249060.3687@miria.naju.se>
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch passes `make test', and I have also tested the patched
btrfs-convert on populated ext4 filesystems and reverting back again,
without errors; but note that I have very little experience with ext2/3/4
and btrfs, so there is a large possibility that I have missed something.
I'm also a bit unsure if my implementation of `ext2_alloc_block_range' is
the best way to find continuous blocks.

-- 
Sebastian Thorarensen
