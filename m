Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36084 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968188AbcHBSJ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Aug 2016 14:09:27 -0400
Received: by mail-pa0-f46.google.com with SMTP id pp5so65526024pac.3
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Aug 2016 11:09:26 -0700 (PDT)
Subject: Re: Fixup direct bi_rw modifiers
To: Christoph Hellwig <hch@infradead.org>
References: <1469915148-20452-1-git-send-email-shaun@tancheff.com>
 <20160801114713.GA16806@infradead.org>
 <36734f69-33f5-c2fd-67da-d2d867741403@kernel.dk>
 <a2fbb070-ad57-0015-45d0-2402368ba35e@kernel.dk>
 <20160802123245.GA18679@infradead.org>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Mike Christie <mchristi@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <111bfd53-d89d-d38f-32e5-5e83bad79dbc@kernel.dk>
Date: Tue, 2 Aug 2016 11:09:23 -0700
MIME-Version: 1.0
In-Reply-To: <20160802123245.GA18679@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2016 05:32 AM, Christoph Hellwig wrote:
> On Mon, Aug 01, 2016 at 01:55:36PM -0600, Jens Axboe wrote:
>>
>> Set of three patches, where the target one is an actual bug fix...
>> Temporary branch, I'll rebase it once -rc1 is out, if more
>> changes/fixups need to be made in the next week until that happens.
>>
>> http://git.kernel.dk/cgit/linux-block/log/?h=for-4.8/bi_rwf
>
> Thanks.  Any chance to have a slightly better name for the field?
> E.g. bi_opf or bi_op_flags if we want to be a bit more verbose.

bi_opf is fine with me as well, don't care too strongly about bi_rwf or 
bi_opf. I don't like the longer variants.


-- 
Jens Axboe

