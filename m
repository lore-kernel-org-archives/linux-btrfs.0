Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42240 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbaJ1WpH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 18:45:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XjFVg-0000Kg-6G
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 23:45:04 +0100
Received: from ip4d160011.dynamic.kabel-deutschland.de ([77.22.0.17])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 23:45:04 +0100
Received: from Ansgar.Hockmann-Stolle by ip4d160011.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 23:45:04 +0100
To: linux-btrfs@vger.kernel.org
From: Ansgar Hockmann-Stolle <Ansgar.Hockmann-Stolle@uni-osnabrueck.de>
Subject: Re: btrfs unmountable: read block failed =?utf-8?b?Y2hlY2tfdHJlZV9ibG9jazs=?= Couldn't read tree root
Date: Tue, 28 Oct 2014 22:42:11 +0000 (UTC)
Message-ID: <loom.20141028T230928-805@post.gmane.org>
References: <544E4747.2000008@uni-osnabrueck.de> <pan$db558$7ef21104$8d3c61ca$273592f9@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

[..]
> 
> Hope that helps! =:^)
> 

Thanks a lot for that many hints!
Unfortunately, btrfs restore does not find the tree root and so it does not
find anything.

I will wait for Qu Wenruo to enhance chunk-recovering.
And in the meantime I will test openSUSE 13.2-RC1 by installing a fresh copy
of it. I have the dd dump and a working copy of it to test. And backups ...
I told each friend I helped in the last years to make regular backups but me
... ;-)

Thanks,
Ansgar


