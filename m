Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41601 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaFPHyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 03:54:07 -0400
Received: from mfilter20-d.gandi.net (mfilter20-d.gandi.net [217.70.178.148])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 6EC6AA80D2
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 09:54:03 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter20-d.gandi.net (mfilter20-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id NtKncxv6l+0G for <linux-btrfs@vger.kernel.org>;
	Mon, 16 Jun 2014 09:54:01 +0200 (CEST)
Received: from vajra.localnet (unknown [162.38.105.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id C598FA80B0
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 09:54:01 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: BTRFS, SSD and single metadata
Date: Mon, 16 Jun 2014 09:54:01 +0200
Message-ID: <1723493.aXdklhDgAK@vajra>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I created a BTRFS filesytem over LVM over LUKS encryption on an SSD [yes, I 
know...], and I noticed that the FS got created with metadata in "DUP" mode, 
contrary to what "man mkfs.btrfs" says for SSDs -> it would be supposed to be 
"SINGLE"...

Well I don't know if my system didn't identify the SSD because of the LVM+LUKS 
stack (however it mounts well by itself with the "ssd" flag and accepts the 
"discard" option [yes, I know...]), or if the manpage is obsolete or if this 
feature just doesn't work...?

The SSD being a Micron RealSSD C400

For both SSD preservation and data integrity, would it be advisable to change 
metadata to "SINGLE" using a rebalance, or if I'd better just leave things the 
way they are...?

TIA for any insight.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

Tout le malheur des hommes vient de ce qu'ils ne vivent pas dans _le_ monde,
mais dans _leur_ monde.
-- Héraclite.

