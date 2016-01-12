Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58580 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbcALFML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 00:12:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aIrFY-0005Vu-5o
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 06:12:08 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 06:12:08 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 06:12:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: About per-file dedup flag
Date: Tue, 12 Jan 2016 05:11:56 +0000 (UTC)
Message-ID: <pan$db46d$a628590c$69427a64$860910d9@cox.net>
References: <56946E63.1040502@cn.fujitsu.com>
	<pan$e524$5a11cd54$91431292$c1fe13df@cox.net>
	<56948655.2090309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Tue, 12 Jan 2016 12:51:33 +0800 as excerpted:

> Duncan wrote on 2016/01/12 04:13 +0000:
>> Qu Wenruo posted on Tue, 12 Jan 2016 11:09:23 +0800 as excerpted:
>>
>>> Now we hope to add support to enable/disable dedup per-file.
>>> Much like current NODATACOW/NOCOMPRESS for inode.
>>
>> How is this going to work?
>>
>> NODATACOW/NOCOMPRESS can apply to a single file.  But a dup flag, by
>> definition, needs two files, except for the special case of parts of a
>> file duplicating other parts of the same file.
> 
> You are still thinking in the way off-band dedup.

> So the things should be quite easy to understand:
> 
> For normal case (no NODEDUP flag), valid data(page cache) will be hashed
> to find if it's a duplicated one.
> 
> For NODEDUP flag case, all its page cache just direct write to disk or
> compressed then write to disk.
> No hash will be calculated.

Oh, _NO_DEDUP.  =:^)

Opposite the dedup logic implied by the subject, with no hint in the 
original post indicating logic actually the reverse of that.

NODEDUP indeed makes more sense, since with a mount or filesystem option 
enabling dedup, it would then be the default and nodedup as a per-file 
exception is the next logical extension.

Thanks.  I knew I must be missing something.  A little negation makes a 
big difference!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

