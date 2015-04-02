Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbbDBLts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 07:49:48 -0400
Date: Thu, 2 Apr 2015 07:49:43 -0400
From: Brian Foster <bfoster@redhat.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org
Subject: Re: [PATCH] xfstests: generic: test for discard properly discarding
 unused extents
Message-ID: <20150402114943.GC3808@laptop.bfoster>
References: <55199FCA.9040503@suse.com>
 <20150401184434.GG4756@bfoster.bfoster>
 <551C4073.8010201@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <551C4073.8010201@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 01, 2015 at 03:01:07PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 4/1/15 2:44 PM, Brian Foster wrote:
> > On Mon, Mar 30, 2015 at 03:11:06PM -0400, Jeff Mahoney wrote:
> >> This tests tests four conditions where discard can potentially 
> >> not discard unused extents completely.
> >> 
> >> We test, with -o discard and with fstrim, scenarios of removing 
> >> many relatively small files and removing several large files.
> >> 
> >> The important part of the two scenarios is that the large files 
> >> must be large enough to span a blockgroup alone. It's possible 
> >> for an entire block group to be emptied and dropped without an 
> >> opportunity to discard individual extents as would happen with 
> >> smaller files.
> >> 
> >> The test confirms the discards have occured by using a sparse 
> >> file mounted via loopback to punch holes and then check how many 
> >> blocks are still allocated within the file.
> >> 
> >> Signed-off-by: Jeff Mahoney <jeffm@suse.com> ---
> > 
> > The code looks mostly Ok to me, a few notes below. Those aside, 
> > this is a longish test. It takes me about 8 minutes to run on my 
> > typical low end vm.
> 
> My test hardware is a 16 core / 16 GB RAM machine using a commodity
> SSD. It ran pretty quickly.
> 

Yeah, as Dave mentioned, I test on anything from beefier bare metal
hardware to fairly resource constrained VMs. We certainly have longer
running tests, but sometimes I exclude them when I'm just trying to do
regression tests on ongoing development work, etc.

> I suppose I should start by explaining that I wrote the test to be
> btrfs specific and then realized that the only thing that was
> /actually/ btrfs-specific was the btrfs filesystem sync call. I ran it
> on XFS to ensure it worked as expected, but didn't have any reason to
> try to adapt it to work in any other environment.
> 
> > Is the 1GB block group magic value mutable in any way, or is it a 
> > hardcoded thing (for btrfs I presume)? It would be nice if we could
> > shrink that a bit. If not, perhaps there are some other ways to
> > reduce the runtime...
> 
> It's not hardcoded for btrfs, but it is by far the most common sized
> block group. I'd prefer to test what people are using.
> 

Ok...

