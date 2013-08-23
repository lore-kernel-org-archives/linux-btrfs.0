Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:16806 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3HWNG1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 09:06:27 -0400
Message-ID: <52175E4F.40207@giantdisaster.de>
Date: Fri, 23 Aug 2013 15:06:23 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: update filters and output of btrfs/006
References: <1376672566-5446-1-git-send-email-sbehrens@giantdisaster.de> <520E5D07.6090708@sandeen.net>
In-Reply-To: <520E5D07.6090708@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 16 Aug 2013 12:10:31 -0500, Eric Sandeen wrote:
> On 8/16/13 12:02 PM, Stefan Behrens wrote:
>> The btrfs-progs tools changed the output:
>> - 100GiB instead of 100GB
>> - The number of spaces was changed
> 
> ugh.
> 
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  common/filter       |  2 +-
>>  common/filter.btrfs |  3 ++-
>>  tests/btrfs/006     |  6 +++---
>>  tests/btrfs/006.out | 36 ++++++++++++++++++------------------
>>  4 files changed, 24 insertions(+), 23 deletions(-)
>>
>> diff --git a/common/filter b/common/filter
>> index dbb1674..ee738ca 100644
>> --- a/common/filter
>> +++ b/common/filter
>> @@ -262,7 +262,7 @@ _filter_uuid()
>>  # Filter out sizes like 6.14MB etc
>>  _filter_size()
>>  {
>> -	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][b]\?/<SIZE>/ig"
>> +	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][i]\?[b]\?/<SIZE>/ig"
>>  }
> 
> makes sense
> 
> But for the rest, is the output change intentional, or sloppiness/accidental?
> 
> If it's really intentional, then:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 

Thanks for the review, Eric!

Since this commit is not yet added to the repo, I just took the time to
create a cleaner fix.

The tools didn't change the number of spaces in the output. The root
cause was that I had 11 devices in SCRATCH_DEV_POOL for the first time.
And this caused changes in the number of spaces in the output wherever
things like %4d was used.

One problem was the output of "uniq -c" which added spaces depending
on the size of the count value (e.g. one space less for 10+ devices).

The second problem was that "btrfs fi show" was doing the same:
"devid %4llu size %s used %s path %s".

Please scratch this patch out, I'll send two better patches instead
which address the real problems.


