Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpout1-pedv.core.ignum.cz ([62.109.128.52]:60022 "EHLO
	smtpout1-pedv.core.ignum.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737Ab3ISIJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 04:09:16 -0400
Received: from [62.109.143.82] (nb027.office.ignum.cz [62.109.143.82])
	by smtpout1.core.ignum.cz (Postfix) with ESMTP id E025CE99BB
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 09:59:37 +0200 (CEST)
Message-ID: <523AAEAB.1020300@ignum.cz>
Date: Thu, 19 Sep 2013 09:58:35 +0200
From: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <ondrej.kunc@ignum.cz>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Is parralel device remove possible ?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm just removing about 8 drives from btrfs pool and I issued this command:

btrfs dev del /dev/sd[bmghkqps]

According to munin graphs it is removing drives sequentially and ... I 
can see it is reading that drive which it is actually removing ... but 
it is doing big writes(so it is probably moving data there) to other 
drives which will be removed later.

Would it be possible to do this in parallel ... to restrict next writing 
to drives to fasten this operation ?

Now it is running about 3 days and it has removed 5 drives.

And second question ... is there way how to see progress of drive 
removing ? In  dmesg I can see relocating block group ... and the number 
of group is decreasing ... but sometimes it changes direction, so it 
doesn't provide so useful estimation.

Thanks,

Ondøej

-- 
S pozdravem,

Ondøej Kunc, Senior Linux Administrator

IGNUM s.r.o., Vinohradská 190, Praha 3, 130 61, CZE
Mobil: +420 603 111 111 | Fax: +420 296 332 222
www.ignum.cz | www.domena.cz | www.webcloud.cz
