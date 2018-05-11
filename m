Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752165AbeEKJ2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 05:28:46 -0400
Date: Fri, 11 May 2018 11:26:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: stop abusing current->journal_info for direct
 I/O
Message-ID: <20180511092606.GN6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1525933432.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 11:30:09PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Hi, everyone,
> 
> Btrfs currently abuses current->journal_info in btrfs_direct_IO() in
> order to pass around some state to get_block() and submit_io(). This
> hack is ugly and unnecessary because the data we pass around is only
> used in one call frame.

I'd very much like to get rid of the journal_info hack. The changes to
ther filesystems are minimal.

The 3 patches look good to me, you can add my reviewed-by for btrfs
and ack for the rest.  I'm going to do a fstests round too.