>>  # Convert string read from stdin like 128K to bytes and print it to stdout
>> diff --git a/common/filter.btrfs b/common/filter.btrfs
>> index e9a2bc2..1584596 100644
>> --- a/common/filter.btrfs
>> +++ b/common/filter.btrfs
>> @@ -33,6 +33,7 @@ _filter_btrfs_filesystem_show()
>>  	# the uniq collapses all device lines into 1
>>  	_filter_uuid $UUID | _filter_scratch | _filter_scratch_pool | \
>>  	_filter_size | _filter_btrfs_version | _filter_devid | \
>> +	_filter_spaces | \
>>  	sed -e "s/\(Total devices\) $NUMDEVS/\1 $NUM_SUBST/g" | \
>>  	uniq
>>  }
>> @@ -51,7 +52,7 @@ _filter_btrfs_device_stats()
>>  		UNIQ_OPT=""
>>  	fi
>>  
>> -	_filter_scratch | _filter_scratch_pool | \
>> +	_filter_scratch | _filter_scratch_pool | _filter_spaces | \
>>  	sed -e "s/[0-9]\+$/<NUM>/g" | sort | uniq $UNIQ_OPT | \
>>  	sed -e "s/$NUMDEVS /<NUMDEVS> /g"
>>  }
>> diff --git a/tests/btrfs/006 b/tests/btrfs/006
>> index 9f7beff..f323cc4 100755
>> --- a/tests/btrfs/006
>> +++ b/tests/btrfs/006
>> @@ -82,13 +82,13 @@ echo "== Sync filesystem"
>>  $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
>>  
>>  echo "== Show device stats by mountpoint"
>> -$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats $TOTAL_DEVS
>> +$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats $TOTAL_DEVS | _filter_spaces
>>  echo "== Show device stats by first/scratch dev"
>>  $BTRFS_UTIL_PROG device stats $SCRATCH_DEV | _filter_btrfs_device_stats
>>  echo "== Show device stats by second dev"
>> -$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g"
>> +$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g" | _filter_spaces
>>  echo "== Show device stats by last dev"
>> -$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g"
>> +$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g" | _filter_spaces
>>  
>>  # success, all done
>>  status=0
>> diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
>> index ab33b7e..413a5a8 100644
>> --- a/tests/btrfs/006.out
>> +++ b/tests/btrfs/006.out
>> @@ -4,38 +4,38 @@
>>  TestLabel.006
>>  == Mount.
>>  == Show filesystem by label
>> -Label: 'TestLabel.006'  uuid: <UUID>
>> +Label: 'TestLabel.006' uuid: <UUID>
>>  	Total devices <EXACTNUM> FS bytes used <SIZE>
>> -	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>> +	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>>  
>>  == Show filesystem by UUID
>> -Label: 'TestLabel.006'  uuid: <EXACTUUID>
>> +Label: 'TestLabel.006' uuid: <EXACTUUID>
>>  	Total devices <EXACTNUM> FS bytes used <SIZE>
>> -	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>> +	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>>  
>>  == Sync filesystem
>>  FSSync 'SCRATCH_MNT'
>>  == Show device stats by mountpoint
>> -      <NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
>> -      <NUMDEVS> [SCRATCH_DEV].flush_io_errs   <NUM>
>> -      <NUMDEVS> [SCRATCH_DEV].generation_errs <NUM>
>> -      <NUMDEVS> [SCRATCH_DEV].read_io_errs    <NUM>
>> -      <NUMDEVS> [SCRATCH_DEV].write_io_errs   <NUM>
>> + <NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
>> + <NUMDEVS> [SCRATCH_DEV].flush_io_errs <NUM>
>> + <NUMDEVS> [SCRATCH_DEV].generation_errs <NUM>
>> + <NUMDEVS> [SCRATCH_DEV].read_io_errs <NUM>
>> + <NUMDEVS> [SCRATCH_DEV].write_io_errs <NUM>
>>  == Show device stats by first/scratch dev
>>  [SCRATCH_DEV].corruption_errs <NUM>
>> -[SCRATCH_DEV].flush_io_errs   <NUM>
>> +[SCRATCH_DEV].flush_io_errs <NUM>
>>  [SCRATCH_DEV].generation_errs <NUM>
>> -[SCRATCH_DEV].read_io_errs    <NUM>
>> -[SCRATCH_DEV].write_io_errs   <NUM>
>> +[SCRATCH_DEV].read_io_errs <NUM>
>> +[SCRATCH_DEV].write_io_errs <NUM>
>>  == Show device stats by second dev
>> -[FIRST_POOL_DEV].write_io_errs   0
>> -[FIRST_POOL_DEV].read_io_errs    0
>> -[FIRST_POOL_DEV].flush_io_errs   0
>> +[FIRST_POOL_DEV].write_io_errs 0
>> +[FIRST_POOL_DEV].read_io_errs 0
>> +[FIRST_POOL_DEV].flush_io_errs 0
>>  [FIRST_POOL_DEV].corruption_errs 0
>>  [FIRST_POOL_DEV].generation_errs 0
>>  == Show device stats by last dev
>> -[LAST_POOL_DEV].write_io_errs   0
>> -[LAST_POOL_DEV].read_io_errs    0
>> -[LAST_POOL_DEV].flush_io_errs   0
>> +[LAST_POOL_DEV].write_io_errs 0
>> +[LAST_POOL_DEV].read_io_errs 0
>> +[LAST_POOL_DEV].flush_io_errs 0
>>  [LAST_POOL_DEV].corruption_errs 0
>>  [LAST_POOL_DEV].generation_errs 0
>>
> 

