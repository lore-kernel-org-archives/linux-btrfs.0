Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:58654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaCVVQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 17:16:29 -0400
Message-ID: <532DFDAB.7000600@friedels.name>
Date: Sat, 22 Mar 2014 22:16:27 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: free space inode generation (0) did not match free space cache
 generation
References: <532DF38B.40409@friedels.name>
In-Reply-To: <532DF38B.40409@friedels.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

thanks for your help, I appreciate your hint.
I think (reboot into the system with the fs mounted as root still
outstanding), it fixed my problem.
I read through the FAQ you mentioned, but I must admit, that I do not
fully understand.
What I am wondering about is, what caused this problem to arise. The
filesystem was hardly a week old, never mistreated (powered down without
unmounting or so) and not even half full. So what caused the data chunks
all being allocated?

The only thing that I could think of is that I created hourly snapshots
with snapper.
In fact in order to be able to do the balance, I had to delete something
-so I deleted the snapshots.

Can you tell me where I can read about the causes for this problem?
Besides this:
You recommend monitoring the output of btrfs fi show and to do a
balance, whenever unallocated space drops too low. I can monitor this
and let monit send me a message once that happens. Still, I'd like to
know how to make this less likely.

Greetings,
Hendrik


