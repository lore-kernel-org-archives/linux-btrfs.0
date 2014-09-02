Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIBL5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 07:57:53 -0400
Date: Tue, 2 Sep 2014 13:57:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs-progs: Show backtrace on BUGs
Message-ID: <20140902115750.GF5888@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <87zjey82x4.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zjey82x4.fsf@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 09:04:07PM +0900, Naohiro Aota wrote:
> "btrfs check" is still under heavy development and so there are some
> BUGs beging hit. "btrfs check" can be run on limited environment which
> lacks gdb to debug the abort in detail. If we could see backtrace, it
> will be easier to find a root cause of the BUG.

I like adding the backtraces, I'm only concerned about switching it on
by default. Please add a compile-time option to use the backtrace
enhanced macros or fallback to what's there right now. Also we'll
probably need a makefile switch to enable it, possibly with more
debugging options. The expected user of the backtraces are developers,
the end users should not see the bug_ons at all, in the long term.
