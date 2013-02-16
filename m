Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33809 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3BPRTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 12:19:08 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: add support for device replace procedure
Date: Sat, 16 Feb 2013 18:19:05 +0100
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
References: <3344706e9c44b0dbfaf2e74aa60c1185fa193721.1355244128.git.sbehrens@giantdisaster.de> (sfid-20121211_203710_475710_271746A3)
In-Reply-To: <3344706e9c44b0dbfaf2e74aa60c1185fa193721.1355244128.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302161819.06015.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 11. Dezember 2012 schrieb Stefan Behrens:
> This is the user mode part of the device replace patch series.

Thank you for working on this.

> The command group "btrfs replace" is added with three commands:
> - btrfs replace start srcdev|srcdevid targetdev [-Bfr] mount_point
> - btrfs replace status mount_point [-1]
> - btrfs replace cancel mount_point

Why isn´t this under btrfs device replace {start,status,cancel}?

Well I see a pattern. btrfs balance is also not under btrfs filesystem
balance. Well its still optional there, but I think this is deprecated.

I do not recall the reason right now, why btrfs balance was moved one
hierarchy up, but as a user if I wanted to do something with a device,
I think I´d just look up the sub commands of btrfs device. And wouldn´t
find the replace command there. Then if I accidentally found it, I may
be confused as to what is being replaced there. Well the parameter names
srcdev / targetdev might give me a hint, but still, this doesn´t make
the impression of a predictable and consistent user interface here.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
