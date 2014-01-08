Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbaAHVWG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 16:22:06 -0500
Message-ID: <52CDC140.6090307@kernel.dk>
Date: Wed, 08 Jan 2014 14:21:04 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, "muthu.lkml@gmail.com" <muthu.lkml@gmail.com>
CC: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
References: <20140102053101.GA29352@localhost>	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>	 <20140106221036.GE9037@kmo>	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>	 <20140107055318.GA19016@localhost>	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com> <1389215654.23310.39.camel@ret.masoncoding.com>
In-Reply-To: <1389215654.23310.39.camel@ret.masoncoding.com>
Content-Type: text/plain; charset=UTF-7
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/08/2014 02:13 PM, Chris Mason wrote:
> On Tue, 2014-01-07 at 12:15 -0800, Muthu Kumar wrote:
>> Thanks Fengguang. Final patch with added comment. BTW, fengguang
>> mentioned that git-am has trouble with the inline patch and "quilt
>> import" worked fine for him...
>>
>> ------------
>> In btrfs_end_bio(), we increment bi_remaining if is_orig_bio. If not,
>> we restore the orig_bio but failed to increment bi_remaining for
>> orig_bio, which triggers a BUG_ON later when bio_endio is called. Fix
>> is to increment bi_remaining when we restore the orig bio as well.
>>
>> Reported-and-Tested-by: Fengguang wu <fengguang.wu@intel.com>
>> CC: Kent Overstreet <kmo@daterainc.com>
>> CC: Jens Axboe <axboe@kernel.dk>
>> CC: Chris Mason <clm@fb.com>
>> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
>>
> 
> Reviewed-by: Chris Mason <clm@fb.com>
> 
> Jens, please pull this one in.

Done, with the added reviewed and tested-by's.

-- 
Jens Axboe

