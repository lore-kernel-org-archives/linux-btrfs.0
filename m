Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:42698 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbbGXStZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 14:49:25 -0400
Received: from smtp21.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp21.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id E4CDE1802A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:41:17 -0400 (EDT)
Received: from smtp21.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp21.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id E107C18031A
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:41:17 -0400 (EDT)
Received: from app61.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp21.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id C657B1802A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:41:17 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app61.wa-webapps.iad3a (Postfix) with ESMTP id A4ECF180050
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:41:17 -0400 (EDT)
Date: Fri, 24 Jul 2015 14:41:17 -0400 (EDT)
Subject: =?utf-8?Q?systemd_=3A_Timed_out_waiting_for_defice_dev-disk-by=E2=80=A6?=
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Message-ID: <1437763277.673610371@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(Sorry if this gets sent twice : one of my mail relay is misbehaving today)

50% of the time when booting, the system go in safe mode because my 12x 4TB RAID10 btrfs is taking too long to mount from fstab.

When I comment it out from fstab and mount it manually, it’s all good.

I don’t like that. Is there a way to increase the timer or something ?

Thanks,

Vincent

