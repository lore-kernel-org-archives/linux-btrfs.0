Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbbAUSdL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 13:33:11 -0500
Date: Wed, 21 Jan 2015 19:33:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Drop feature defines from C files, in favour of CFLAGS
 defines.
Message-ID: <20150121183308.GJ13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421545978-19661-1-git-send-email-dimitri.j.ledkov@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421545978-19661-1-git-send-email-dimitri.j.ledkov@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 18, 2015 at 01:52:58AM +0000, Dimitri John Ledkov wrote:
> glibc 2.10+ (5+ years old) enables all the desired features:
> _XOPEN_SOURCE 700, __XOPEN2K8, POSIX_C_SOURCE, DEFAULT_SOURCE; with a
> single _GNU_SOURCE define in the makefile alone. For portability to
> other libc implementations (e.g. dietlibc) _XOPEN_SOURCE=700 is also
> defined.

Sounds reasonable to me.

> This also resolves Debian bug report filed by Michael Tautschnig -
> "Inconsistent use of _XOPEN_SOURCE results in conflicting
> declarations". Whilst I was not able to reproduce the results, the
> reported fact is that _XOPEN_SOURCE set to 500 in one set of files
> (e.g. cmds-filesystem.c) generates/defines different struct stat from
> other files (cmds-replace.c).
> 
> This patch thus cleans up all feature defines, and sets them at a
> consistent level.

Thanks, applied.
