Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34053 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbbERI5o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 04:57:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YuGrm-00065M-MV
	for linux-btrfs@vger.kernel.org; Mon, 18 May 2015 10:57:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 10:57:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 10:57:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs and integration with GNU ++
Date: Mon, 18 May 2015 08:57:32 +0000 (UTC)
Message-ID: <pan$4770b$fa4970d7$3ce3a170$4499f64@cox.net>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Mon, 18 May 2015 06:41:09 +0000 as excerpted:

>> Currently, df seems to show good data, while du doesn't.
> 
> There has been some work put into what df returns to make it so, while
> similar work to du has not yet been released, and in fact only quite
> recently (within the last month) has been proposed on the list.

I should have mentioned... what was proposed on-list was actually a btrfs-
specific btrfs filesystem du command, paralleling the existing btrfs 
filesystem df command...

Unlike the system df command, which AFAIK basically simply prints the 
output given to it by the kernel, the system du command does much more of 
its own work, stating the files and doing the math itself.  And in that 
regard, its output is (or should be) accurate.

What the proposed btrfs specific btrfs filesystem du command would do 
differently compared to the system command, as is the case with pretty 
much all informational btrfs subcommands, is print btrfs specific 
information that the system command doesn't.  In that regard, it would 
be... btrfs specific... and thus belongs under the btrfs master command, 
not as part of the normal system command.

Meanwhile, I just looked it up, and posting date was April 23.
Subject: [Patch][RFC] btrfs-progs: add 'du' command
Original poster/author: Mark Fasheh <mfasheh@suse.de>

Link: http://permalink.gmane.org/gmane.comp.file-systems.btrfs/44657

As posted, the patch calculates device (aka disk) usage of the given file 
set using fiemap.  Printed are device usage, unique/unshared size, and 
(for the file set, not individual files) set shared size (the explanation 
for which is a bit complex, see the thread).  Compression information was 
immediately suggested in a reply, but wasn't considered necessary for a 
first implementation.

If you're seriously interested, consider reading the thread and replying 
there if you have additional suggestions/comments.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

