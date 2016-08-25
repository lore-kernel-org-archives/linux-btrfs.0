Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:63065 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbcHYSRE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 14:17:04 -0400
Received: from durkon.lan ([37.201.97.218]) by mrelayeu.kundenserver.de
 (mreue101) with ESMTPSA (Nemesis) id 0MSJ5v-1binrD0oRP-00TYUa for
 <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 20:17:00 +0200
Received: from haley.lan (haley.lan [192.168.2.21])
        by durkon.lan (Postfix) with ESMTPSA id 81E1616BD
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 20:16:59 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 25 Aug 2016 20:16:59 +0200
From: Gert Menke <gert@menke.ac>
To: linux-btrfs@vger.kernel.org
Subject: Switch raid mode without rebalance?
Message-ID: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I recently created a new btrfs on two disks - one 6TB, one 2TB - for 
temporary backup purposes.
It apparently defaulted to raid0 for data, and I didn't realize at the 
time that this would become a problem.
Now the 2TB is almost full, and df tells me I only have about 200GB of 
free space. Which makes sense, because raid0 spreads the data evenly on 
all disks.
However, I know that btrfs can have different raid modes on the same 
filesystem at the same time. So I was hoping I could just tell it to 
"switch to single mode for all new data", but I don't have a clue how to 
do that. I *could* rebalance, of course, but is that really necessary? 
How does btrfs find out which raid mode to use when writing new data?

Gert
