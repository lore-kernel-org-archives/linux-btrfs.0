Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbbDBOow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 10:44:52 -0400
Message-ID: <551D55DF.20007@suse.com>
Date: Thu, 02 Apr 2015 10:44:47 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org
Subject: Re: [PATCH] xfstests: generic: test for discard properly discarding
 unused extents
References: <55199FCA.9040503@suse.com> <alpine.LFD.2.00.1504021407530.3307@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1504021407530.3307@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/2/15 8:33 AM, Lukáš Czerner wrote:
> On Mon, 30 Mar 2015, Jeff Mahoney wrote:
> 
>> Date: Mon, 30 Mar 2015 15:11:06 -0400 From: Jeff Mahoney 
>> <jeffm@suse.com> To: linux-btrfs <linux-btrfs@vger.kernel.org>, 
>> fstests@vger.kernel.org Subject: [PATCH] xfstests: generic: test 
>> for discard properly discarding unused extents
>> 
>> This tests tests four conditions where discard can potentially 
>> not discard unused extents completely.
>> 
>> We test, with -o discard and with fstrim, scenarios of removing 
>> many relatively small files and removing several large files.
>> 
>> The important part of the two scenarios is that the large files 
>> must be large enough to span a blockgroup alone. It's possible 
>> for an entire block group to be emptied and dropped without an 
>> opportunity to discard individual extents as would happen with 
>> smaller files.
>> 
>> The test confirms the discards have occured by using a sparse 
>> file mounted via loopback to punch holes and then check how many 
>> blocks are still allocated within the file.
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
>> tests/generic/326     | 164 
>> ++++++++++++++++++++++++++++++++++++++++++++++++++ 
>> tests/generic/326.out |   5 ++ tests/generic/group   |   1 + 3 
>> files changed, 170 insertions(+) create mode 100644 
>> tests/generic/326 create mode 100644 tests/generic/326.out
>> 
>> diff --git a/tests/generic/326 b/tests/generic/326 new file mode 
>> 100644 index 0000000..923a27f --- /dev/null +++ 
>> b/tests/generic/326 @@ -0,0 +1,164 @@ +#! /bin/bash +# FSQA Test 
>> No. 326 +# +# This test uses a loopback mount with PUNCH_HOLE 
>> support to test +# whether discard operations are working as 
>> expected. +# +# It tests both -odiscard and fstrim. +# +# 
>> Copyright (C) 2015 SUSE. All Rights Reserved. +# Author: Jeff 
>> Mahoney <jeffm@suse.com> +# +# This program is free software;
>> you can redistribute it and/or +# modify it under the terms of
>> the GNU General Public License as +# published by the Free
>> Software Foundation. +# +# This program is distributed in the
>> hope that it would be useful, +# but WITHOUT ANY WARRANTY;
>> without even the implied warranty of +# MERCHANTABILITY or
>> FITNESS FOR A PARTICULAR PURPOSE.  See the +# GNU General Public
>> License for more details. +# +# You should have received a copy
>> of the GNU General Public License +# along with this program; if
>> not, write the Free Software Foundation, +# Inc.,  51 Franklin
>> St, Fifth Floor, Boston, MA  02110-1301  USA 
>> +#-------------------------------------------------------------------
- ----
>>
>>
>> 
+#
>> + +seq=`basename $0` +seqres=$RESULT_DIR/$seq +echo "QA output 
>> created by $seq" + +tmp=/tmp/$$ +status=1	# failure is the 
>> default! +trap "_cleanup; exit \$status" 0 1 2 3 15 + +loopdev= 
>> +tmpdir= +_cleanup() +{ +	[ -n "$tmpdir" ] && umount $tmpdir +	[ 
>> -n "$loopdev" ] && losetup -d $loopdev +} + +# get standard 
>> environment, filters and checks +. ./common/rc +. ./common/filter
>> + +# real QA test starts here +_need_to_be_root +_supported_fs
>> generic +_supported_os Linux +_require_scratch +_require_fstrim +
>> +rm -f $seqres.full + +_scratch_mkfs &>> $seqres.full
>> +_require_fs_space $SCRATCH_MNT $(( 10 * 1024 * 1024 ))
>> +_scratch_mount + +test_discard() +{ +	discard=$1 +	files=$2 + +
>> tmpfile=$SCRATCH_MNT/testfs.img.$$ + 
>> tmpdir=$SCRATCH_MNT/testdir.$$ +	mkdir -p $tmpdir || _fail "!!! 
>> failed to create temp mount dir" + +	# Create a sparse file to 
>> host the file system +	dd if=/dev/zero of=$tmpfile bs=1M count=1 
>> seek=10240 &> $seqres.full \ +		|| _fail "!!! failed to create
>> fs image file"
> 
> You can just use truncate here.

Yep.

>> + +	opts="" +	if [ "$discard" = "discard" ]; then +		opts="-o 
>> discard" +	fi +	losetup -f $tmpfile +	loopdev=$(losetup -j 
>> $tmpfile|awk -F: '{print $1}')
> 
> you can just do
> 
> loopdev=$(losetup --show -f $tmpfile)

