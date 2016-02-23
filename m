Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35115 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbcBWAoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 19:44:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aY15A-00085E-57
	for linux-btrfs@vger.kernel.org; Tue, 23 Feb 2016 01:44:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 01:44:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 01:44:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 1/2] btrfs-progs: copy functionality of
 btrfs-debug-tree to inspect-internal subcommand
Date: Tue, 23 Feb 2016 00:43:58 +0000 (UTC)
Message-ID: <pan$4efde$cf821d81$2d3ab60d$a3a7e1a8@cox.net>
References: <1456152590-24601-1-git-send-email-fougner89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Fougner posted on Mon, 22 Feb 2016 15:49:49 +0100 as excerpted:

> The long-term plan is to merge the features of standalone tools into the
> btrfs binary, reducing the number of shipped binaries.
> 
> Signed-off-by: Alexander Fougner <fougner89@gmail.com>
> ---

Typically, V2+ also includes a short, often one-line, description of what 
changed between versions.  This helps reviewers and others who may have 
reviewed/tested previous versions, or who may simply be interested in 
following the evolution of the patch as it improves toward acceptance and 
merging, since it avoids everyone having to do the diffs for themselves.

It's also useful to others who may be considering submitting their own 
patches, since it can give them hints on avoiding some of the same 
initial mistakes and thus avoiding a round-trip or two, as they may be 
able to correct some of the issues before they post their patches the 
first time (or the second time, if they notice the practice of including 
the changes description on existing patch revision posts and include it 
themselves without anyone having to ask).  =:^)

Unfortunately, while the subject says v2, I don't see any such changes 
since v1 description, here.  =:^(

There's many examples on the list if you need one.  Here's a link to the 
first one I happened to find, a good example of how it can look on 
slightly more advanced patch series of several patches, once they've gone 
thru several revisions.  (Click the topic link on the left to see the 
individual patches, which here don't include individual changelogs as 
they're in the 00/19 post.)

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/53306

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

