Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37431 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756771AbaISRyp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 13:54:45 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49786 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XV2OK-003tSC-Lt
	for linux-btrfs@vger.kernel.org; Fri, 19 Sep 2014 11:54:44 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with unmountable filesystem.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54196F42.4030101@gmail.com>
Date: Fri, 19 Sep 2014 11:54:43 -0600
Message-Id: <9D39D5EC-0614-4A7A-8D72-CBC51EFBB26D@colorremedies.com>
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com> <54196F42.4030101@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 17, 2014, at 5:23 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

[   30.920536] BTRFS: bad tree block start 0 130402254848
[   30.924018] BTRFS: bad tree block start 0 130402254848
[   30.926234] BTRFS: failed to read log tree
[   30.953055] BTRFS: open_ctree failed

I'm still confused. Btrfs knows this tree root is bad, but it has backup roots. So why wasn't one of those used by -o recovery? I thought that's the whole point of that mount option. Backup tree roots are per superblock, so conceivably you'd have up to 8 of these with two superblocks, they're shown with
btrfs-show-super -af  ## and -F even if a super is bad

But skipping that, to fix this you need to know which super is pointing to the wrong tree root, since you're using ssd mount option with rotating supers. I assume mount uses the super with the highest generation number. So you'd need to:
btrfs-show-super -a
to find out the super with the most recent generation. You'd assume that one was wrong. And then use btrfs-select-super to pick the right one, and replace the wrong one. Then you could mount.

I also wonder if btrfs check -sX would show different results in your case. I'd think it would because it ought to know one of those tree roots is bad, seeing as mount knows it. And then it seems (I'm speculating a ton) that --repair might try to fix the bad tree root, and then if it fails I'd like to think it can just find the most recent good tree root, ideally one listed as a backup_tree_root by any good superblock, and then have the next mount use that.

I'm not sure why this persistently fails, and I wonder if there are cases of users giving up and blowing away file systems that could actually be mountable. But it's just really a manual process figuring out what things to do in what order to get them to mount. 


Chris Murphy