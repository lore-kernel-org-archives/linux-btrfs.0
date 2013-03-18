Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:35980
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab3CRSWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 14:22:25 -0400
Received: from [192.168.1.23] (unknown [192.168.1.23])
	by decaymodealpha.mooo.com (Postfix) with ESMTPSA id 174043D871
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 14:15:17 -0400 (EDT)
Message-ID: <514759B5.5000507@lolwut.org>
Date: Mon, 18 Mar 2013 14:15:17 -0400
From: Kyle <lists@lolwut.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Impossible or Possible to Securely Erase File on Btrfs?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

After reading through the btrfs documentation I'm curious to know if 
it's possible to ever securely erase a file from a btrfs filesystem (or 
ZFS for that matter). On non-COW filesystems atop regular HDDs one can 
simply overwrite the file with zeros or random data using dd or some 
other tool and rest assured that the blocks which contained the 
sensitive information have been wiped. However on btrfs it would seem 
any such attempt would write the zeros/random data to a new location, 
leaving the old blocks with the sensitive data intact. Further, since 
specifying NOCOW is only possible for newly created files, there seems 
to be no way to overwrite the appropriate blocks short of deleting the 
associated file and then filling the entire free filesystem space with 
zeros/random data such that the old blocks are eventually overwritten. 
What's the verdict on this?

Regards,

Kyle
