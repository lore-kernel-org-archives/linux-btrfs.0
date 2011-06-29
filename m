From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 29 Jun 2011 16:53:07 +1000
Message-ID: <20110629065306.GC1026@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	viro@ZenIV.linux.org.uk
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309275199-10801-5-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> This is a test to make sure seek_data/seek_hole is acting like it doe=
s on
> Solaris.  It will check to see if the fs supports finding a hole or n=
ot and will
> adjust as necessary.

So I just looked at this with an eye to validating an XFS
implementation, and I came up with this list of stuff that the test
does not cover that I'd need to test in some way:

	- files with clean unwritten extents. Are they a hole or
	  data? What's SEEK_DATA supposed to return on layout like
	  hole-unwritten-data? i.e. needs to add fallocate to the
	  picture...

	- files with dirty unwritten extents (i.e. dirty in memory,
	  not on disk). They are most definitely data, and most
	  filesystems will need a separate lookup path to detect
	  dirty unwritten ranges because the state is kept
	  separately (page cache vs extent cache).  Plenty of scope
	  for filesystem specific bugs here so needs a roubust test.

	- cold cache behaviour - all dirty data ranges the test
	  creates are hot in cache and not even forced to disk, so
	  it is not testing the no-page-cache-over-the-data-range
	  case. i.e. it tests delalloc state tracking but not
	  data-extent-already exists lookups during a seek.

	- assumes that allocation size is the block size and that
	  holes follows block size alignment. We already know that
	  ext4 does not follow that rule when doing small sparse
	  writes close together in a file, and XFS is also known to
	  fill holes when doing sparse writes past EOF.

	- only tests single block data extents =D1=95o doesn't cover
	  corner cases like skipping over multiple fragmented data
	  extents to the next hole.

Some more comments in line....

> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +testfile=3D$TEST_DIR/seek_test.$$
> +logfile=3D$TEST_DIR/seek_test.$$.log

The log file is usually named $seq.full, and doesn't get placed in
the filesystem being tested. It gets saved in the xfstests directory
along side $seq.out.bad for analysis whenteh test fails...

> +[ -x $here/src/seek-tester ] || _notrun "seek-tester not built"
> +
> +_cleanup()
> +{
> +	rm -f $testfile
> +	rm -f $logfile
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +echo "Silence is golden"
> +$here/src/seek-tester -q $testfile 2>&1 | tee -a $logfile

Personally I'd prefer the test to be a bit noisy about what it is
running, especially when there are so many subtests the single
invocation is running. It makes no difference to the run time ofthe
test, or the output when something fails, but it at least allows you
to run the test manually and see what it is doing easily...

> +
> +if grep -q "SEEK_HOLE is not supported" $logfile; then
> +	_notrun "SEEK_HOLE/SEEK_DATA not supported by this kernel"
> +fi
> +
> +rm -f $logfile
> +rm -f $testfile
> +
> +status=3D0 ; exit
> diff --git a/255.out b/255.out
> new file mode 100644
> index 0000000..7eefb82
> --- /dev/null
> +++ b/255.out
> @@ -0,0 +1,2 @@
> +QA output created by 255
> +Silence is golden
> diff --git a/group b/group
> index 1f86075..c045e70 100644
> --- a/group
> +++ b/group
> @@ -368,3 +368,4 @@ deprecated
>  252 auto quick prealloc
>  253 auto quick
>  254 auto quick
> +255 auto quick

I'd suggest that rw and prealloc (once unwritten extent
testing is added) groups should also be defined for this test.

Otherwise, the test code looks ok if a bit over-engineered....

> +struct testrec {
> +	int	test_num;
> +	int	(*test_func)(int fd, int testnum);
> +	char	*test_desc;
> +};
> +
> +struct testrec seek_tests[] =3D {
> +	{  1, test01, "Test basic support" },
> +	{  2, test02, "Test an empty file" },
> +	{  3, test03, "Test a full file" },
> +	{  4, test04, "Test file hole at beg, data at end" },
> +	{  5, test05, "Test file data at beg, hole at end" },
> +	{  6, test06, "Test file hole data hole data" },

So, to take from the hole punch test matrix, it covers a bunch more
file state transitions and cases that are just as relevant to
SEEK_HOLE/SEEK_DATA. Those cases are:

#       1. into a hole
#       2. into allocated space
#       3. into unwritten space
#       4. hole -> data
#       5. hole -> unwritten
#       6. data -> hole
#       7. data -> unwritten
#       8. unwritten -> hole
#       9. unwritten -> data
#       10. hole -> data -> hole
#       11. data -> hole -> data
#       12. unwritten -> data -> unwritten
#       13. data -> unwritten -> data
#       14. data -> hole @ EOF
#       15. data -> hole @ 0
#       16. data -> cache cold ->hole
#       17. data -> hole in single block file

I thikn we also need to cover most of these same cases, right?  And
SEEK_HOLE/SEEK data also need to explicitly separate the unwritten
tests into "clean unwritten" and "dirty unwritten" and cover the
transitions between regions of those states as well, right?

Cheers,

Dave.

--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
