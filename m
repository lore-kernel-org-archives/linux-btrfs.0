Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58557 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbaDILP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 07:15:29 -0400
Received: from mfilter7-d.gandi.net (mfilter7-d.gandi.net [217.70.178.136])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 93B0BFB8BF
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 13:15:27 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([217.70.183.198])
	by mfilter7-d.gandi.net (mfilter7-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id rApdKfn8zOqv for <linux-btrfs@vger.kernel.org>;
	Wed,  9 Apr 2014 13:15:26 +0200 (CEST)
Received: from zafu.localnet (dhcp230.cr2i.univ-montp2.fr [162.38.105.230])
	(Authenticated sender: michel@bouissou.net)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id DB852FB874
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 13:15:25 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Using noCow with snapshots ?
Date: Wed, 09 Apr 2014 13:15:24 +0200
Message-ID: <1541415.olHfkWYf4R@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In the quest for BTRFS and performance, and having received the advice to 
"chattr +C" my akonadi DB directory to make it noCow, I would like to be sure 
about what will happen when I take a snapshot of the concerned BTRFS 
subvolume.

1/ Being noCow, will the database be modified in the snapshot as well, 
efectively defeating the snapshot ?

2/ Being snapshotted, will the database be COWed even though it's supposed to 
be noCow ?

3/ Are both options mutually incompatible in some more osbcure ways ?

I'd like to know where I'm going with this ;-)

TIA and kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


