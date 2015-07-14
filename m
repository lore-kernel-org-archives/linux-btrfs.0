Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([198.245.60.114]:50968 "EHLO
	mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbGNKXu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 06:23:50 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.render-wahnsinn.de (Postfix) with ESMTP id 61A8617EAEA9
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 12:14:15 +0200 (CEST)
Received: from mail.render-wahnsinn.de ([127.0.0.1])
	by localhost (render-wahnsinn.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 4ixW_2Z3E27a for <linux-btrfs@vger.kernel.org>;
	Tue, 14 Jul 2015 12:14:14 +0200 (CEST)
Received: from [192.168.192.249] (unknown [5.146.59.124])
	by mail.render-wahnsinn.de (Postfix) with ESMTPSA id 645DD17EAEA1
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 12:14:14 +0200 (CEST)
Message-ID: <55A4E0F4.2060708@render-wahnsinn.de>
Date: Tue, 14 Jul 2015 12:14:12 +0200
From: Robert Krig <robert.krig@render-wahnsinn.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Recreate Snapshots and their Parent Relationships on a second Server.
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I have an Old Server with a bunch of btrfs Snapshots.
I'm setting up a new server and I would like to transfer those Snapshots
as efficiently as possible, while still maintaining their parent<->child
relationships for space efficient storage.

Apart from manually using "btrfs send" and "btrfs send -p" where
applicable, is there an easy way to transfer everything in one go?

Can I identify Snapshot relationships via their ID or some other data
that I can display using btrfs tools?
