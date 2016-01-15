Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender153-mail.zoho.com ([74.201.84.153]:22139 "EHLO
	sender153-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbcAOJP4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:15:56 -0500
To: linux-btrfs@vger.kernel.org
From: Diagon <kernel.boxy@xoxy.net>
Subject: Copying between lzo compressed BtrFS's: de/re-compressing.
Message-ID: <5698B534.4040202@xoxy.net>
Date: Fri, 15 Jan 2016 01:00:36 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm copying a large number of files between two lzo compressed BtrFS
filesystems on different drives mounted on the same machine. It appears
that the files are being de/re-compressed. Is there a way avoid this?

Thanks
/D

