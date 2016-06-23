Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcFWLDH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 07:03:07 -0400
Subject: Re: [PATCH v2] fstests: btrfs: fix 006 adds _runnt_btrfs_util_prog()
To: Eryu Guan <eguan@redhat.com>
References: <1466678252-4058-1-git-send-email-anand.jain@oracle.com>
 <20160623105302.GJ3226@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <24a2491d-91d7-0e45-5008-e784b7a699fd@oracle.com>
Date: Thu, 23 Jun 2016 19:03:59 +0800
MIME-Version: 1.0
In-Reply-To: <20160623105302.GJ3226@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/23/2016 06:53 PM, Eryu Guan wrote:
> On Thu, Jun 23, 2016 at 06:37:32PM +0800, Anand Jain wrote:
>> btrfs fi sync /mnt, now does not output anything for success,
>> so the 006.out should be updated.
>>
>> This change in btrfs-progs was introduced in the commit
>>  b005ca024990569d2de459485682158633937928
>>    btrfs-progs: fi sync: make it silent by default
>>  which was integrated at btrfs-progs version v4.5.2
>
> Thanks!
>
>>
>> Further created helper function _runnt_btrfs_utils_progs()
>> which won't call _fail upon command failure, instead it just
>> echo to stdout. This was required so to continue with the
>> test script and do the cleanups at the end.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2: Update commit log to indicate the btrfs-progs version at
>>     which sync UI is changed.
>>
>>  common/rc           | 11 +++++++++++
>>  tests/btrfs/006     |  2 +-
>>  tests/btrfs/006.out |  1 -
>>  3 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/common/rc b/common/rc
>> index a44fb8750220..2a10fbb2d341 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -3114,6 +3114,17 @@ _min_dio_alignment()
>>      fi
>>  }
>>
>> +run_check_dontfail()
>> +{
>> +	echo "# $@" >> $seqres.full 2>&1
>> +	"$@" >> $seqres.full 2>&1 || echo "failed: '$@'"
>> +}
>> +
>> +_runnt_btrfs_util_prog()
>> +{
>> +	run_check_dontfail $BTRFS_UTIL_PROG $*
>> +}
>> +
>>  run_check()
>>  {
>>  	echo "# $@" >> $seqres.full 2>&1
>> diff --git a/tests/btrfs/006 b/tests/btrfs/006
>> index 715fd80fb6fc..9d1fe09e07de 100755
>> --- a/tests/btrfs/006
>> +++ b/tests/btrfs/006
>> @@ -79,7 +79,7 @@ echo "== Show filesystem by UUID"
>>  $BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
>>
>>  echo "== Sync filesystem"
>> -$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
>> +_runnt_btrfs_util_prog filesystem sync $SCRATCH_MNT
>
> Still, I don't think this helper is necessary.
>
> $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null
>
> doesn't _fail on failure, output error messages breaks golden image, and
> is much simpler. Do I miss anything?

  runnt_btrfs_util_prog() checks the return status of the command,
  if failed (!0) it will echo so to break the golden image.

Thanks, Anand


> Thanks,
> Eryu
>>
>>  echo "== Show device stats by mountpoint"
>>  $BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats $TOTAL_DEVS
>> diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
>> index 22bcb777076a..05b9ac020737 100644
>> --- a/tests/btrfs/006.out
>> +++ b/tests/btrfs/006.out
>> @@ -14,7 +14,6 @@ Label: 'TestLabel.006'  uuid: <EXACTUUID>
>>  	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>>
>>  == Sync filesystem
>> -FSSync 'SCRATCH_MNT'
>>  == Show device stats by mountpoint
>>  <NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
>>  <NUMDEVS> [SCRATCH_DEV].flush_io_errs   <NUM>
>> --
>> 2.7.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
