Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55661 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaFQR1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 13:27:52 -0400
Received: from mfilter34-d.gandi.net (mfilter34-d.gandi.net [217.70.178.165])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id EED7C41C06B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 19:27:50 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter34-d.gandi.net (mfilter34-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id 3OmFE-omeqHG for <linux-btrfs@vger.kernel.org>;
	Tue, 17 Jun 2014 19:27:49 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-256-1-58-48.w90-28.abo.wanadoo.fr [90.28.25.48])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 9241141C062
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 19:27:49 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: No more snapshot aware defrag ?
Date: Tue, 17 Jun 2014 19:27:48 +0200
Message-ID: <1407090.0P4LdDZJ3g@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Heck ! I discovered from the wiki

https://btrfs.wiki.kernel.org/index.php/UseCases#How_do_I_defragment_many_files.3F

...That defrag, which used to be snapshot-aware, isn't anymore :-/

...And /me am still defraggging my snapshotted system on a regular basis :-(

Is there any plan to re-enable the snapshot-awareness of defrag anytime soon ?

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

