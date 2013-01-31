Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57504 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab3AaTRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:17:17 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: dsterba@suse.cz
Subject: Re: Integration branch of btrfs-progs 2013-01-30
Date: Thu, 31 Jan 2013 20:17:13 +0100
References: <20130130002427.GD30535@twin.jikos.cz> (sfid-20130130_194048_747056_BBC210C1)
In-Reply-To: <20130130002427.GD30535@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301312017.13704.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 30. Januar 2013 schrieb David Sterba:
> Hi,

Hi,

> a few build warning fixes, unaligned access fix #2 and finally support
> for the 'device stats' and device 'replace' commands!
> 
> Please test, worked for me here, but not tested extensively. If
> everything goes well I'll send a pull request with this branch in a few
> days.
> 
>   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130130
> 
> (top commit 78b35a43988163dbf71d9)

Tested device stats command, worked nicely on two BTRFS filesystems.

Hope the extended free space information stuff by Goffredo comes next :)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
