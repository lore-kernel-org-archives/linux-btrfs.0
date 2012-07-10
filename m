Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:57003 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab2GJUJo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 16:09:44 -0400
Message-ID: <4FFC8C06.6010800@arndnet.de>
Date: Tue, 10 Jul 2012 22:09:42 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>,
        Christian Robert <christian.robert@polymtl.ca>,
        linux-btrfs@vger.kernel.org
Subject: Re: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in /proc/mounts
References: <4FFB59BF.1050104@arndnet.de> <4FFBA1C8.9020502@polymtl.ca> <4FFBED3C.3000302@arndnet.de> <4FFC6C89.6030303@libero.it> <4FFC7781.5020002@libero.it>
In-Reply-To: <4FFC7781.5020002@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

Am 10.07.2012 20:42, schrieb Goffredo Baroncelli:
> Hi Arnd,
> 
> I am trying to reproduce this bug. Which kernel version are you using ?

I'm using linus' vanilla tree from Sunday which is 3.5.0-rc6
plus some unsuspicious commits.

Best regards
Arnd
