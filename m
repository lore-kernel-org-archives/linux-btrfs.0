Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46182 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaJQMai (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 08:30:38 -0400
Date: Fri, 17 Oct 2014 14:30:36 +0200
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141017123036.GA8052@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
 
> the core of skinny-metadata feature has been merged in 3.10 (Jun 2013)
> and has been reportedly used by many people. No major bugs were reported
> lately unless I missed them.

  so far I haven't succeeded running btrfs balance on a large
skinny-metadata fs -- segfault, kernel bug, reproducible.  No such
problems on ^skinny-metadata fs (same disks, same data).  Tried both
several times on 3.17.  More info in comments 10,14 in
https://bugzilla.kernel.org/show_bug.cgi?id=64961


Regards,

Petr
