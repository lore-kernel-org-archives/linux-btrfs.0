Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25064 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbHSCun (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 22:50:43 -0400
Date: Wed, 19 Aug 2015 10:50:22 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, fdmanana@gmail.com,
        david@fromorbit.com
Subject: Re: [PATCH v2] fstests: generic/018: expand "write backwards sync
 but contiguous" to test regression in btrfs
Message-ID: <20150819025021.GA4583@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1439455474-20128-1-git-send-email-bo.li.liu@oracle.com>
 <1439455670-21822-1-git-send-email-bo.li.liu@oracle.com>
 <55CE06F4.4000208@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CE06F4.4000208@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Sorry for the late reply.

On Fri, Aug 14, 2015 at 10:19:16AM -0500, Eric Sandeen wrote:
> On 8/13/15 3:47 AM, Liu Bo wrote:
> > Btrfs has a problem when defraging a file which has a large fragment'ed range,
> > it'd leave the tail extent as a seperate extent instead of merging it with
> > previous extents.
> > 
> > This makes generic/018 recognize the above regression.
> 
> Sorry for the late review, but here it is ;)
> 
> In 2 years (heck, even now) we'll have no idea why this change was made.
> 
> What regression is that?  Can you describe it?  Is there already an upstream
> fix/commit you can refer to?

The above commit log is talking about the regression, do you mean by writing a
better description of the regression than it or directly putting a
comment in generic/018 case?

Yes, There is a fix[1] for this, but still pending to be merged :)

[1]:
"Btrfs: fix defrag to merge tail file extent"
https://patchwork.kernel.org/patch/6966631/

> 
> I see 3 changes here:
> 
> 1) You change xfs_io's "for" loop from "seq 9 -1 0" to "seq 64 -1 0" - presumably
> this matters to btrfs.  Why does this matter?

This is part of reproducing the btrfs regression since it needs a
fragmented range that is larger than 256K, so I choose (65 * 4)k here,
will update this in the commit log if it confuses.

> 
> > Meanwhile, I find that in the case of 'write backwards sync but contiguous",
> > ext4 doesn't produce fragments like btrfs and xfs, so I modify 018.out a little
> > bit to let ext4 pass.
> 
> 2) You stop expecting 10 extents initially in the backwards-write test for the
> above reason, I guess.  I'm a little unsure about this.  For me, this passes as-is.
> If it isn't working for you, we should understand why, instead of making the test
> ignore it.
> 
> (And bundling this ext4 change into a btrfs-specific commit isn't great, anyway)

Hmm, OK, the problem of ext4 is that with 'seq 64 -1 0' backwards-write
it doesn't produce 65 extents, instead it comes to 12 extents, at least
on my box and I use the default mount options.

I took a look at ext4 code but didn't figure out any problems, so I'd
leave it as it is so that ext4 experts can pick it up.

> 
> > Moreover, I follow Filipe's suggestion to filter xfs_io's output in order to
> > check these writes actually succeed.
> 
> 3) You stop redirecting xfs_io to /dev/null, and save it to the golden output
> file instead.
> 
> Honestly, I find hundreds of extra xfs_io output lines to be rather unhelpful,
> because the old output file used to be quite easy to read, to see what's going on.
> 
> Today it only redirects stdout:
> 
> $XFS_IO_PROG -f -c "pwrite -b $((4 * bsize)) 0 $((4 * bsize))" $fragfile \
> 					> /dev/null
> 
> so if a write fails, I *think* stderr will get output, and the test *should*
> fail as a result.[1]  You could add a || _fail "xfs_io failed" for good measure...

All right, I'll take it.

Thanks for the review.

Thanks,

-liubo

