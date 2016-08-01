Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37537 "EHLO
	mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbcHATzj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 15:55:39 -0400
Received: by mail-it0-f43.google.com with SMTP id f6so181019041ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 12:55:39 -0700 (PDT)
Subject: Re: Fixup direct bi_rw modifiers
To: Christoph Hellwig <hch@infradead.org>, Shaun Tancheff <shaun@tancheff.com>
References: <1469915148-20452-1-git-send-email-shaun@tancheff.com>
 <20160801114713.GA16806@infradead.org>
 <36734f69-33f5-c2fd-67da-d2d867741403@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Mike Christie <mchristi@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a2fbb070-ad57-0015-45d0-2402368ba35e@kernel.dk>
Date: Mon, 1 Aug 2016 13:55:36 -0600
MIME-Version: 1.0
In-Reply-To: <36734f69-33f5-c2fd-67da-d2d867741403@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2016 09:17 AM, Jens Axboe wrote:
> On 08/01/2016 05:47 AM, Christoph Hellwig wrote:
>> On Sat, Jul 30, 2016 at 04:45:48PM -0500, Shaun Tancheff wrote:
>>> bi_rw should be using bio_set_op_attrs to set bi_rw.
>>
>> Looks fine,
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Added, thanks Shaun.
>
>> Jens,
>>
>> what do you think about renaming bi_rw?  There aren't too many users
>> left, and any old code that would keep using it is alsmost guranteed
>> to be broken, so sending a post-rc1 patch to rename it might make
>> everyone else life easier.  Especially as it's also grossly misnamed
>> now.
>
> I was planning on doing that, after -rc1. Much better to get build
> breakage, than potentially much worse breakage.

Set of three patches, where the target one is an actual bug fix...
Temporary branch, I'll rebase it once -rc1 is out, if more
changes/fixups need to be made in the next week until that happens.

http://git.kernel.dk/cgit/linux-block/log/?h=for-4.8/bi_rwf

-- 
Jens Axboe

