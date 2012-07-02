Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34979 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2GBSAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 14:00:45 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs RAID space utilization and bitrot reconstruction
Date: Mon, 2 Jul 2012 20:00:44 +0200
Cc: Waxhead <waxhead@online.no>
References: <4FF0398F.3030802@online.no> (sfid-20120701_192140_431066_0D7C919C)
In-Reply-To: <4FF0398F.3030802@online.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207022000.44415.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 1. Juli 2012 schrieb Waxhead:
> As far as I understand btrfs stores all data in huge chunks that are 
> striped, mirrored or "raid5/6'ed" throughout all the disks added to
> the  filesystem/volume.

Not through all disks. At least not with the current RAID-1 
implementation. It stores two copies of a chunk, no matter how many drives 
you use.

Rest see Hugo´s answer.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
