Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [65.55.88.13] ([65.55.88.13]:51033 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2LERoO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 12:44:14 -0500
From: Thorn Roby <Thorn.Roby@harlandfs.com>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Mounted compress-force=zlib, compresses when files copied in,
 but not when written directly by application
Date: Wed, 5 Dec 2012 17:42:51 +0000
Message-ID: <6726B0D4C83B3047A636A714BAB0B92306C5A4@DSM-SRV-MBX2.harlandfs.com>
References: <loom.20121204T201625-335@post.gmane.org>
 <20121205020131.GA5204@liubo>
In-Reply-To: <20121205020131.GA5204@liubo>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My previous reply was incorrect in one point - the data is never copied from the transaction log into the sparse datafiles, instead the application writes the same data independently to both locations.
Also, I failed to mention that the files are memmapped, and it's possible that the write operations attempt to use DIRECT_IO, which I believe is disabled by btrfs with compression - is it possible that an attempt to use DIRECT_IO or memmapped files would prevent compression?

