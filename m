Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-sebastian.wadns.net ([196.220.39.202]:8022 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbaBMT3o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:29:44 -0500
Message-ID: <52FD1D1B.7080306@swiftspirit.co.za>
Date: Thu, 13 Feb 2014 21:29:31 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Possible to wait for snapshot deletion?
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
In-Reply-To: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/02/13 09:02 PM, Kai Krakow wrote:
> Hi!
>
> Is it technically possible to wait for a snapshot completely purged from
> disk? I imagine an option like "--wait" for btrfs delete subvolume.
>
> This would fit some purposes I'm planning to implement:
>
> * In a backup scenario
I have a similar use-case for this also involving backups. In my case I 
have a script that uses a btrfs filesystem for the backup store using 
snapshots. At the end of each run, if diskspace usage is below a 
predefined threshold, it will delete old snapshots until the diskspace 
usage is below that threshold again.

Of course, the first time I added the automatic deletion, it deleted far 
more than was necessary due to the fact that the actual freeing of 
diskspace is asynchronous from the command completion. I ended up 
setting a small delay (of about 60 seconds) between each iteration and 
also set it to monitor system load. If load is not low enough after the 
delay then it waits another 60 seconds.

This complicated (frankly broken) workaround would be completely 
unnecessary with a --wait switch.

Alternatively, perhaps a knob where we can see if a subvolume deletion 
is in progress could help.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

