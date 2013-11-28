Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:53377 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750949Ab3K1KBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 05:01:49 -0500
Received: from [79.135.116.105] (helo=[192.168.0.103])
	by lon-b.elastichosts.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <alin.dobre@elastichosts.com>)
	id 1VlyPs-0000k1-8V
	for linux-btrfs@vger.kernel.org; Thu, 28 Nov 2013 10:01:48 +0000
Message-ID: <5297147B.7030904@elastichosts.com>
Date: Thu, 28 Nov 2013 10:01:31 +0000
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Subvolume creation returns file exists
References: <528630D6.5090103@elastichosts.com>
In-Reply-To: <528630D6.5090103@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems that the problem was that we didn't delete the corresponding 
qgroup when deleting the subvolume, which was filling the metadata with 
unused information. Removing all the stale qgroups fixes the problem and 
allows subsequent subvolume creation without any quota disable/enable 
action. Also, we are now automatically deleting the corresponding qgroup 
after the subvolume is removed.

Cheers,
Alin.
