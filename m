Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55994 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2GENS3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 09:18:29 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, kohler@umic.rwth-aachen.de
Subject: Re: df shows wrong infos on btrfs raid (5gb and 3gb hdd)
Date: Thu, 5 Jul 2012 15:18:27 +0200
References: <4FF459A6.9080403@umic.rwth-aachen.de> (sfid-20120704_195448_565569_D8FE2752)
In-Reply-To: <4FF459A6.9080403@umic.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207051518.28139.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 4. Juli 2012 schrieb Bernd Kohler:
> The infos, given by "btrfs fi show  /dev/sdb1" and "btrfs fi df /mnt"
> are ok, but df is "lieing":
> 
> Filesystem Size Used Avail Use% Mounted on
> /dev/sdc1  8.0G 5.2G 56k   100% /mnt
> 
> Don't get confused about used space, tried to write a 4G file on this
> RAID, which ended with "write error: no space left on device" - as
> expected

+ post outputs of btrfs fi sh and btrfs fi df

Only with these in mind it is possible to say anything about the df 
output.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
