Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:63798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaCYUDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 16:03:31 -0400
Message-ID: <5331E10E.6080806@friedels.name>
Date: Tue, 25 Mar 2014 21:03:26 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: free space inode generation (0) did not match free space cache
 generation
References: <532DF38B.40409@friedels.name> <532DFDAB.7000600@friedels.name>	<pan$b7ff$285d59f6$2419371$b3946ebe@cox.net>	<53309AF9.8090203@friedels.name> <pan$8258b$aea97c0c$211631c9$d306a8a9@cox.net>
In-Reply-To: <pan$8258b$aea97c0c$211631c9$d306a8a9@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> Well, given the relative immaturity of btrfs as a filesystem at this
> point in its lifetime, I think it's acceptable/tolerable.  However, for a
> filesystem feted[1] to ultimately replace the ext* series as an assumed
> Linux default, I'd definitely argue that the current situation should be
> changed such that btrfs can automatically manage its own de-allocation at
> some point, yes, and that said "some point" really needs to come before
> that point at which btrfs can be considered an appropriate replacement
> for ext2/3/4 as the assumed default Linux filesystem of the day.

Agreed! I hope, this is on the ToDo List?!

> [1] feted: celebrated, honored.  I had to look it up to be sure my
> intuition on usage was correct, and indeed I had spelled it wrong

:-)


Greetings,
Hendrik
