Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:58291 "EHLO mx1.mailbox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965708AbbDVQQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:16:33 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.mailbox.org (Postfix) with ESMTPS id 96FD4402D6
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 18:08:31 +0200 (CEST)
Received: from smtp1.mailbox.org ([80.241.60.240])
	by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
	with ESMTP id v9iQAxtKiyfw for <linux-btrfs@vger.kernel.org>;
	Wed, 22 Apr 2015 18:08:30 +0200 (CEST)
From: Thomas Koch <thomas@koch.ro>
To: linux-btrfs@vger.kernel.org
Subject: btrfs subvolume diff
Date: Wed, 22 Apr 2015 18:08:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201504221808.30242.thomas@koch.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

for incremental backups it would be useful to know the files that changed 
between two snapshots. I found a paper about such a tool[1] that adds the 
"btrfs subvolue diff" command, but it's not yet implemented in btrfs-tools in 
Debian Jessie.

Is it in Git? Or somewhere else?

[1] https://www.kernel.org/doc/ols/2014/ols2014-pimpale.pdf

Regards, Thomas Koch