> 
> -Eric
> 
> [1] oh, maybe not, I guess xfs_io is kind of notorious for not returning errors...
> 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: fix typo in title, s/expend/expand/g
> > 
> >  tests/generic/018     |  16 ++--
> >  tests/generic/018.out | 198 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 203 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tests/generic/018 b/tests/generic/018
> > index d97bb88..3693874 100755
> > --- a/tests/generic/018
> > +++ b/tests/generic/018
> > @@ -68,28 +68,24 @@ $XFS_IO_PROG -f -c "truncate 1m" $fragfile
> >  _defrag --before 0 --after 0 $fragfile
> >  
> >  echo "Contiguous file:" | tee -a $seqres.full
> > -$XFS_IO_PROG -f -c "pwrite -b $((4 * bsize)) 0 $((4 * bsize))" $fragfile \
> > -					> /dev/null
> > +$XFS_IO_PROG -f -c "pwrite -b $((4 * bsize)) 0 $((4 * bsize))" $fragfile | _filter_xfs_io
> >  _defrag --before 1 --after 1 $fragfile
> >  
> >  echo "Write backwards sync, but contiguous - should defrag to 1 extent" | tee -a $seqres.full
> > -for i in `seq 9 -1 0`; do
> > -	$XFS_IO_PROG -fs -c "pwrite -b $bsize $((i * bsize)) $bsize" $fragfile \
> > -					> /dev/null
> > +for i in `seq 64 -1 0`; do
> > +	$XFS_IO_PROG -fd -c "pwrite -b $bsize $((i * bsize)) $bsize" $fragfile | _filter_xfs_io
> >  done
> > -_defrag --before 10 --after 1 $fragfile
> > +_defrag --after 1 $fragfile
> >  
> >  echo "Write backwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
> >  for i in `seq 31 -2 0`; do
> > -	$XFS_IO_PROG -fs -c "pwrite -b $bsize $((i * bsize)) $bsize" $fragfile \
> > -					> /dev/null
> > +	$XFS_IO_PROG -fs -c "pwrite -b $bsize $((i * bsize)) $bsize" $fragfile | _filter_xfs_io
> >  done
> >  _defrag --before 16 --after 16 $fragfile
> >  
> >  echo "Write forwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
> >  for i in `seq 0 2 31`; do
> > -	$XFS_IO_PROG -fs -c "pwrite -b $bsize $((i * bsize)) $bsize" $fragfile \
> > -					> /dev/null
> > +	$XFS_IO_PROG -fs -c "pwrite -b $bsize $((i * bsize)) $bsize" $fragfile | _filter_xfs_io
> >  done
> >  _defrag --before 16 --after 16 $fragfile
> >  
> > diff --git a/tests/generic/018.out b/tests/generic/018.out
> > index 5f265d1..0886a9a 100644
> > --- a/tests/generic/018.out
> > +++ b/tests/generic/018.out
> > @@ -6,14 +6,210 @@ Sparse file (no blocks):
> >  Before: 0
> >  After: 0
> >  Contiguous file:
> > +wrote 16384/16384 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >  Before: 1
> >  After: 1
> >  Write backwards sync, but contiguous - should defrag to 1 extent
> > -Before: 10
> > +wrote 4096/4096 bytes at offset 262144
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 258048
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 253952
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 249856
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 245760
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 241664
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 237568
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 233472
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 229376
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 225280
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 221184
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 217088
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 212992
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 208896
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 204800
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 200704
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 196608
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 192512
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 188416
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 184320
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 180224
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 176128
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 172032
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 167936
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 163840
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 159744
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 155648
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 151552
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 147456
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 143360
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 139264
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 135168
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 131072
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 126976
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 122880
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 118784
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 114688
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 110592
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 106496
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 102400
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 98304
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 94208
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 90112
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 86016
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 81920
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 77824
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 73728
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 69632
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 65536
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 61440
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 57344
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 53248
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 49152
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 45056
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 40960
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 36864
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 32768
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 28672
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 24576
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 20480
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 16384
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 12288
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 8192
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 4096
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +Before: in_range(0, -1)
> >  After: 1
> >  Write backwards sync leaving holes - defrag should do nothing
> > +wrote 4096/4096 bytes at offset 126976
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 118784
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 110592
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 102400
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 94208
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 86016
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 77824
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 69632
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 61440
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 53248
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 45056
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 36864
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 28672
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 20480
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 12288
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 4096
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >  Before: 16
> >  After: 16
> >  Write forwards sync leaving holes - defrag should do nothing
> > +wrote 4096/4096 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 8192
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 16384
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 24576
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 32768
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 40960
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 49152
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 57344
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 65536
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 73728
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 81920
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 90112
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 98304
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 106496
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 114688
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +wrote 4096/4096 bytes at offset 122880
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >  Before: 16
> >  After: 16
> > 
> 