Thanks, that's a good tip!

>> +	_mkfs_dev $loopdev &> $seqres.full +	$MOUNT_PROG $opts
>> $loopdev $tmpdir \ +		|| _fail "!!! failed to loopback mount" + +
>> if [ "$files" = "large" ]; then +		# Create files larger than 1GB
>> so each one occupies +		# more than one block group
> 
> Why it needs to be that big ? Can't you make btrfs groups smaller 
> ?

Not in the way you're expecting. Block group sizes are hardcoded to a
certain size within the kernel based on what the chunk will be used
for (Data=1GB, Metadata=1GB, 256MB for fs size < 50 GB, System=32MB).
The only modifier is if a chunk will comprise more than 10% of the
total capacity of the file system, so chunks will be scaled smaller on
file systems smaller than 10GB.

>> +	if [ "$discard" = "trim" ]; then +		$FSTRIM_PROG $tmpdir +	fi +
>> +	$UMOUNT_PROG $tmpdir +	rmdir $tmpdir +	tmpdir= + +	# Sync the 
>> backing file system to ensure the hole punches have +	# happened 
>> and we can trust the result. +	if [ "$FSTYP" = "btrfs" ]; then + 
>> _run_btrfs_util_prog filesystem sync $SCRATCH_MNT +	fi +	sync + 
>> sync
> 
> Four syncs ? Do we really need that many ?

No. The double sync was addressed in Brian and Dave's review. The
first is for the hosted file system and the second is for the backing
file system. We should be able to skip the first one since umount will
do it for us. The second one is definitely needed. Otherwise, the
writes to the backing file system are allowed to wait and the discards
won't happen until after those writes are completed. In that case, the
'du' test fails because the backing file hasn't had holes punched into
it yet and causes the test case to fail incorrectly. I ran into this
during development of the test. I'll confirm what's needed here and
trim it down.

>> + +	NSIZE="$(du -k $tmpfile|awk '{print $1}')" +	du -k $tmpfile
>>>> $seqres.full + +	# Going from ~ 10GB to 50MB is a good
>>>> enough
>> test to account for
> 
> It's not good enough, because empty ext4 file system of this size 
> will take up about 133MB. The we can allocate additional metadata 
> blocks which might not get discarded.
> 
> So maybe get your baseline from at least double the initial empty 
> fs size, or at least 200M ?

Ok, so it sounds like this number should be added to the per-fs values
that Brian suggested in his review. I had already expanded it to 50MB
from 10MB to accommodate XFS. Btrfs should contract down to ~ 1.5MB
after discarding with an emptied file system. IIRC, XFS doesn't
contract down to double the size of an empty fs.Numbers in the few
hundreds of MB range start getting into one of the failure cases I was
chasing for btrfs.

Thanks for the review,

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVHVXfAAoJEB57S2MheeWykEcP/i3HJaV88+tYW4C621MKp0ih
cURrM+0Vmer6clLuZ6aGQIJMXBN8vo/7NWAgtgQjf32LTzh77ebCjYokB3WvJaKm
w77GzD7Rs37aXJSxzpFj3c3JTDIO/iUZ5VbAChLku2Rwae1ZUHGSemkILBSIRp6i
V+6gTQ986E6lgw8XnTTVVdWLvSmfhnhga2NH+dcbIxBVXAjxhVnRqoeRtqqdJafF
3VgeiukBssUoaIiiLek4SFsEveq8DUFfv6INnbFOlO8UJI64HdblZoOsNqqnRbfc
b63BKltwRY8pq/JWIDxsuG6s1Tea5xlHb2lok3z48+KxM5/3o7Qjx5VrpkDKOcLk
foEH94FZTMqKTmWSOilIl8/KNg/xm9YdpZqj+RnlYYdlKJyiidkho6Dn+ij39Kye
F/rmwZpt3oqh7zT25FC2XmVeWMxccZpSNzUJV2EHSTWsNz/feMftxthJEgoWBE5e
gGAvI+rp/00ZVPP9RP1GBlYZAmQBQHa+YVOHYmbbfQF9Ge8RYSGqPFH/cUBNwCDv
axFrju37sQC3tOK/YHL0vKqaMoQLzHUIjAn+PEllkd9Z9Ll1KCBVsqUidKSK/RP4
+DAB56Jc/M/vE4DAvRSd171ih9ejDpVtVe0IZqk+dIHiDVU3YJa2jQrcM4phmRmj
AFxYLvbYjOMV4MZZ7+IT
=lUDo
-----END PGP SIGNATURE-----
