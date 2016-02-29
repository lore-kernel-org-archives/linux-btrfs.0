Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35256 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbcB2NMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 08:12:12 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Al Viro <viro@ZenIV.linux.org.uk>, Stanislav Brabec <sbrabec@suse.cz>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com> <56D0B782.20606@suse.cz>
 <20160226210302.GE17997@ZenIV.linux.org.uk> <56D0C572.3050503@suse.cz>
 <20160226214514.GG17997@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D44386.8080101@gmail.com>
Date: Mon, 29 Feb 2016 08:11:34 -0500
MIME-Version: 1.0
In-Reply-To: <20160226214514.GG17997@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-26 16:45, Al Viro wrote:
> On Fri, Feb 26, 2016 at 10:36:50PM +0100, Stanislav Brabec wrote:
>
>> It should definitely report error whenever trying -oloop on top of
>> anything else than a file. Or at least a warning.
>>
>> Well, even losetup should report a warning.
>
> Keep in mind that with crypto in the game it just might be useful to have
> loop-over-loop - it might be _not_ a no-op (hell, you might have two
> layers of encryption - not the smartest thing to do, but if that's what
> got dumped on your lap, you deal with what you've got).  So such warnings
> shouldn't be hard errors.
>
That and that using a loop device is one of the ways to expose 
partitions on a device the kernel doesn't normally expose them from.  In 
general, I'm pretty certain the preferred method is to use DM based 
mappings, but those aren't always available, and I've had multiple cases 
where I had to use nested loop devices to get to a filesystem.

You can't protect against everything, but you very much should not be 
doing something that is known to cause issues, and the current behavior 
of mount(8) WRT -o loop definitely can cause issues.
