Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906AbcCURlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:41:08 -0400
Date: Mon, 21 Mar 2016 18:40:39 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs-progs: fix fi du so it works in more cases
Message-ID: <20160321174039.GB8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458562991-6882-1-git-send-email-ahferroin7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458562991-6882-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 08:23:11AM -0400, Austin S. Hemmelgarn wrote:
> Currently, btrfs fi du uses open_file_or_dir(), which tries to open
> it's argument with o_RDWR.  Because of POSIX semantics, this fails for
> non-root users when the file is read-only or is an executable that
> is being run currently, or for all users (including root) when the
> filesystem is read-only.  THis results in a somewhat confusing 'Unknown
> error -1' message when trying to check such files.  Switch to using
> open_file_or_dir3() with O_RDONLY passed in the flags, as this avoids
> the limitations listed above, and we have no need to write to the files
> anyway (and thus shouldn't be opening them writable).
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Applied, thanks.

> ---
> Build and runtime tested on x86-64 with glibc.
> 
> I intend to take the time at some point this week to audit all users of
> open_file_or_dir() and similarly change any that don't need to write
> to what they're opening, possibly adding a helper function to do a
> read-only open.

Thanks. I think using open_file_or_dir3(path, &dirstream, O_RDONLY) is
ok, no need for a helper.
