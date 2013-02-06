Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47588 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3BFQgs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 11:36:48 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D03C19A03EE
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Feb 2013 09:36:47 -0700 (MST)
Date: Wed, 6 Feb 2013 11:36:45 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: btrfs-progs pull request for coverity fixes
Message-ID: <20130206163645.GO20797@shiny>
References: <20130206004907.GN14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130206004907.GN14246@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 05:49:07PM -0700, Zach Brown wrote:
> Hi gang,
> 
> Eric and I went through the warnings that a Coverity scan raised against
> the reasonably recent btrfs-progs that's in Fedora.  We tried to tackle
> the lowest hanging fruit: these are the most obvious and least risky
> fixes.

Awesome, thanks Zach and Eric.  I've got this rebased on top of Dave's
integration pull from today, and I'm doing a bunch of tests.

-chris
