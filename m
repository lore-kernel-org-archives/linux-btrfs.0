Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.mail.nexica.com ([217.13.116.17]:56752 "EHLO
	relay1.mail.nexica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbLaMM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 07:12:58 -0500
Received: from cl4-smtp.mail.nexica.com (zeus02nex.noc.nexica.com [10.2.0.151])
	by relay1.noc.nexica.com (Postfix) with ESMTP id B7853133343
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 13:12:53 +0100 (CET)
Received: from vnxbcnex02.bcn.nexica.com (unknown [212.92.38.69])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: relay.nexica.com)
	by cl4-smtp.mail.nexica.com (Postfix) with ESMTP id B0C6112B640
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 13:12:53 +0100 (CET)
From: Xavier Romero <XRomero@nexica.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: subvolume capacity
Date: Thu, 31 Dec 2015 12:12:37 +0000
Message-ID: <943c2fc6fe4c4e6c9038545d24b4e0db@nex-exchng-01-v.bcn.nexica.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I create a subvolume, I assign a quota on it, I mount the subvolume, the capacity reported for that mount point is not the assigned quota but the total btrfs filesystem capacity.
I would rather expect it to report the assigned space (unless there is no quota assigned obviously), that would perfectly fit on a multi-tenant environment; also using btrfs for virtual machines datastores, etc. Otherwise it will be really confusing and sometimes problematic when exporting subvolumes through NFS/CIFS/etc.

Best regards,
Xavier Romero
