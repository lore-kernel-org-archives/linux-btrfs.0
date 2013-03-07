Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51214 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CGMLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 07:11:12 -0500
Received: from mfilter11-d.gandi.net (mfilter11-d.gandi.net [217.70.178.131])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 831F4A80CA
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2013 13:11:11 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter11-d.gandi.net (mfilter11-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id iz+61vquvg2h for <linux-btrfs@vger.kernel.org>;
	Thu,  7 Mar 2013 13:11:09 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-67-91.w90-28.abo.wanadoo.fr [90.28.34.91])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id CF47FA80B8
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2013 13:11:09 +0100 (CET)
Message-ID: <513883DD.8080203@petaramesh.org>
Date: Thu, 07 Mar 2013 13:11:09 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: mkfs.btrfs broken
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

mkfs.btrfs v0.20-rc1, as provided in the excellent "Parted Magic" tool,
latest version dated 2013/02/28, is broken :

When trying to mkfs.btrfs - even on newly made, FS-free partition, it
always spits an error that it cannot check partition mount status and fails.

There has always been such an issue with mkfs.btrfs AFAIR, but it can
more or less work depending on the distribution etc...

In the past, some versions of mkfs.btrfs had a "-f" option that would
force formatting even if this test failed, but alas this option seems to
have disappeared...

PartedMagic being a "live CD", it might be easy to reproduce and check
what, exactly, goes wrong ?

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

