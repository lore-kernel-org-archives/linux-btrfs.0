From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 29 Jun 2011 09:19:41 -0400
Message-ID: <4E0B266D.30000@redhat.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110629065306.GC1026@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	viro@ZenIV.linux.org.uk
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110629065306.GC1026@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2011 02:53 AM, Dave Chinner wrote:
> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
>> This is a test to make sure seek_data/seek_hole is acting like it do=
es on
>> Solaris.  It will check to see if the fs supports finding a hole or =
not and will
>> adjust as necessary.
>
> So I just looked at this with an eye to validating an XFS
> implementation, and I came up with this list of stuff that the test
> does not cover that I'd need to test in some way:
>
> 	- files with clean unwritten extents. Are they a hole or
> 	  data? What's SEEK_DATA supposed to return on layout like
> 	  hole-unwritten-data? i.e. needs to add fallocate to the
> 	  picture...
>
> 	- files with dirty unwritten extents (i.e. dirty in memory,
> 	  not on disk). They are most definitely data, and most
> 	  filesystems will need a separate lookup path to detect
> 	  dirty unwritten ranges because the state is kept
> 	  separately (page cache vs extent cache).  Plenty of scope
> 	  for filesystem specific bugs here so needs a roubust test.
>
> 	- cold cache behaviour - all dirty data ranges the test
> 	  creates are hot in cache and not even forced to disk, so
> 	  it is not testing the no-page-cache-over-the-data-range
> 	  case. i.e. it tests delalloc state tracking but not
> 	  data-extent-already exists lookups during a seek.
>
> 	- assumes that allocation size is the block size and that
> 	  holes follows block size alignment. We already know that
> 	  ext4 does not follow that rule when doing small sparse
> 	  writes close together in a file, and XFS is also known to
> 	  fill holes when doing sparse writes past EOF.
>
> 	- only tests single block data extents =D1=95o doesn't cover
> 	  corner cases like skipping over multiple fragmented data
> 	  extents to the next hole.
>

Yeah I intentionally left out preallocated stuff because these are goin=
g=20
to be implementation specific, so I was going to leave that for a later=
=20
exercise when people actually start doing proper implementations.

> Some more comments in line....
>
>> +_cleanup()
>> +{
>> +    rm -f $tmp.*
>> +}
>> +
>> +trap "_cleanup ; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +
>> +# real QA test starts here
>> +_supported_fs generic
>> +_supported_os Linux
>> +
>> +testfile=3D$TEST_DIR/seek_test.$$
>> +logfile=3D$TEST_DIR/seek_test.$$.log
>
> The log file is usually named $seq.full, and doesn't get placed in
> the filesystem being tested. It gets saved in the xfstests directory
> along side $seq.out.bad for analysis whenteh test fails...
>

I only want it to see if SEEK_HOLE fails so I can say it didn't run.  I=
=20
followed the same example as the fiemap test that Eric wrote.

>> +[ -x $here/src/seek-tester ] || _notrun "seek-tester not built"
>> +
>> +_cleanup()
>> +{
>> +	rm -f $testfile
>> +	rm -f $logfile
>> +}
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +echo "Silence is golden"
>> +$here/src/seek-tester -q $testfile 2>&1 | tee -a $logfile
>
> Personally I'd prefer the test to be a bit noisy about what it is
> running, especially when there are so many subtests the single
> invocation is running. It makes no difference to the run time ofthe
> test, or the output when something fails, but it at least allows you
> to run the test manually and see what it is doing easily...
>

Right, the problem with this test is it will run differently depending=20
on the implementation.  I agree, I really like the noisy output tests,=20
but unfortunately if I run this test on ext4 where it currently treats=20
the entire file as data, and then run it on btrfs where it is smarter=20
and actually recognizes holes, we end up with two different outputs tha=
t=20
are both correct.

>> +
>> +if grep -q "SEEK_HOLE is not supported" $logfile; then
>> +	_notrun "SEEK_HOLE/SEEK_DATA not supported by this kernel"
>> +fi
>> +
>> +rm -f $logfile
>> +rm -f $testfile
>> +
>> +status=3D0 ; exit
>> diff --git a/255.out b/255.out
>> new file mode 100644
>> index 0000000..7eefb82
>> --- /dev/null
>> +++ b/255.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 255
>> +Silence is golden
>> diff --git a/group b/group
>> index 1f86075..c045e70 100644
>> --- a/group
>> +++ b/group
>> @@ -368,3 +368,4 @@ deprecated
>>   252 auto quick prealloc
>>   253 auto quick
>>   254 auto quick
>> +255 auto quick
>
> I'd suggest that rw and prealloc (once unwritten extent
> testing is added) groups should also be defined for this test.
>
> Otherwise, the test code looks ok if a bit over-engineered....
>
>> +struct testrec {
>> +	int	test_num;
>> +	int	(*test_func)(int fd, int testnum);
>> +	char	*test_desc;
>> +};
>> +
>> +struct testrec seek_tests[] =3D {
>> +	{  1, test01, "Test basic support" },
>> +	{  2, test02, "Test an empty file" },
>> +	{  3, test03, "Test a full file" },
>> +	{  4, test04, "Test file hole at beg, data at end" },
>> +	{  5, test05, "Test file data at beg, hole at end" },
>> +	{  6, test06, "Test file hole data hole data" },
>
> So, to take from the hole punch test matrix, it covers a bunch more
> file state transitions and cases that are just as relevant to
> SEEK_HOLE/SEEK_DATA. Those cases are:
>
> #       1. into a hole
> #       2. into allocated space
> #       3. into unwritten space
> #       4. hole ->  data
> #       5. hole ->  unwritten
> #       6. data ->  hole
> #       7. data ->  unwritten
> #       8. unwritten ->  hole
> #       9. unwritten ->  data
> #       10. hole ->  data ->  hole
> #       11. data ->  hole ->  data
> #       12. unwritten ->  data ->  unwritten
> #       13. data ->  unwritten ->  data
> #       14. data ->  hole @ EOF
> #       15. data ->  hole @ 0
> #       16. data ->  cache cold ->hole
> #       17. data ->  hole in single block file
>
> I thikn we also need to cover most of these same cases, right?  And
> SEEK_HOLE/SEEK data also need to explicitly separate the unwritten
> tests into "clean unwritten" and "dirty unwritten" and cover the
> transitions between regions of those states as well, right?
>

Yeah you are right, but again doing preallocated stuff is tricky, but I=
=20
can expand it now if that's what we want.  Thanks,

Josef
