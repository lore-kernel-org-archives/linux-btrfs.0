Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42455 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752654AbcKRSvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 13:51:24 -0500
Date: Fri, 18 Nov 2016 19:51:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: check: fix missing newlines
Message-ID: <20161118185114.GH12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <93c639e51b05a52d8cab650f0c8eb3d5fd0ef5bc.1479328997.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <93c639e51b05a52d8cab650f0c8eb3d5fd0ef5bc.1479328997.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 12:54:32PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Also, the other progress messages go to stderr, so "checking extents"
> probably should, as well.
> 
> Fixes: c7a1f66a205f ("btrfs-progs: check: switch some messages to common helpers")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> As a side note, it seems almost completely random whether we print to
> stdout or stderr for any given message. That could probably use some
> cleaning up for consistency. A quick run of e2fsck indicated that it
> prints almost everything on stdout except for usage and administrative
> problems. xfs_repair just seems to put everything in stderr. I
> personally like the e2fsck approach. Anyone have any preference?

Cleaning up the messages is ongoing work, most error messages have been
converted. In case of 'check', I think that stdout is good to capture
normal and error messages (so no error messages are accidentally lost if
the user runs just "check > log" instead of "check >& log").

For that printf is still the way to print them. Besides the verbosity
level could be improved, we've had complaints about that since ever.

Patch applied.
