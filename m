Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbeF1LUJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 07:20:09 -0400
Subject: Re: [GIT PULL] Btrfs updates for 4.18
To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1528125657.git.dsterba@suse.com>
 <CAL3q7H7iLCPxA01811RJK-bEiRPAGJdTrHLogJr2a3Sq1g0k4g@mail.gmail.com>
 <e315b073-05f9-7280-d1ee-4d0456085720@oracle.com>
 <CAL3q7H6EwxMVCM7-cfwb119eCaYAaVo3Go64jE99Z9y04igV5w@mail.gmail.com>
 <20180611161508.GA24375@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ff25bbd0-33ce-4787-da4b-9025d381593a@oracle.com>
Date: Thu, 28 Jun 2018 19:22:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180611161508.GA24375@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/12/2018 12:16 AM, David Sterba wrote:
> On Mon, Jun 11, 2018 at 10:50:54AM +0100, Filipe Manana wrote:
>>>>>         btrfs: replace uuid_mutex by device_list_mutex in
>>>>> btrfs_open_devices
> 
>>>>    *
>>>>    * the mutex can be very coarse and can cover long-running operations
>>>>    *
>>>>    * protects: updates to fs_devices counters like missing devices, rw
>>>> devices,
>>>>    * seeding, structure cloning, openning/closing devices at mount/umount
>>>> time
>>>>
>>>> generates some confusion since btrfs_open_devices(), after that
>>>> commit, no longer takes the uuid_mutex and it
>>>> updates some fs_devices counters (opened, open_devices, etc).
>>>
>>>   As uuid_mutex is a global fs_uuids lock for the per fsid operations
>>>   doesn't make any sense.
>>>
>>>   This problem is reproducible only for-4.18, misc-next if fine.
>>>   I am looking deeper.
>>
>> What about the unprotected updates (increments) to fs_devices->opened
>> and fs_devices->open_devices?
>> Other functions are accessing/updating them while holding the uuid mutex.
> 
> The goal is to reduce usage of uuid_mutex only to protect search or
> update of the fs_uuids list, everything else should be protected by the
> device_list_mutex.
> 
> The commit 542c5908abfe84f7 (use device_list_mutex in
> btrfs_open_devices) implements that but then the access to the ->opened
> member is not protected consistently. There are patches that convert the
> use to device_list_mutex but haven't been merged due to refinements or
> pending review.
> 
> At this point I think we should revert the one commit 542c5908abfe84f7
> as it introduces the locking problems and revisit the whole fs_devices
> locking scheme again in the dex dev cycle. That will be post rc1 as
> there might be more to revert.



  I tried to narrow this, it appears some of the things that
  circular locking dependency check report doesn't make sense.
  Here below is what I find.. as of now.

  The test case btrfs/004 can be simplified to.. which also
  reproduces the problem.

---------------------8<-------------
$ cat 165
#! /bin/bash
# FS QA Test No. btrfs/165
#

seq=`basename $0`
seqres=$RESULT_DIR/$seq
echo "QA output created by $seq"

here=`pwd`
tmp=/tmp/$$
status=1
noise_pid=0

_cleanup()
{
	wait
	rm -f $tmp.*
}
trap "_cleanup; exit \$status" 0 1 2 3 15

# get standard environment, filters and checks
. ./common/rc
. ./common/filter

# real QA test starts here
_supported_fs btrfs
_supported_os Linux
_require_scratch

rm -f $seqres.full

run_check _scratch_mkfs_sized $((2000 * 1024 * 1024))
run_check _scratch_mount
run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 1 -n 2000 $FSSTRESS_AVOID
run_check _scratch_unmount

echo "done"
status=0
exit
---------------------8<-------------

  The circular locking dependency warning occurs at FSSTRESS_PROG.
  And in particular at doproc() in xfstests/ltp/fsstress.c, randomly
  at any of the command at
  opdesc_t        ops[] = { ..}
  which involves calling mmap file operation and if there is something
  to commit.

  The commit transaction does need device_list_mutex which is also being
  used for the btrfs_open_devices() in the commit 542c5908abfe84f7.

  But btrfs_open_devices() is only called at mount, and mmap() can
  establish only be established after the mount has completed. With
  this give its unclear to me why the circular locking dependency check
  is warning about this.

  I feel until we have clarity about this and also solve other problem
  related to the streamlining of uuid_mutex, I suggest we revert
  542c5908abfe84f7. Sorry for the inconvenience.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
