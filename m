Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37391 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaBYVCo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 16:02:44 -0500
Received: by mail-bk0-f53.google.com with SMTP id my13so427392bkb.26
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 13:02:43 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140225195420.GX13647@dastard>
References: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
	<1393353848-26790-1-git-send-email-fdmanana@gmail.com>
	<20140225195420.GX13647@dastard>
Date: Tue, 25 Feb 2014 21:02:43 +0000
Message-ID: <CAL3q7H5U2uQyN=z4kjD-fiMk+854URUuf_=0NqUYj4KG4eNsNA@mail.gmail.com>
Subject: Re: [PATCH v2] xfstests: add test for btrfs-progs restore feature
From: Filipe David Manana <fdmanana@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 25, 2014 at 7:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Feb 25, 2014 at 06:44:08PM +0000, Filipe David Borba Manana wrote:
>> This is a regression test to verify that the restore feature of btrfs-progs
>> is able to correctly recover files that have compressed extents, specially when
>> the respective file extent items have a non-zero data offset field.
>>
>> This issue is fixed by the following btrfs-progs patch:
>>
>>     Btrfs-progs: fix restore of files with compressed extents
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ....
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +tmp=/tmp/$$
>> +status=1     # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>
> here=`pwd`

Didn't we agree before, for a previous path, to export "here" from the
main control skip and then cleanup tests to not redefine it?
I am confused now :)

>
>> +
>> +_cleanup()
>> +{
>> +    rm -fr $tmp
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_need_to_be_root
>> +
>> +rm -f $seqres.full
>> +
>> +test_btrfs_restore()
>> +{
>> +     if [ -z $1 ]
>> +     then
>> +             OPTIONS=""
>> +     else
>> +             OPTIONS="-o compress-force=$1"
>> +     fi
>> +     _scratch_mkfs >/dev/null 2>&1
>> +     _scratch_mount $OPTIONS
>> +
>> +     $XFS_IO_PROG -f -c "pwrite -S 0xff -b 100000 0 100000" \
>> +             $SCRATCH_MNT/foo | _filter_xfs_io
>> +
>> +     # Ensure a single file extent item is persisted.
>> +     _run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>
> What's the difference here between "sync" and the command run above?
> Unless there's some specific reason for using the above command (and
> that needs to be commented), I think that sync(1) should be used
> instead in all tests.

I want to force a btrfs transaction commit. Plain old 'sync' would do
it as well for sure, but that applies against all mounted FSs, while
btrfs filesystem sync is applied against a single fs.
Plus, since this is a btrfs specific test, is it non sense to exercise
commands from btrfs-progs?

>
> Indeed, why a separate command - just adding a "-c fsync" to the
> xfs_io command, or even -s to make it open the file O_SYNC should do
> what you need without needing a specific sync command....
>
>
>> +
>> +     $XFS_IO_PROG -c "pwrite -S 0xaa -b 100000 100000 100000" \
>> +             $SCRATCH_MNT/foo | _filter_xfs_io
>> +
>> +     # Now ensure a second one is created (and not merged with previous one).
>> +     _run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>> +
>> +     # Make the extent item be split into several ones, each with a data
>> +     # offset field != 0
>> +     $XFS_IO_PROG -c "pwrite -S 0x1e -b 2 10000 2" $SCRATCH_MNT/foo \
>> +             | _filter_xfs_io
>> +     $XFS_IO_PROG -c "pwrite -S 0xd0 -b 11 33000 11" $SCRATCH_MNT/foo \
>> +             | _filter_xfs_io
>> +     $XFS_IO_PROG -c "pwrite -S 0xbc -b 100 99000 100" $SCRATCH_MNT/foo \
>> +             | _filter_xfs_io
>> +
>> +     md5sum $SCRATCH_MNT/foo | _filter_scratch
>
> So you are doing this with first having "persisted" the new extents.
> Seems kind of strange that you need to persist some and not
> others...

I need to make sure there's fragmentation (i.e. several file extent
items in the fs btree with data offset fields > 0).

>
>> +     _scratch_unmount
>> +     _check_scratch_fs
>
> _check_scratch_fs should be unmounting the SCRATCH_DEV itself
> internally. If it's not doing that for btrfs, then the btrfs check
> code needs fixing. ;)

No it doesn't unmount.

>
>> +
>> +     _run_btrfs_util_prog restore $SCRATCH_DEV $tmp
>> +     md5sum $tmp/foo | cut -d ' ' -f 1
>
> What, exactly, are you restoring to /tmp/$$? Does this assume that
> /tmp is a btrfs filesystem? If so, that is an invalid assumption -
> /tmp can be any type of filesystem at all.

The restore command allows you to grab files from a (potentially
damaged) btrfs filesystem and save them to a destination path, no
matter what its filesystem is (btrfs, extN, xfs, etc)

>
> It's also wrong to use $tmp like this....
>
>> +}
>> +
>> +mkdir $tmp
>> +echo "Testing restore of file compressed with lzo"
>> +test_btrfs_restore "lzo"
>> +echo "Testing restore of file compressed with zlib"
>> +test_btrfs_restore "zlib"
>> +echo "Testing restore of file without any compression"
>> +test_btrfs_restore
>
> Yup, using $tmp like this is definitely wrong. $tmp is really for test
> harness files and test logs, not for *test data*. TEST_DIR is what you
> should be using here, not $tmp.

Alright... Many other existing tests do things like this.

Thanks Dave

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
