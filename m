Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:52655 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423201AbcBZVpR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 16:45:17 -0500
Date: Fri, 26 Feb 2016 21:45:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
Message-ID: <20160226214514.GG17997@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz>
 <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz>
 <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk>
 <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com>
 <56D0B782.20606@suse.cz>
 <20160226210302.GE17997@ZenIV.linux.org.uk>
 <56D0C572.3050503@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D0C572.3050503@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 10:36:50PM +0100, Stanislav Brabec wrote:

> It should definitely report error whenever trying -oloop on top of
> anything else than a file. Or at least a warning.
> 
> Well, even losetup should report a warning.

Keep in mind that with crypto in the game it just might be useful to have
loop-over-loop - it might be _not_ a no-op (hell, you might have two
layers of encryption - not the smartest thing to do, but if that's what
got dumped on your lap, you deal with what you've got).  So such warnings
shouldn't be hard errors.
