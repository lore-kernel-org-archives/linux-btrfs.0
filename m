Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44603 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaGQICH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 04:02:07 -0400
Received: from mfilter9-d.gandi.net (mfilter9-d.gandi.net [217.70.178.138])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 19E61A811B
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 10:02:03 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter9-d.gandi.net (mfilter9-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id jfQL2f04fk+P for <linux-btrfs@vger.kernel.org>;
	Thu, 17 Jul 2014 10:02:02 +0200 (CEST)
Received: from vajra.localnet (unknown [162.38.105.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 97CCFA8175
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 10:02:02 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs fi df shows "unknown" ?
Date: Thu, 17 Jul 2014 10:02:01 +0200
Message-ID: <2344973.5NRcZetHsX@vajra>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Since a few days, I have noticed that "btrfs fi df /" displays an entry about 
"unknown" used space, and I can see this on several Fedora machines, so it is 
not an issue related to a given system...

Does anybody know what these "unknown" data are ?

i.e:

# btrfs fi df /
Data, single: total=106.00GiB, used=88.28GiB
System, DUP: total=32.00MiB, used=24.00KiB
Metadata, DUP: total=1.00GiB, used=520.36MiB
unknown, single: total=176.00MiB, used=0.00

# btrfs --version
Btrfs v3.14.2

# uname -r
3.15.5-200.fc20.x86_64

TIA, kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

