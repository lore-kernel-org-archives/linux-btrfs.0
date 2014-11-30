Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45743 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaK3WGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 17:06:52 -0500
In-Reply-To: <20141130121147.45884217@atmarama>
References: <20141130121147.45884217@atmarama>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: pro/cons of raid1 with mdadm/lvm2
From: Russell Coker <russell@coker.com.au>
Date: Mon, 01 Dec 2014 09:06:19 +1100
To: Gour <gour@atmarama.net>, linux-btrfs@vger.kernel.org
Message-ID: <E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the 2 disks have different data mdadm has no way of knowing which one is correct and has a 50% chance of overwriting good data. But BTRFS does checksums on all reads and solves the problem of corrupt data - as long as you don't have 2 corrupt sectors in matching blocks.
-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.
