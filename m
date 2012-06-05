Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39692 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761633Ab2FEKXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 06:23:13 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
Date: Tue, 5 Jun 2012 12:23:11 +0200
Cc: Maxim Mikheev <mikhmv@gmail.com>, nemesis@icequake.net,
        "Ryan C. Underwood" <nemesis-lists@icequake.net>,
        Arne Jansen <sensille@gmx.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
References: <4FCA189F.9050000@gmail.com> <4FCCE6FC.5050608@gmail.com> <201206051200.00022.Martin@lichtvoll.de> (sfid-20120605_121857_298308_0C102C98)
In-Reply-To: <201206051200.00022.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206051223.12286.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 5. Juni 2012 schrieb Martin Steigerwald:
> Am Montag, 4. Juni 2012 schrieb Maxim Mikheev:
> > --super works but my root tree 2 has many errors too.
> > 
> > What can I do next?
> 
> Have a data recovery company try to physically recover the bad harddisk
> to a good one and then try to mount BTRFS again and hope that your
> previous attempts to repair the filesystem didn´t make things worse?

Disregard this. I read thread further and it seems that a BTRFS or BTRFS 
tool bugfix could have your filesystem restored and that it was a RAID card 
problem, not necessary a faulty disk.

Still your setup was a really bad idea.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
