Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ec2-54-200-0-65.us-west-2.compute.amazonaws.com ([54.200.0.65]:51621
	"EHLO wecheer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA2V0z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 16:26:55 -0500
Received: from localhost (localhost [127.0.0.1])
	by wecheer.com (Postfix) with ESMTP id 9465845451
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 21:26:56 +0000 (UTC)
Received: from wecheer.com ([127.0.0.1])
	by localhost (ip-172-31-45-254.us-west-2.compute.internal [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FK38EGGjYVOJ for <linux-btrfs@vger.kernel.org>;
	Wed, 29 Jan 2014 21:26:54 +0000 (UTC)
Received: from [10.10.22.177] (unknown [207.194.255.202])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: m)
	by wecheer.com (Postfix) with ESMTPSA id 70EB2432E4
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 21:26:54 +0000 (UTC)
Message-ID: <52E9721D.6000908@matthewlai.ca>
Date: Wed, 29 Jan 2014 13:26:53 -0800
From: Matthew Lai <m@matthewlai.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Receive on same subvolume
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Is this supposed to work? (/data is the root volume, /data/a is a subvolume)

btrfs subvolume snapshot /data/a /data/b
# make some changes in b
btrfs send -p /data/a /data/b > delta
btrfs receive /data/a < delta

I'm getting "ERROR: could not find parent subvolume" on receive.

What I'm trying to do is to back up using send/receive, but I don't have 
50% free space, and (please correct me if I'm wrong) since receive 
doesn't do deduplication, I want to use snapshot to do the initial 
bootstrapping, instead of send/receive without a parent.

Thanks!
Matthew
