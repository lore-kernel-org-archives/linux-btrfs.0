Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51583 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaFENah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 09:30:37 -0400
Received: from mfilter34-d.gandi.net (mfilter34-d.gandi.net [217.70.178.165])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id F4062A80F1
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Jun 2014 15:30:30 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter34-d.gandi.net (mfilter34-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id xGPg9G0ERpRg for <linux-btrfs@vger.kernel.org>;
	Thu,  5 Jun 2014 15:30:29 +0200 (CEST)
Received: from zafu.localnet (dhcp231.cr2i.univ-montp2.fr [162.38.105.231])
	(Authenticated sender: michel@bouissou.net)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 90D24A80CD
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Jun 2014 15:30:29 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Using BTRFS on SSD now ?
Date: Thu, 05 Jun 2014 15:30:26 +0200
Message-ID: <2215647.hErg5R77lo@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just received a new laptop with a Micron 256GB SSD, and I plan to install 
Fedora 20 onto it.

I'm considering either BTRFS or ext4 (over LUKS-encrypted LVM) for this 
machine, but I'm afraid BTRFS might generate too much writes and shorten the 
SSD lifespan... Or am I mistaken ?

Is there any pro/cons currently, on a 3.14 kernel, about using BTRFS along 
with an SSD ?

Is there specific advice about leaf size, use of compression, snapshots, 
(auto-)defrag etc, that might be relevant especially for SSDs ?

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
