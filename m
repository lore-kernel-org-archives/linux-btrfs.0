Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:53806 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965567AbbD1MeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 08:34:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id C7EFB1608BC
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 07:34:24 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 5vmzVTK_-gZE for <linux-btrfs@vger.kernel.org>;
	Tue, 28 Apr 2015 07:34:24 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id 85F641609C0
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 07:34:24 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 20SGoMsGrYK9 for <linux-btrfs@vger.kernel.org>;
	Tue, 28 Apr 2015 07:34:24 -0500 (CDT)
Received: from [192.168.168.20] (unknown [206.126.223.13])
	by mail.lqfe.com (Postfix) with ESMTPSA id 4FD231608BC
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 07:34:24 -0500 (CDT)
From: Anthony Plack <anthony@plack.net>
Content-Type: text/plain; charset=utf-8
Subject: parent transid verify failed
Date: Tue, 28 Apr 2015 07:34:24 -0500
References: <E18363B1-CD81-41F4-A03C-4D09AA669915@plack.net>
To: linux-btrfs@vger.kernel.org
Message-Id: <34469AC9-0D4E-46D9-8335-2EE10A449BA1@plack.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am running kernel 4.0 and btrfs-prog mainline.  I have a backup.

Of the following commands:

btrfs check —repair device
btrfsck —repair device
mount -t btrfs -o recovery device mount && btrfs scrub start mount

--none of them remove the "parent transid verify failed” errors from the disk.

The disk was going to read-only.  The disk now mounts and seems to be fine.  However, these “errors” persist.

Is there any tool other than to zero the log, which will “repair” the log?