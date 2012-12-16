Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-server.com ([216.13.78.11]:61123 "EHLO smtp-server.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2LPNvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 08:51:09 -0500
Received: from [192.168.1.104] (dynamic-adsl-78-13-211-5.clienti.tiscali.it [78.13.211.5])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp-server.com (Postfix) with ESMTP id 70B1017B971
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Dec 2012 13:42:41 +0000 (UTC)
Message-ID: <50CDCFD1.5000304@libero.it>
Date: Sun, 16 Dec 2012 14:42:41 +0100
From: Claudio Carbone <erupter@libero.it>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: unmountable partition and live distro (no space left)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all.

My system failed and I thought of trying btrfs.
After repartitioning and installing, nothing booted and my (btrfs 
formatted) home partition is unmountable (parent transid).
I discovered I can mount the partition with btrfs-restore but, since I'm 
running off of a live usb Ubuntu, mounting fails at some point due to 
lack of space.
So is there a way I can mount the partition on a live distro to recover 
what is recoverable?

Thank you
Claudio
