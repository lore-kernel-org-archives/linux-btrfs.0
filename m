Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64356 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaAEQ26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 11:28:58 -0500
MIME-Version: 1.0
In-Reply-To: <20140105094639.GA7423@localhost>
References: <20140102053101.GA29352@localhost>
	<CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	<20140105094639.GA7423@localhost>
Date: Sun, 5 Jan 2014 08:28:57 -0800
Message-ID: <CAFR8uefqY95-_unXGOTj6Q5FKV0ZvHh48YxM73WeN-aeNC4o_g@mail.gmail.com>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fengguang,
Instead of rebooting, can you trigger a crash dump when this happens
and send us the backtrace (to start with)?

Kent,
Did you do any btrfs test with your changes?

Regards,
Muthu

On Sun, Jan 5, 2014 at 1:46 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Muthu,
>
> On Fri, Jan 03, 2014 at 11:51:31AM -0800, Muthu Kumar wrote:
>> Looks like Kent missed the btrfs endio in the original commit. How
>> about this patch:
>>
>> ---------
>>
>> In btrfs_end_bio, call bio_endio_nodec on the restored bio so the
>> bi_remaining is accounted for correctly.
>>
>> Reported-by: fengguang.wu@intel.com
>> Cc: Kent Overstreet <kmo@daterainc.com>
>> CC: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
>> --------
>>
>>  fs/btrfs/volumes.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index f2130de..edfed52 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5316,7 +5316,11 @@ static void btrfs_end_bio(struct bio *bio, int err)
>>                 }
>>                 kfree(bbio);
>>
>> -               bio_endio(bio, err);
>> +                /*
>> +                 * Call endio_nodec on the restored bio so the bi_remaining is
>> +                 * accounted for correctly
>> +                 */
>> +               bio_endio_nodec(bio, err);
>>         } else if (!is_orig_bio) {
>>                 bio_put(bio);
>>         }
>
> Interestingly, the BUG message disappeared but it blocks the test run.
> In the end, the test watchdog reboots the machine with SysRq:
>
>         2014-01-04 23:13:02 mount -t btrfs /dev/vda /fs/vda
>         [   20.184264] btrfs: device fsid f0e06999-0518-47e0-a622-21b8749438be devid 1 transid 4 /dev/vda
>         [   20.186552] btrfs: disk space caching is enabled
>         [  131.360457] random: nonblocking pool is initialized
> ==>     [ 1465.069342] SysRq : Emergency Sync
> ==>     [ 1475.071055] SysRq : Resetting
>
> Attached is the full dmesg for a good run (v3.13-rc7) and a bad run
> (this patch).
>
> Thanks,
> Fengguang
