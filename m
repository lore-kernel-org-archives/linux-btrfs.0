Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56217 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751849AbaH1VjC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 17:39:02 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Undelete files / directory
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <lto6k2$ebq$1@ger.gmane.org>
Date: Thu, 28 Aug 2014 15:39:01 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <922C6C1F-B186-42DD-BEBC-07D4C66BCB20@colorremedies.com>
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net> <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com> <ltnnfo$a57$1@ger.gmane.org> <883EA056-F115-4254-9412-622C07170707@colorremedies.com> <lto6k2$ebq$1@ger.gmane.org>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 28, 2014, at 3:23 PM, Jean-Denis Girard <jd.girard@sysnux.pf> wrote:

> So this seems fine; why is btrfs-find-root not working for me?


Don't know. btrfs-progs 3.16 is current in git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git master branch. It's already built since yesterday in koji for Fedora if you can use RPMs.



> It did recover many files / directories, but unfortunately not my
> photos. Does it mean I discovered my mistake and unmounted the partition
> too late, and the info is lost?

I don't know. How much time between deletion and unmount? And was anything written after deletion and before unmount? I think there is a -d option to only go into a specified directory for recovery. And -D will do a dry run and should show what files will be recovered without recovering them. It may take a long time to actually do a restore only to find out the files you want aren't in it so maybe -D is useful.


Chris Murphy