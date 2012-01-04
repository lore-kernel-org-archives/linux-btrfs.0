From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfstests: new check 278 to ensure btrfs backref integrity
Date: Wed, 04 Jan 2012 11:01:50 -0600
Message-ID: <4F0485FE.8000405@sandeen.net>
References: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net> <20120104163946.GA8153@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120104163946.GA8153@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/12 10:39 AM, Christoph Hellwig wrote:
> On Thu, Dec 22, 2011 at 12:08:58PM +0100, Jan Schmidt wrote:
>> This is a btrfs specific scratch test checking the backref walker. It
>> creates a file system with compressed and uncompressed data extents, picks
>> files randomly and uses filefrag to get their extents. It then asks the
>> btrfs utility (inspect-internal) to do the backref resolving from fs-logical
>> address (the one filefrag calls "physical") back to the inode number and
>> file-logical offset, verifying the result.
> 
> I was about to apply this, but for some reason it fails for me when
> running xfstest on xfs:
> 
> 276	 [failed, exit status 1] - output mismatch (see 276.out.bad)
> --- 276.out	2012-01-04 16:14:36.000000000 +0000
> +++ 276.out.bad	2012-01-04 16:32:26.000000000 +0000
> @@ -1,4 +1,5 @@
> QA output created by 276
> -*** test backref walking
> -*** done
> +common.rc: Error: $TEST_DEV (/dev/vdb1) is not a MOUNTED btrfs
> filesystem
> +Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> +/dev/vdb1      xfs    39042944     32928  39010016   1% /mnt/test
>  *** unmount
> 
> which is a bit confusing
> 

276 got merged on Dec 28 before my requests for fixup, I guess?  And it
explicitly sets FSTYP=btrfs which is why it fails.

the 278 patch v2 in this thread works ok for me.

so munging the 278 patch here into the existing 276 should be the
right approach.

-Eric
