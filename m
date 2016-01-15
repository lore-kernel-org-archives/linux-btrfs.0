Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa65.mailout.artfiles.de ([212.72.176.65]:52324 "EHLO
	mailout-afa65.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbcAOIsI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 03:48:08 -0500
Received: from [132.230.80.54] (helo=discus.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1aJzoq-0007qx-Cg
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 09:33:16 +0100
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Recursive delete file from all subvolumes (snapshots)
Date: Fri, 15 Jan 2016 09:33:14 +0100
Message-ID: <15624885.ucZm0n36hp@discus>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I have a btrfs raid 10 from which I take hourly snapshots using snapper. Now, 
I wonder, if there is a way to delete a file together with all its occurrences 
in all snapshots.

My use case is, that the file I want to delete is large, and I want to free its 
space on disk. Thus, I have to get rid of its "live" version but also of all 
references to it in snapshots.

Thank,
Wolfgang
