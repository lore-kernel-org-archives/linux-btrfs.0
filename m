Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60069 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab3EYWL4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 18:11:56 -0400
Received: from [IPv6:2001:a60:250c:9401:223:14ff:fe22:3e48] (unknown [IPv6:2001:a60:250c:9401:223:14ff:fe22:3e48])
	(Authenticated sender: xavier@gnata.eu)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 98D18A80B6
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 00:11:54 +0200 (CEST)
Message-ID: <51A1372B.6060402@gnata.eu>
Date: Sun, 26 May 2013 00:11:55 +0200
From: Xavier Gnata <xavier@gnata.eu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: compression on external hard drive?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

Nowdays, external hard drives are mounted automagically by kde, gnome or 
whatever else.
How is it suppose to work with external hard drives using btrfs with 
compression?
If a btrfs filesystem lzo-compressed is mounted without the 
|compress=|xxx option then all the newly created files are uncompressed, 
aren't then?
Would it be possible to detect if a file system is compressed  and to 
mount it *automatically* and accordingly (except otherwise explicitly 
stated by the user) with/without the lzo/gzip option?

Xavier
