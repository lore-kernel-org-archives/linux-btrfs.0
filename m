Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:57434 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab2GABXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jun 2012 21:23:07 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id FJbo5z9tzYuGKYN2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Sat, 30 Jun 2012 19:23:01 -0600 (MDT)
Date: Sat, 30 Jun 2012 21:22:59 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Please hammer my for-linus branch
Message-ID: <20120701012259.GM17638@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've got a nice set of fixes from Josef, Jan, Ilya and others in my
for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Some of the changes are fixes for the tree logging code, so I ran some
extra crash runs against them Friday night.

I ended up with a new crash in the tree log directory deletion replay
code, so I didn't send out the pull request to Linus.

It isn't clear yet if the new crash is because I was testing differently
or if it is a regression.  I'm nailing it down this weekend, but please
give my for-linus a shot.

-chris

