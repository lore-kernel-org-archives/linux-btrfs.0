Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDYCKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 22:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WdVaW-0001Z1-6T
	for linux-btrfs@vger.kernel.org; Fri, 25 Apr 2014 04:10:04 +0200
Received: from 188-195-2-168-dynip.superkabel.de ([188.195.2.168])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 04:10:04 +0200
Received: from andreas.reis by 188-195-2-168-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 04:10:04 +0200
To: linux-btrfs@vger.kernel.org
From: Andreas Reis <andreas.reis@gmail.com>
Subject: Re: Bug: 
Date: Fri, 25 Apr 2014 02:04:51 +0000 (UTC)
Message-ID: <loom.20140425T035109-565@post.gmane.org>
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com> <5356B1ED.8060608@gmail.com> <pan$df664$93c6c4b1$b586c2f$c5ce83c7@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> Plus, either way you can report back the results and then we'll 
know 
> whether it's safe to recommend btrfs check for the next report, 
or not. 
> =:^)

Well this is just bloody brilliant.

I did btrfs check --repair with from integration and a bunch of 
fixes on this list applied. Failed at the same assert, but 
otherwise left the partition unchanged, ie. mountable.

So as planned, thinking I have a relatively fresh backup of the 
whole partition (via partclone.btrfs), I go on restoring it to 
get rid of the errors.

partclone does its thing, the restored partition mounts, text 
files are properly readable (!) and btrfs check reports no 
errors.

Then on reboot, the kernel (residing on another partition) 
instantly crashes: "Input/Output error".

Turns out that when I try to run any binary from the restored 
partition (via LiveCD), *every* *single* *one* fails with this 
remarkably expressive error. If I manually replace one with a 
fresh download, I get a SIGBUS crash instead.

Oh, and upon accessing any of said binaries, dmesg prints a BTRFS 
info that csum failed. But only for binaries.

Yay. No idea how to proceed from here, but I guess this might not 
necessarily be related to btrfs. Certainly doesn't make me want 
to recommend it in the foreseeable future, though.

