Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52398 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab2HFUKl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Aug 2012 16:10:41 -0400
Date: Mon, 6 Aug 2012 16:10:38 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Alexander Block <ablock84@googlemail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: wait_for_more_refs not waking up
Message-ID: <20120806201038.GE8417@shiny>
References: <CAB9VWqBANPS9eQ6reVDBsE-cssp_sEPK2aDAXyQHLtHkBXV_BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB9VWqBANPS9eQ6reVDBsE-cssp_sEPK2aDAXyQHLtHkBXV_BA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 03, 2012 at 01:11:31AM -0600, Alexander Block wrote:
> I got a deadlock happening while creating a snapshot and ordered
> writes are pending. I can reproduce it 100% using btrfs send/receive.
> It happens when I receive a set of streams on a freshly created FS. I
> think I can exclude send/receive as the source of the problem as it
> happens while receiving, even when rebooting between send and receive.
> Receive does not depend on any extra kernel support and only uses
> normal vfs syscalls.

Are you seeing this one on the git tree I sent to Linus?  I triggered
this once and then haven't seen it since I put in the barrier before the
waitqueue active check.

-chris
