From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Removal of snapshots (and subvolumes)
Date: Mon, 15 Jun 2009 18:54:30 +0200
Message-ID: <4A367CC6.1000302@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: aaron@merfinllc.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

obviously btrfs is yet lacking any means to delete snapshots and
subvolumes, well, at least their names (I read something about deleting
their content...). We wanted to start playing with circular snapshots
over btrfs driven by an application, so this limitation is a bit unhandy
- even if everything is highly experimental here anyway.

Browsing the archive, I found Aaron's first patches to fill this gap.
What happened to them? Besides likely a few remaining bugs, the biggest
seems to have been some lacking references in btrfs' tree roots. Did
this situation change meanwhile? What is the schedule for this feature?
If it's just lacking someone to pick up already existing bits and bring
them in shape, I could offer a hand. Just hacking on btrfs with broader
scope is currently not possible.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux

