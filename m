Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42116 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3BUOrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 09:47:04 -0500
Received: from mfilter26-d.gandi.net (mfilter26-d.gandi.net [217.70.178.154])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id BBE06A814E
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 15:47:02 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter26-d.gandi.net (mfilter26-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id RVshPZc7StKk for <linux-btrfs@vger.kernel.org>;
	Thu, 21 Feb 2013 15:47:01 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-85-163.w90-28.abo.wanadoo.fr [90.28.140.163])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 4F62BA80E5
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 15:47:01 +0100 (CET)
Message-ID: <51263363.9020203@petaramesh.org>
Date: Thu, 21 Feb 2013 15:46:59 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: BTRFS fails defragging
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

I'm using Ubuntu 12.10 Quantal with
# uname -r
3.5.0-24-generic

And it seems I cannot defrag :

# filefrag /boot/initrd.img-3.5.0-24-generic
/boot/initrd.img-3.5.0-24-generic: 3 extents found

# btrfs filesystem defrag /boot/initrd.img-3.5.0-24-generic
# echo $?
20

# filefrag /boot/initrd.img-3.5.0-24-generic
/boot/initrd.img-3.5.0-24-generic: 3 extents found

Any clue appreciated ;-)

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

