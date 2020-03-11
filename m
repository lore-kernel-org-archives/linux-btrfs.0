Return-Path: <SRS0=EJVa=44=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B23C2BAEE
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 20:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E58B2074D
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 20:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgCKUsf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 16:48:35 -0400
Received: from static.149.47.69.159.clients.your-server.de ([159.69.47.149]:53128
        "EHLO mat.lavorato.re" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgCKUsf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Mar 2020 16:48:35 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2020 16:48:34 EDT
Received: from li61-168.members.linode.com (li61-168.members.linode.com [97.107.131.168])
        by mat.lavorato.re (Postfix) with ESMTP id DC69B3E810
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2020 21:42:04 +0100 (CET)
Received: by li61-168.members.linode.com (Postfix, from userid 0)
        id 8806B221F2; Wed, 11 Mar 2020 20:42:04 +0000 (UTC)
Date:   Wed, 11 Mar 2020 20:42:04 +0000
From:   Andrea Gelmini <gelma@gelma.net>
To:     linux-btrfs@vger.kernel.org
Subject: Request about "Page cache invalidation failure on direct I/O."
Message-ID: <20200311204204.GA21905@li61-168.members.linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi everybody,
   thanks a lot for your work.

   On my laptop (Ubuntu 19.10, Kernel 5.5.7, VirtualBox 6.1.4-136177)
   I have an SSD (Samsung SSD 860 EVO 4TB + luks + lvm + ext4)
   with a virtual machine, without troubles, since months.

   Now, I move the virtual machine on external USB
   disk (Seagate M3 Portable 4TB + luks + BTRFS).
   Run it, and after a few minutes of simple boot and Windows updating
   (the guest system), I find this in dmesg:

[376827.145222] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[376827.145225] File: /mnt/4TB/piastrelli/home/virtual/VirtualBox VMs/Zuccotti/Snapshots/{badf36e0-30a3-4fef-b723-4cdab32f2ef0}.vdi PID: 48667 Comm: kworker/1:0
[376827.145230] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[376827.145231] File: /mnt/4TB/piastrelli/home/virtual/VirtualBox VMs/Zuccotti/Snapshots/{badf36e0-30a3-4fef-b723-4cdab32f2ef0}.vdi PID: 48667 Comm: kworker/1:0
[376827.145234] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[376827.145234] File: /mnt/4TB/piastrelli/home/virtual/VirtualBox VMs/Zuccotti/Snapshots/{badf36e0-30a3-4fef-b723-4cdab32f2ef0}.vdi PID: 48667 Comm: kworker/1:0
[376827.145236] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[376827.145237] File: /mnt/4TB/piastrelli/home/virtual/VirtualBox VMs/Zuccotti/Snapshots/{badf36e0-30a3-4fef-b723-4cdab32f2ef0}.vdi PID: 48667 Comm: kworker/1:0
[376827.145240] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[376827.145241] File: /mnt/4TB/piastrelli/home/virtual/VirtualBox VMs/Zuccotti/Snapshots/{badf36e0-30a3-4fef-b723-4cdab32f2ef0}.vdi PID: 48667 Comm: kworker/1:0

   I kindly ask your advice. At the moment the virtual seems to work
   without problem.

Thanks a lot,
Gelma
