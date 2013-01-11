Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:43451 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377Ab3AKTuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 14:50:40 -0500
Received: from [212.54.34.133] (helo=smtp2.gn.mail.iss.as9143.net)
	by smtpq3.gn.mail.iss.as9143.net with esmtp (Exim 4.71)
	(envelope-from <r.wobben@home.nl>)
	id 1TtkAP-0002L0-7s
	for linux-btrfs@vger.kernel.org; Fri, 11 Jan 2013 20:21:25 +0100
Received: from 524a811f.cm-4-3c.dynamic.ziggo.nl ([82.74.129.31] helo=[127.0.0.1])
	by smtp2.gn.mail.iss.as9143.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <r.wobben@home.nl>)
	id 1TtkAP-00074x-2D
	for linux-btrfs@vger.kernel.org; Fri, 11 Jan 2013 20:21:25 +0100
Message-ID: <50F06639.6030409@home.nl>
Date: Fri, 11 Jan 2013 20:21:29 +0100
From: Roelof Wobben <r.wobben@home.nl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: partition question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have one thing I think I don't really understand about btrfs,

Normally if I use ext4 I make a  3 partitions for my distro.

one for boot about 1G
one for home about 30G
one for root for the rest of my 100G.

Now I wonder if I want to do the same with btrfs.

Can I do the same so make 3 partitions with btrfs or can I better make 1 
partiton of 100G and make the /boot /home and  / subvolumes of the big 
partitiion.

Can one of you btfrs gurus shine a light of this matter ?

Regards,

Roelof Wobben

