Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbbASSIA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 13:08:00 -0500
Date: Mon, 19 Jan 2015 19:07:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: tests, add support for running commands
 under root
Message-ID: <20150119180758.GD13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1421256302-8503-1-git-send-email-dsterba@suse.cz>
 <54B70AE0.2090203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54B70AE0.2090203@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Most of the checks run fine without root, but some of them may need to
> > do a mount test or access the data. Add the support to selectively run
> > commands under root, hardcoded to sudo for now.
> I'm a little worried about using sudo in such test.

Opposed to running the whole testsuite as root? Most tests are fine to
be run under the user privileges.

> If the test is ran by a script, test will be stuck waiting for input and 
> timeout after a long time.

Good point, I'll add --non-interactive that will abort in that case.

> I prefer NOT RUN just like xfstests.

But xfstests do not run if there's a missing implementation or
incomplete testing setup, ie. something that cannot be fixed by other
means.
