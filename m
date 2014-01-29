Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ec2-54-200-0-65.us-west-2.compute.amazonaws.com ([54.200.0.65]:51511
	"EHLO wecheer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaA2Tlt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 14:41:49 -0500
Received: from localhost (localhost [127.0.0.1])
	by wecheer.com (Postfix) with ESMTP id 9C48B45453
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 19:26:46 +0000 (UTC)
Received: from wecheer.com ([127.0.0.1])
	by localhost (ip-172-31-45-254.us-west-2.compute.internal [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t1m7AbRparDL for <linux-btrfs@vger.kernel.org>;
	Wed, 29 Jan 2014 19:26:44 +0000 (UTC)
Received: from [10.10.22.177] (unknown [207.194.255.202])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: m)
	by wecheer.com (Postfix) with ESMTPSA id 77F304313C
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 19:26:44 +0000 (UTC)
Message-ID: <52E955F2.60608@matthewlai.ca>
Date: Wed, 29 Jan 2014 11:26:42 -0800
From: Matthew Lai <m@matthewlai.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs send requires root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I have just started playing with btrfs, and noticed that "btrfs send" 
only works for root (ERROR: failed to initialize subvol search. 
Operation not permitted), even on subvolumes created by the user.

Am I doing something wrong? Or is this the intended behaviour?

My setup (/data is the root subvolume):
mkdir /data/snapshots
btrfs subvolume snapshot -r /data /data/snapshots (creates 
/data/snapshots/data)
btrfs send /data/snapshots/data > /dev/null

Returns:
ERROR: can't perform the search- Operation not permitted
ERROR: failed to initialize subvol search. Operation not permitted

Thanks!
Matthew
