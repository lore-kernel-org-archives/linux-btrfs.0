Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52464 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbbHUIT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 04:19:58 -0400
Received: from mfilter13-d.gandi.net (mfilter13-d.gandi.net [217.70.178.141])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 0C259A80AB
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 10:19:57 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([IPv6:::ffff:217.70.183.195])
	by mfilter13-d.gandi.net (mfilter13-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id F75XBcu4P-_2 for <linux-btrfs@vger.kernel.org>;
	Fri, 21 Aug 2015 10:19:55 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-656-1-293-45.w90-0.abo.wanadoo.fr [90.0.245.45])
	(Authenticated sender: michel@bouissou.net)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A4A88A80AD
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 10:19:55 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS cannot remove empry directory pretending it is not empty
Date: Fri, 21 Aug 2015 10:19:54 +0200
Message-ID: <2017000.AEG9PyVY17@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

BTRFS refuses to remove an empty dir and pretends it is not empty (and there 
is no BTRFS subvolume involved in there...)

# uname -r
4.1.5-1-ARCH


# ls -alnR .dropbox-old/
.dropbox-old/:
total 0
drwx------ 1 1000 1000   18 21 août  09:59 .
drwxr-x--- 1 1000 1000 2624 21 août  10:09 ..
drwx------ 1 1000 1000  416 21 août  09:59 instance1

.dropbox-old/instance1:
total 0
drwx------ 1 1000 1000 416 21 août  09:59 .
drwx------ 1 1000 1000  18 21 août  09:59 ..


# rm -rf .dropbox-old
rm: cannot remove ‘.dropbox-old/instance1’: Directory not empty

# ls -alnR .dropbox-old/instance1/
.dropbox-old/instance1/:
total 0
drwx------ 1 1000 1000 416 21 août  09:59 .
drwx------ 1 1000 1000  18 21 août  09:59 ..

# rm -rf .dropbox-old/instance1/
rm: cannot remove ‘.dropbox-old/instance1/’: Directory not empty


How could this be fixed ?

TIA, kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org>

