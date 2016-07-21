Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:51872 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbcGUMWW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 08:22:22 -0400
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Cc: Matthias Prager <linux@matthiasprager.de>
From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: Status of SMR with BTRFS
Message-ID: <a5ae13b6-1a7d-fb76-a232-1c5ba6e65bfd@matthiasprager.de>
Date: Thu, 21 Jul 2016 14:22:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'd expect the write pattern of Btrfs to be similar to f2fs, with
> respect to sequentiality of new writes.
Ideally yes - though my tests with a Seagate SMR drive suggest
otherwise. Optimizing the write behavior would probably lead to speed
improvements for btrfs on spinning disks.

---
Matthias Prager
