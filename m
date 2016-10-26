Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19479 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753211AbcJZBHd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 21:07:33 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: fsck: Add support to clear v1 free space
 cache.
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
 <20161025140934.GQ22935@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6845d4d0-c276-31b4-a8d7-21c6b5303adf@cn.fujitsu.com>
Date: Wed, 26 Oct 2016 09:07:25 +0800
MIME-Version: 1.0
In-Reply-To: <20161025140934.GQ22935@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/25/2016 10:09 PM, David Sterba wrote:
> On Thu, Oct 13, 2016 at 05:22:26PM +0800, Qu Wenruo wrote:
>> Kernel clear_cache mount option will only rebuilt free space cache if
>> used space of that chunk has changed.
>>
>> So it won't ensure any corrupted free space cache get cleared.
>>
>> So add a new option "--clear-space-cache v1|v2" to btrfsck, to
>> completely wipe out free space cache.
>> So kernel won't complain again.
>>
>> Reported-by: Ivan P <chrnosphered@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Applied with the attached diff, use it as a review feedback.
>
>
Thanks for the diff, quite helpful.

But I'm a little concerned about the minor coding styling.

1) For non-zero comparison
-				if (strcmp(optarg, "v1")) {
+				if (strcmp(optarg, "v1") != 0) {

Is it recommended to use "!= 0" other than hiding it?
I often see code hiding the "!= 0", so I'm a little curious about this.

2) Long string indent
-			error("failed to locate free space cache extent for block group %llu",
-			      bg->key.objectid);
+			error(
+	"failed to locate free space cache extent for block group %llu: %d",
+				bg->key.objectid, ret);

Kernel coding style allows us to use string longer than 80 chars, so we 
don't need to break long string.

But I'm not sure if we should change the indent.
Normally I just keep the string at the same line of error()/warning(), 
as we have no 80 chars limit.

Or we should change indent to allow them fit in 80 chars?
IIRC I did it several times in kernel or btrfs-progs, but it seems to be 
modified to same line version.

Thanks,
Qu


