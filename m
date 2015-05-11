Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:57580 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbbEKWTI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 18:19:08 -0400
Received: from [18.189.109.72]
	by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <matt@techsquare.com>)
	id 1YrvOz-0003oV-Jm
	for linux-btrfs@vger.kernel.org; Mon, 11 May 2015 17:38:29 -0400
Message-ID: <55512147.5030708@techsquare.com>
Date: Mon, 11 May 2015 17:38:15 -0400
From: Matt McKinnon <matt@techsquare.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: btrfs send/receive error
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

What's the best way to deal with this send/receive error?

---

Create a readonly snapshot of 'users' in 
'/export/r2/.incrementals/users_ro.20150511_17:28:53'
At subvol /export/r2/.incrementals/users_ro.20150511_17:28:53
At snapshot users_ro.20150511_17:28:53
ERROR: rename o46709324-421364-0 -> fspace2/120430RU/bold_nopace/SPMana 
failed. Directory not empty

---

./btrfs --version
btrfs-progs v4.0


-Matt
