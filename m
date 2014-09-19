Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48871 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756002AbaISRHI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 13:07:08 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49750 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XV1eE-003Uxj-MN
	for linux-btrfs@vger.kernel.org; Fri, 19 Sep 2014 11:07:07 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with unmountable filesystem.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$ad8f6$a12f1532$9aeffa42$c560f86b@cox.net>
Date: Fri, 19 Sep 2014 11:07:05 -0600
Message-Id: <3DE13319-6E02-4922-BBAC-2DF2895D5892@colorremedies.com>
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com> <54196F42.4030101@gmail.com> <22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com> <541B1263.3090804@gmail.com> <pan$ad8f6$a12f1532$9aeffa42$c560f86b@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Possibly btrfs-select-super can do some of the things I was doing the hard way. It's possible to select a super to overwrite other supers, even if they're "good" ones. Whereas btrfs rescue super-recover won't do that, and neither will btrfsck, hence why I corrupted the one I didn't want first. This command isn't built by default (at least not on Fedora).

Chris