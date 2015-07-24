Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:57628 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbbGXSub convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 14:50:31 -0400
Received: from smtp24.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp24.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 9231918026D
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:43:36 -0400 (EDT)
Received: from smtp24.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp24.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 8E7DA180223
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:43:36 -0400 (EDT)
Received: from app9.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp24.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 6917E18026D
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:43:36 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app9.wa-webapps.iad3a (Postfix) with ESMTP id 562ED300041
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 14:43:36 -0400 (EDT)
Date: Fri, 24 Jul 2015 14:43:36 -0400 (EDT)
Subject: =?utf-8?Q?RE=3A_systemd_=3A_Timed_out_waiting_for_defice_dev-disk-by?=
 =?utf-8?Q?=E2=80=A6?=
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
In-Reply-To: <1437763277.673610371@apps.rackspace.com>
References: <1437763277.673610371@apps.rackspace.com>
Message-ID: <1437763416.34993658@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I forgot to say: I'm with Centos 7 and Kernel 4.1.3 but it's been doing this since Kernel 4.0, the time at which I started using btrfs.

thanks

-----Original Message-----
From: "Vincent Olivier" <vincent@up4.com>
Sent: Friday, July 24, 2015 14:41
To: linux-btrfs@vger.kernel.org
Subject: systemd : Timed out waiting for defice dev-disk-by…

Hi,

(Sorry if this gets sent twice : one of my mail relay is misbehaving today)

50% of the time when booting, the system go in safe mode because my 12x 4TB RAID10 btrfs is taking too long to mount from fstab.

When I comment it out from fstab and mount it manually, it’s all good.

I don’t like that. Is there a way to increase the timer or something ?

Thanks,

Vincent


