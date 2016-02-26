Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:52246 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbcBZVDE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 16:03:04 -0500
Date: Fri, 26 Feb 2016 21:03:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
Message-ID: <20160226210302.GE17997@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz>
 <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz>
 <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk>
 <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com>
 <56D0B782.20606@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D0B782.20606@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 09:37:22PM +0100, Stanislav Brabec wrote:

> Do I understand, that you are saying:
> 
> Yes, mounting multiple loop devices associated with one file is a
> legitimate use, but mount(8) should never do it, because it has other
> ugly side effects?

It's on the same level as "hey, let's have an nbd daemon run in qemu
guest, exporting a host file over nbd, import it to host as /dev/nbd69,
set a loopback device over the underlying file as /dev/loop42 and
ask e.g. xfs to recognize that it's dealing with the same underlying array
of bytes in both cases - wouldn't it be neat if it could do that?"

There's no magic.  Really.  Unexpected sharing of backing store between
apparently unrelated devices can cause trouble.  And I'm not sure how
to deal with -o loop in a sane way, TBH - automagical losetup is bloody
hard to get right.  Keep in mind that loop-over-loop is also possible...
