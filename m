Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:60607 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741AbbHaSeE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 14:34:04 -0400
Received: from smtp5.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp5.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id A179E8032F
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:34:02 -0400 (EDT)
Received: from smtp5.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp5.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 9D98680396
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:34:02 -0400 (EDT)
Received: from app40.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp5.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 8C0EB8032F
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:34:02 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app40.wa-webapps.iad3a (Postfix) with ESMTP id 7A6B4300044
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:34:02 -0400 (EDT)
Date: Mon, 31 Aug 2015 14:34:02 -0400 (EDT)
Subject: errors while "btrfs receive"
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Message-ID: <1441046042.49932584@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

i'm doing a ~900TiB receive on a 6x4TB RAID0

"fi show", "device scan" all fail and report "unable to connect to /dev/sdX"

is it normal ?

thanks,

Vincent

