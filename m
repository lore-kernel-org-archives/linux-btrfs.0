Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ugs.tarent.de ([193.107.123.165]:46433 "EHLO ugs.tarent.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab3GWPAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 11:00:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by ugs.tarent.de (Postfix) with ESMTP id CEF3F60612D21
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 16:52:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ugs.tarent.de (Postfix) with ESMTP id B293A60612D22
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 16:52:42 +0200 (CEST)
Received: from ugs.tarent.de ([127.0.0.1])
	by localhost (ugs.tarent.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6XmiTxTwNrm2 for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Jul 2013 16:52:42 +0200 (CEST)
Received: from abuschnb (abusch-nb.lan.tarent.de [172.26.5.218])
	by ugs.tarent.de (Postfix) with ESMTPSA id 5C6DC60612D21
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 16:52:42 +0200 (CEST)
From: "Andreas Buschka" <a.buschka@tarent.de>
To: <linux-btrfs@vger.kernel.org>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
In-Reply-To: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
Subject: AW: Why subvolumes?
Date: Tue, 23 Jul 2013 16:52:38 +0200
Message-ID: <01ff01ce87b4$46b7d980$d4278c80$@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jerome,

essentially, a btrfs sub volume is the root of a btrfs (you can take it and mount it as it is). This is critical for the snapshot functionality: If you have a sub volume (consisting of a snapshot) for, say, "/", and your system goes south (e.g. after updating the kernel or another crucial system package), then all you have to do it tell the Linux kernel at the bootloader prompt (via the rootflags=...  parameter)  not to mount the default btrfs, but the snapshot. Then, you can boot the "last known good" state of the system normally and recover from the comfort of a running system.

The main point here is that the default btrfs "sub volume" (which you would normally mount as /) is technically not different from any other sub volume at all.

Best regards,
Andreas

-----Ursprüngliche Nachricht-----
Von: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] Im Auftrag von Jerome Haltom
Gesendet: Dienstag, 23. Juli 2013 14:00
An: Linux Btrfs
Betreff: Q: Why subvolumes?

May I ask why the decision to implement snapshotting through subvolumes? I've been very curious about why the design wasn't to simply allow snapshotting of any directory or file.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

