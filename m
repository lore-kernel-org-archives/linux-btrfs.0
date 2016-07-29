Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i5.italiaonline.it ([212.48.25.234]:54597 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751055AbcG2FIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 01:08:47 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 2/5] New btrfs command: "btrfs inspect physical-find"
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
 <1469641398-3879-3-git-send-email-kreijack@libero.it>
 <8b013280-7128-d6e4-2f62-b43851d6f6cd@cn.fujitsu.com>
 <2d33450d-3805-da54-a5e8-2fefde075957@libero.it>
 <c5c247b7-2e4d-3f4b-7cc4-b44f749a7a10@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <46c7bfc1-8e7a-3a0e-db56-889cf7a324d3@inwind.it>
Date: Fri, 29 Jul 2016 07:08:43 +0200
MIME-Version: 1.0
In-Reply-To: <c5c247b7-2e4d-3f4b-7cc4-b44f749a7a10@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-29 03:34, Qu Wenruo wrote:
>> I am not against about your proposal; however I have to point out
>> that the goal of these command was not to *traverse* the file, but
>> only to found the physical location of a file offset. My use case
>> was to simulate a corruption of a raid5 stripe elements: for me it
>> was sufficient to know the page position.
> 
> For corruption case, the best practice would be extending
> btrfs-corrupt-block command.
> 
> And for your original proposal, to locate a page/sector containing
> the bytenr/offset, then the returned value should always be aligned
> to sectorsize. (And we need to state it clear in both man page and
> help string)
> 
> Unfortunately, that's not the case in current implementation. (And
> don't forget future subpage sector size, so in that case, we need to
> check sectorsize first.)
> 
> For example, if user passes a unaligned logical, physical-find will
> return the device offset unaligned.

For the other command (physical-dump), there is a check about the
alignment; the reason was to simplify the dump of the content.
However I don't understand to the reason to ask for the alignment
even in the -find tool: why the output have to be aligned ? Which is
the difference if I return the first byte address of the file than the
2nd or the 3rd (taking in account all the detail, which for raid5/6
is not very easy....)

> 
> If only to locate the stripe/sector, at least returning a aligned
> number seems more reasonable.
> 
> IMHO if we only want a simple tool, then make it clear it's a just
> simple tool, and add limitation and explain to make it simple and
> won't accept any complext/unexpected input.
> 
> Or, make it handle unexpected and complex input well.
> 
> 
> BTW, long time ago, btrfs-map-logical is under the same situation,
> just a simple tool do off-line logical->device offset mapping. But it
> since it does provides offset/length pair options, it can cause wrong
> or uesless result for unaligned input. And we spent some time to
> improve it.
> 
> So I hope we can avoid such problem which has already happened in
> map-logical.


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
