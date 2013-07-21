Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:23539 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755584Ab3GUQUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jul 2013 12:20:51 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49717 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V0wNM-002gMO-FF
	for linux-btrfs@vger.kernel.org; Sun, 21 Jul 2013 10:20:48 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: autodefrag by default, was: Lots of harddrive chatter
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$3c802$83940fc4$86279b1e$4ddf0e4e@cox.net>
Date: Sun, 21 Jul 2013 10:20:48 -0600
Message-Id: <09A15D35-4874-4650-93F1-1E151076C498@colorremedies.com>
References: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail. com> <ksf42h$suu$1@ger.gmane.org> <pan$3c802$83940fc4$86279b1e$4ddf0e4e@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 21, 2013, at 4:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> What I'd suggest is to turn on the btrfs autodefrag mount option, and to 
> do it *BEFORE* you start installing stuff on the filesystem.

Is there a good reason why autodefrag is not a default mount option?


>  I believe 
> it's a known issue that a number of distro installers (what arch does I'm 
> not sure) tend to fragment their files pretty badly right off the bat if 
> you let them.  This would happen if they write data into an existing 
> file, perhaps because they install a package and then customize the config 
> files, or if they don't write whole files at once.  And a lot of btrfs 
> installs don't turn on the autodefrag option when they do thet first auto-
> mount to install stuff.  

Some installer teams are understandably reluctant to use non-default mount options.

Chris Murphy