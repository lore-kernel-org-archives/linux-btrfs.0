Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.24]:52703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaCPQ6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 12:58:17 -0400
Message-ID: <5325D822.6020609@friedels.name>
Date: Sun, 16 Mar 2014 17:58:10 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Arvin Schnell <aschnell@suse.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Snapper on Ubuntu
References: <53245E22.1060407@friedels.name> <20140316121224.GA15418@suse.de>
In-Reply-To: <20140316121224.GA15418@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

 > Just a recommendation about the config names. At least on
 > openSUSE "root" is used for /. I would suggest to use "home_root"
 > for /root like the pam-snapper module does.

thanks for the advise.

In fact on a previous try I had -by chance- used exactly this 
nomenclature. Then I restarted

Now, can I just rename the files in /etc/snapper/configs and the entries 
in /etc/sysconfig/snapper?

Or do I have to start from scratch (remove all snapshots, all 
configurations)?

Regards,
Hendrik
