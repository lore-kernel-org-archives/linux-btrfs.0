Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3EXEVc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 00:21:32 -0400
Message-ID: <519EEAC4.606@redhat.com>
Date: Thu, 23 May 2013 23:21:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Koen De Wit <koen.de.wit@oracle.com>
Subject: Re: [PATCH] xfstests: btrfs/308: simple sparse copy testcase for
 btrfs
References: <519E4590.4080309@redhat.com> <20130524030903.GL2460@eguan-t400.nay.redhat.com>
In-Reply-To: <20130524030903.GL2460@eguan-t400.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/23/13 10:09 PM, Eryu Guan wrote:
> On Thu, May 23, 2013 at 11:36:32AM -0500, Eric Sandeen wrote:
>> From: Koen De Wit <koen.de.wit@oracle.com>
>>
>> # Tests file clone functionality of btrfs ("reflinks"):
>> #   - Reflink a file
>> #   - Reflink the reflinked file
>> #   - Modify the original file
>> #   - Modify the reflinked file
>>
>> [sandeen: add helpers, make several mostly-cosmetic
>>  changes to the original testcase]
>>
>> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Originally submitted as test 297
>>
>> diff --git a/common/rc b/common/rc
>> index fe6bbfc..4560715 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2098,6 +2098,27 @@ _require_dumpe2fs()
>>  	fi
>>  }
>>  
>> +_require_cp_reflink()
>> +{
>> +	cp --help | grep -q reflink || \
>> +		_notrun "This test requires a cp with --reflink support."
>> +}
>> +
>> +# Given 2 files, verify that they have the same mapping but different
>> +# inodes - i.e. an undisturbed reflink
>> +# Silent if so, make noise if not
>> +_verify_reflink()
>> +{
>> +	# not a hard link or symlink?
>> +	cmp -s	<(stat -c '%i' $1) <(stat -c '%i' $2) \
>> +		&& echo "$1 and $2 are not reflinks: same inode number"
>> +
>> +	# same mapping?
>> +	diff -u	<($XFS_IO_PROG -F -c "fiemap" $1 | grep -v $1) \
>> +		<($XFS_IO_PROG -F -c "fiemap" $2 | grep -v $2) \
>> +		|| echo "$1 and $2 are not reflinks: different extents"
> 
> I'm not sure if "-F" is still needed after commit
> 96fce07 xfstests: automatically add -F to xfs_io on non-xfs

Right, it's not, oops.  :( Old habits (and old patch, TBH)

I can fix & resend all of them I guess.

Thanks,
-Eric

