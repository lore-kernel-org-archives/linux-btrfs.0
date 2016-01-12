Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54593 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759276AbcALEvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 23:51:53 -0500
Subject: Re: About per-file dedup flag
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <56946E63.1040502@cn.fujitsu.com>
 <pan$e524$5a11cd54$91431292$c1fe13df@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56948655.2090309@cn.fujitsu.com>
Date: Tue, 12 Jan 2016 12:51:33 +0800
MIME-Version: 1.0
In-Reply-To: <pan$e524$5a11cd54$91431292$c1fe13df@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Duncan wrote on 2016/01/12 04:13 +0000:
> Qu Wenruo posted on Tue, 12 Jan 2016 11:09:23 +0800 as excerpted:
>
>> Now we hope to add support to enable/disable dedup per-file.
>> Much like current NODATACOW/NOCOMPRESS for inode.
>
> How is this going to work?
>
> NODATACOW/NOCOMPRESS can apply to a single file.  But a dup flag, by
> definition, needs two files, except for the special case of parts of a
> file duplicating other parts of the same file.  Is there going to be some
> background thread that checks for dups and reflinks duplicated extents if
> both files have the dup flag set?  What if one has it on and one has it
> off?

You are still thinking in the way off-band dedup.

For off-band dedup, we need two extents to compare.

But for in-band dedup, we are not using reflink or similar facility.
Instead, we have a hash pool, recording part or all of our known hashes 
of extents.

So the things should be quite easy to understand:

For normal case (no NODEDUP flag), valid data(page cache) will be hashed 
to find if it's a duplicated one.

For NODEDUP flag case, all its page cache just direct write to disk or 
compressed then write to disk.
No hash will be calculated.

Thanks,
Qu

>
> Presumably, if a file has it on and it is copied (so a new file), the
> copy would be reflinked.  But if the flag is off, does that make the file
> actually data-copy, by default, even if cp decides to do a reflink copy
> by default?  And does the copy automatically have the dup flag set as
> well, or does the original instance set dup, while the new copy, reflinked
> to the old one due to that dup flag, still have the dup flag unset, until
> the user sets it?
>
> OTOH, I can see such an attribute for dirs making more sense, since it
> could be inherited much like the NOCOW attribute, and new files created
> there could automatically be checked against the current files to see if
> parts are dup, and reflink them if so.
>


