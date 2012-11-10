Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36576 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2KJWOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Nov 2012 17:14:49 -0500
Received: from mfilter3-d.gandi.net (mfilter3-d.gandi.net [217.70.178.133])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 1C9E3A808D
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Nov 2012 23:14:48 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter3-d.gandi.net (mfilter3-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id DaW3MI9qEhCm for <linux-btrfs@vger.kernel.org>;
	Sat, 10 Nov 2012 23:14:46 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-156-1-39-117.w90-0.abo.wanadoo.fr [90.0.70.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id D05CEA808A
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Nov 2012 23:14:46 +0100 (CET)
Message-ID: <509ED1D6.8010903@petaramesh.org>
Date: Sat, 10 Nov 2012 23:14:46 +0100
From: =?windows-1252?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS cache problem
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My BTRFS is mounted with space_cache,inode_cache , and I now get at boot
time the following message :

“btrfs: free space inode generation (0) did not match free space cache
generation (189086)”

Starting once with "clear_cache" doesn't seem to be able to fix the
issue... Any clue ?

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

