Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38323 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaLZOlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 09:41:25 -0500
Received: from merkaba.localnet (ppp-88-217-104-169.dynamic.mnet-online.de [88.217.104.169])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 3895069
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Dec 2014 15:40:40 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Fri, 26 Dec 2014 15:41:23 +0100
Message-ID: <1790464.sXlqaAlXiG@merkaba>
In-Reply-To: <3207071.8ytD2jQS28@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <3207071.8ytD2jQS28@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 26. Dezember 2014, 15:20:42 schrieben Sie:
> And I wonder about:
> > Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> > GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599
> >
> > 
> 
> 
84C7N�����r��y����b�X��ǧv�^�)޺{.n�+����{�n�߲)����w*jg��������ݢj/���z�ޖ��2
> 
> > �ޙ����&�)ߡ�a�����G���h��j:+v���w��٥
> 
> These random chars are not supposed to be there: I better run scrub
> straight  after this balance.

Okay, thats not me I think. scrub didn´t report any errors and when I look
in kmail send folder I don´t see these random chars as well, so it seems
some server on the wire added the garbage.

Lets defragment the file:

merkaba:/home/martin/.VirtualBox/HardDisks> filefrag Winlala.vdi 
Winlala.vdi: 41462 extents found
merkaba:/home/martin/.VirtualBox/HardDisks> btrfs filesystem defragment 
Winlala.vdi 
merkaba:/home/martin/.VirtualBox/HardDisks> filefrag Winlala.vdi                   
Winlala.vdi: 11735 extents found
merkaba:/home/martin/.VirtualBox/HardDisks> sync
merkaba:/home/martin/.VirtualBox/HardDisks> filefrag Winlala.vdi
Winlala.vdi: 11735 extents found


Okay, that together with:

merkaba:~> btrfs fi df /home       
Data, RAID1: total=151.95GiB, used=144.68GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=3.25GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 147.94GiB
        devid    1 size 160.00GiB used 156.98GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 156.98GiB path /dev/mapper/sata-home

Btrfs v3.17

May do for a while.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