> > - Is there any reason a single discard or trim test instance must 
> > be all large or small files? In other words, is there something 
> > that this wouldn't catch if the 10GB were 50% filled with large 
> > files and %50 with small files? That would allow us to trim the 
> > maximum on the range of small file creation and only have two 
> > invocations instead of four.
> 
> Only to draw attention to the obvious failure cases, which are
> probably specific to btrfs. If a file spans an entire block group and
> is removed, it skips the individual discards and depends on the block
> group removal to discard the entire thing (this wasn't happening). If
> there are lots of small files, it hits different paths, and I wanted
> to make it clear which one each mode of the test was targeting.
> Otherwise, whoever hits the failure is going to end up having to do it
> manually, which defeats the purpose of having an automated test case, IM
> O.
> 

So it seems to me this is somewhat a mix of a functional test, a stress
test and a targeted regression test. IIUC, the regression could probably
be reproduced and tested for using a smaller block group and thus
require significantly less time. The functional test requires testing
that the various discard mechanisms work appropriately (e.g., mix of
files), but still shouldn't require writing so much data. A stress test
certainly requires a larger fs and writing a bit more data.

That could probably be managed in a variety of ways. You could throw the
whole thing under btrfs as is, split it up into separate tests that are
grouped such that it's easier to exclude the longer running test, use
fs-specific values as discussed above, use a percentage of SCRATCH_DEV
and let the tester determine the time based on the devices under test,
etc.

The only thing I really care about is the length of time running the
test on slower storage. The idea of scaling the file sizes seems a
reasonable enough workaround to me, assuming we can get that 8 minutes
down to a couple minutes or so.

> > - If the 1GB thing is in fact a btrfs thing, could we make the
> > core test a bit more size agnostic (e.g., perhaps pass the file 
> > count/size values as parameters) and then scale the parameters up 
> > exclusively for btrfs? For example, set defaults of fssize=1G, 
> > largefile=100MB, smallfile=[512b-5MB] or something of that nature 
> > and override them to the 10GB, 1GB, 32k-... values for btrfs? That 
> > way we don't need to write as much data for fs' where it might not 
> > be necessary.
> 
> If someone wants to weigh in on what sane defaults for other file
> systems might be, sure.
> 

The order of magnitude numbers I threw out above seem reasonable to me,
at least for xfs. We can always tweak it later.

> >> tests/generic/326     | 164 
> >> ++++++++++++++++++++++++++++++++++++++++++++++++++ 
> >> tests/generic/326.out |   5 ++ tests/generic/group   |   1 + 3 
> >> files changed, 170 insertions(+) create mode 100644 
> >> tests/generic/326 create mode 100644 tests/generic/326.out
> >> 
> >> diff --git a/tests/generic/326 b/tests/generic/326 new file mode 
> >> 100644 index 0000000..923a27f --- /dev/null +++ 
> >> b/tests/generic/326 @@ -0,0 +1,164 @@ +#! /bin/bash +# FSQA Test 
> >> No. 326 +# +# This test uses a loopback mount with PUNCH_HOLE 
> >> support to test +# whether discard operations are working as 
> >> expected. +# +# It tests both -odiscard and fstrim. +# +# 
> >> Copyright (C) 2015 SUSE. All Rights Reserved. +# Author: Jeff 
> >> Mahoney <jeffm@suse.com> +# +# This program is free software;
> >> you can redistribute it and/or +# modify it under the terms of
> >> the GNU General Public License as +# published by the Free
> >> Software Foundation. +# +# This program is distributed in the
> >> hope that it would be useful, +# but WITHOUT ANY WARRANTY;
> >> without even the implied warranty of +# MERCHANTABILITY or
> >> FITNESS FOR A PARTICULAR PURPOSE.  See the +# GNU General Public
> >> License for more details. +# +# You should have received a copy
> >> of the GNU General Public License +# along with this program; if
> >> not, write the Free Software Foundation, +# Inc.,  51 Franklin
> >> St, Fifth Floor, Boston, MA  02110-1301  USA 
> >> +#-------------------------------------------------------------------
> - ----
> >>
> >>
> >> 
> +#
> >> + +seq=`basename $0` +seqres=$RESULT_DIR/$seq +echo "QA output 
> >> created by $seq" + +tmp=/tmp/$$ +status=1	# failure is the 
> >> default! +trap "_cleanup; exit \$status" 0 1 2 3 15 + +loopdev= 
> >> +tmpdir= +_cleanup() +{ +	[ -n "$tmpdir" ] && umount $tmpdir +	[ 
> >> -n "$loopdev" ] && losetup -d $loopdev +} + +# get standard 
> >> environment, filters and checks +. ./common/rc +. ./common/filter
> >> + +# real QA test starts here +_need_to_be_root +_supported_fs
> >> generic +_supported_os Linux +_require_scratch +_require_fstrim +
> >> +rm -f $seqres.full + +_scratch_mkfs &>> $seqres.full
> >> +_require_fs_space $SCRATCH_MNT $(( 10 * 1024 * 1024 ))
> >> +_scratch_mount + +test_discard() +{ +	discard=$1 +	files=$2 + +
> >> tmpfile=$SCRATCH_MNT/testfs.img.$$ + 
> >> tmpdir=$SCRATCH_MNT/testdir.$$ +	mkdir -p $tmpdir || _fail "!!! 
> >> failed to create temp mount dir" + +	# Create a sparse file to 
> >> host the file system +	dd if=/dev/zero of=$tmpfile bs=1M count=1 
> >> seek=10240 &> $seqres.full \ +		|| _fail "!!! failed to create
> >> fs image file"
> > 
> > xfs_io -c "truncate ..." ?
> 
> Sure, I can do that.
> 
> >> + +	opts="" +	if [ "$discard" = "discard" ]; then +		opts="-o 
> >> discard" +	fi +	losetup -f $tmpfile +	loopdev=$(losetup -j 
> >> $tmpfile|awk -F: '{print $1}') +	_mkfs_dev $loopdev &> 
> >> $seqres.full +	$MOUNT_PROG $opts $loopdev $tmpdir \ +		|| _fail 
> >> "!!! failed to loopback mount" + +	if [ "$files" = "large" ]; 
> >> then +		# Create files larger than 1GB so each one occupies +		# 
> >> more than one block group +		for n in $(seq 1 8); do +			dd 
> >> if=/dev/zero of=$tmpdir/file$n bs=1M count=1200 \ +				&> 
> >> $seqres.full +		done +	else +		# Create up to 40k files sized 
> >> 32k-1GB. +		mkdir -p $tmpdir/testdir +		for ((i = 1; i <= 40000; 
> >> i++)); do +			SIZE=$(( $((1024*1024*1024)) / $(( $RANDOM + 1 )) 
> >> )) +			$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 $SIZE" \ + 
> >> $tmpdir/testdir/"${prefix}_$i" &> /dev/null +			if [ $? -ne 0 ]; 
> >> then +				echo "Failed creating file ${prefix}_$i" \
> > 
> > ${prefix} doesn't evaluate to anything in my run of this test. $seq
> > perhaps?
> 
> I lifted the loop from tests/generic/038 which took an argument. I
> suppose I could make it ${seq}. It's not really necessary at all.
> 

Indeed.

> >> +					>>$seqres.full +				break +			fi +		done +	fi + +	sync + 
> >> OSIZE="$(du -k $tmpfile|awk '{print $1}')" +	du -k $tmpfile >> 
> >> $seqres.full + +	if [ "$files" = "large" ]; then +		rm 
> >> $tmpdir/file? +	else +		rm -rf $tmpdir/testdir +	fi + +	# Ensure 
> >> everything's actually on the hosted file system +	if [ "$FSTYP"
> >> = "btrfs" ]; then +		_run_btrfs_util_prog filesystem sync $tmpdir
> >> + fi +	sync +	sync
> > 
> > Any reason for the double syncs?
> 
> Superstition? IIRC, at one point in what is probably the ancient past,
> btrfs needed two syncs to be safe. I kept running into false failures
> without both a sync and the btrfs filesystem sync, so I just hit the
> "no really, just do it" button.
> 

