Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35302 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaDYCni (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 22:43:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WdW6s-0000y0-DL
	for linux-btrfs@vger.kernel.org; Fri, 25 Apr 2014 04:43:30 +0200
Received: from 188-195-2-168-dynip.superkabel.de ([188.195.2.168])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 04:43:30 +0200
Received: from andreas.reis by 188-195-2-168-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 04:43:30 +0200
To: linux-btrfs@vger.kernel.org
From: Andreas Reis <andreas.reis@gmail.com>
Subject: Re: Bug: Partition borked
Date: Fri, 25 Apr 2014 02:43:17 +0000 (UTC)
Message-ID: <loom.20140425T043341-931@post.gmane.org>
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com> <5356B1ED.8060608@gmail.com> <pan$df664$93c6c4b1$b586c2f$c5ce83c7@cox.net> <loom.20140425T035109-565@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Reis <andreas.reis <at> gmail.com> writes:

> Turns out that when I try to run any binary from the restored 
> partition (via LiveCD), *every* *single* *one* fails with this 
> remarkably expressive error. If I manually replace one with a 
> fresh download, I get a SIGBUS crash instead.

Alright, there are corrupt text files too, after all. As well as a 
handful or non-corrupted binaries.

Always the same type of btrfs error message though. Interestingly, 
the false csum reported stays exactly the same: 2566472073. Also, 
btrfs check --init-csum-tree fails with a plethora of backref 
errors.

Guess it doesn't matter whether it's the backup or the LiveCD's 
kernel (3.13.7) that's at fault, I'm going to have to reinstall 
either way.

