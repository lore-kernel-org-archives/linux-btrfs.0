Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:46872 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbbF0OEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 10:04:40 -0400
Received: from smtp8.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp8.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 37EFE80227
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2015 10:04:39 -0400 (EDT)
Received: from smtp8.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp8.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 3357580223
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2015 10:04:39 -0400 (EDT)
Received: by smtp8.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id C24F78025C
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2015 10:04:35 -0400 (EDT)
From: Vincent Olivier <vincent@up4.com>
Content-Type: text/plain; charset=utf-8
Subject: Send/Receive Use Case
Message-Id: <F2771637-3D78-4332-AB96-993069114030@up4.com>
Date: Sat, 27 Jun 2015 10:04:28 -0400
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

There are 4 things I’m not sure about re:send/receive.

1) Is it possible to first copy things on a file system using rsync and then use send-receive ? And to subsequently mix rsync and send-receive ? Provided that snapshots are made accordingly.

2) Is possible to “send" a snapshot diff to disk and then “receive" it from the said disk into a remote filesystem ? I have two very large and physically distant btrfs filesystems. It would be more economical to juste dump snapshot diffs to disk for transport instead of the network.

3) How are “conflicts” handled by send-receive if at all ?

4) If a file is created, modified and then deleted in-between two snapshots is it ignored by send/receive or does send/receive "re-enacts” the journal exactly ?

Thanks,

Vincent