I agree with Dave here. It seems like we shouldn't really need those at
this point.

Brian

> >> +	if [ "$discard" = "trim" ]; then +		$FSTRIM_PROG $tmpdir +	fi +
> >> +	$UMOUNT_PROG $tmpdir +	rmdir $tmpdir +	tmpdir= + +	# Sync the 
> >> backing file system to ensure the hole punches have +	# happened 
> >> and we can trust the result. +	if [ "$FSTYP" = "btrfs" ]; then + 
> >> _run_btrfs_util_prog filesystem sync $SCRATCH_MNT +	fi +	sync + 
> >> sync + +	NSIZE="$(du -k $tmpfile|awk '{print $1}')" +	du -k 
> >> $tmpfile >> $seqres.full + +	# Going from ~ 10GB to 50MB is a 
> >> good enough test to account for +	# metadata remaining on 
> >> different file systems. +	if [ "$NSIZE" -gt $(( 50 * 1024 )) ]; 
> >> then +		_fail "TRIM failed: before rm ${OSIZE}kB, after rm 
> >> ${NSIZE}kB" +	fi +	rm $tmpfile +	losetup -d $loopdev +	loopdev= 
> >> +} + + +echo "Testing with -odiscard, many small files" 
> >> +test_discard discard many + +echo "Testing with -odiscard, 
> >> several large files" +test_discard discard large + +echo
> >> "Testing with fstrim, many small files" +test_discard trim many +
> >> +echo "Testing with fstrim, several large files" +test_discard
> >> trim large + +status=0 +exit diff --git a/tests/generic/326.out 
> >> b/tests/generic/326.out new file mode 100644 index 
> >> 0000000..37b0f2c --- /dev/null +++ b/tests/generic/326.out @@ 
> >> -0,0 +1,5 @@ +QA output created by 084
> > 
> > 326
> 
> Thanks. I was just running it directly and missed this once I renamed
> it from tests/btrfs.
> 
> Thanks for the review,
> 
> - -Jeff
> 
> > Brian
> > 
> >> +Testing with -odiscard, many small files +Testing with 
> >> -odiscard, several large files +Testing with fstrim, many small 
> >> files +Testing with fstrim, several large files diff --git 
> >> a/tests/generic/group b/tests/generic/group index 
> >> d56d3ce..75e17fa 100644 --- a/tests/generic/group +++ 
> >> b/tests/generic/group @@ -183,3 +183,4 @@ 323 auto aio stress
> >> 324 auto fsr quick 325 auto quick data log +326 auto metadata --
> >>  1.8.5.6
> >> 
> >> 
> >> -- Jeff Mahoney SUSE Labs -- To unsubscribe from this list: send 
> >> the line "unsubscribe fstests" in the body of a message to 
> >> majordomo@vger.kernel.org More majordomo info at 
> >> http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
> 
> iQIcBAEBAgAGBQJVHEBzAAoJEB57S2MheeWyAzUQAKiAUkZfiXToiOi2+e5dIs30
> KaZHMZrsiqNLSiOIvA5Ro6Zq9E+9mWwqLPzb5c+J3i7nVzUGFZ18kU6gun/eIvDa
> fshNJ7CAb1w3oSszXsKP35N6Gr0AWkmw2ZYbzHmuqOhWpH32syFeHIlu7IZKpYaC
> SDirIztzg00vpBlyLEj2HxoN2NOkufgINKXFqP38uqpEJN3z+ZmLTxzQshEMh9nX
> P3rjxBkO+rrk2CY6gtnt28Gwf4EGGg3JVtDTNmCAIcASf9N0g3NcF2Gffnd5wMfH
> bv+Dw6qHGm+dw9JENUUzXlDi8bWdddaxJINbcK0ovwEwPsfInqgWc0nvxXK1AKzE
> RcI9U/LKsWrtib7gh6aojwJrm96++RXQz8znKJtBTXA/faoIHEiNkMlVZG551j9q
> pRyXijnsUehCVNTO+nt2XsGVvjlUgw/bKeILlvbXfKYG+9BQrXJSOLPJEquRXMvn
> SjsciAdayAdgs46RSQLjZhlaFwVocJHEwcuee81dXxbu7ku6wPaIVwSUVMMjLBi8
> DkCSYFIRcl8O8NRkHz7ERTnPHFBEBTTIoP485CoNfmlauVY/dk/hOddsFYttXxZO
> ZvupexKtwTj2Y1qtq0SumHS+MgZIhiKzBSeYrQf0jARBP9hB5ewW/3Vbx1E6yPyA
> QGSUrEia3D/pewdKhnue
> =AFOs
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
