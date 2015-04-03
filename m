Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48332 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbbDCF4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 01:56:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YduaG-0003S8-4m
	for linux-btrfs@vger.kernel.org; Fri, 03 Apr 2015 07:56:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 07:56:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 07:56:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Date: Fri, 3 Apr 2015 05:55:54 +0000 (UTC)
Message-ID: <pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
References: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Fri, 03 Apr 2015 09:21:15 +0800 as excerpted:

> +WARNING: If one hopes to rollback to ext2/3/4, he or she should not execute
> +*btrfs balance* command on converted btrfs.
> +Since it will change the extent layout and make *btrfs-convert* unable to
> +rollback.

Because "since" is subordinating and the sentence doesn't contain what
it is subordinated to as that's explained in the previous sentence,
"Since it will..." introduces a sentence fragment.

Possible correction 1, combine the sentences:  Either simply eliminate
the period following the previous sentence, or convert it to a comma,
either way combining the sentences into one.

Possible correction 2, eliminate the subordinator:  Eliminate "Since"
and begin the second sentence with "A balance..." (replacing "it").

Possible correction 3, reorder and edit, something like this:

+WARNING: Do not execute a *btrfs balance" on a converted btrfs until you
+are sure you will not rollback, as a balance changes the extent layout
+and prevents btrfs-convert from successfully rolling back to ext2/3/4.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

