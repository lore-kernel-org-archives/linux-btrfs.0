Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab3JXObe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:31:34 -0400
Date: Thu, 24 Oct 2013 16:31:30 +0200
From: David Sterba <dsterba@suse.cz>
To: lilofile <lilofile82@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5 bug task mkfs.btrfs:3695 blocked for more than 120
 seconds
Message-ID: <20131024143130.GB28149@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAC+R54AkkkfvKYQBkAvF5651X3FS_r7PHN-WYYgkH=wp08aejg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC+R54AkkkfvKYQBkAvF5651X3FS_r7PHN-WYYgkH=wp08aejg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 24, 2013 at 10:22:28PM +0800, lilofile wrote:
> Oct 24 21:25:36 host1 kernel: [ 3000.809563]  [<ffffffff81315c14>]
> blkdev_issue_discard+0x1b4/0x1c0

There's an discard/TRIM operation being done on all of the devices,
current progs do not report that and it's really confusing. Fixed in
integration branch.

If you don't want to do the trim, use the -K switch.

david
