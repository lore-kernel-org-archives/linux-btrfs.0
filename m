Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:49994 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab3K0UI6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 15:08:58 -0500
Received: from [192.168.0.50] (mail.coastalscience.com [66.83.151.234])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 18C7CD2A8
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 15:08:55 -0500 (EST)
Message-ID: <5296516E.8000201@jrs-s.net>
Date: Wed, 27 Nov 2013 15:09:18 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs send size
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list -

Long time ZFS guy here trying to move everything over from ZFS to btrfs, 
which entails a lot of re-scripting and re-learning.

Question of the day: how can I determine the size of a btrfs send 
operation before hand?  I'd like to be able to provide a progress bar 
(I'm accustomed to using pv to do this), but I would need to know a 
rough approximation at least of how much data I'm going to transfer in 
order to be able to do that.

Under ZFS, you can do this:

root@box:~# zfs send -nvi 
data/images@autosnap_2013-11-27_14:00:01_hourly 
data/images@autosnap_2013-11-27_15:00:01_hourly
send from @autosnap_2013-11-27_14:00:01_hourly to 
data/images@autosnap_2013-11-27_15:00:01_hourly estimated size is 42.7M
total estimated size is 42.7M

Which then lets me do this:

root@box:~# zfs send -i data/images@autosnap_2013-11-27_14:00:01_hourly 
data/images@autosnap_2013-11-27_15:00:01_hourly | pv -s 42.7M | ssh 
otherbox zfs receive backup/images

And get a nice progress bar.

I can't find a manpage for the btrfs command that lists ANY information 
about btrfs send, and I haven't found anything online about doing a size 
check on send operations without actually sending the data.  Anybody got 
any help for this?  This is officially a Big Deal for those of us who 
customarily do asynchronous replication, so it would be really, really 
awesome if this could get addressed. =)

Thank you!
