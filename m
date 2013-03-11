Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58770 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab3CKBkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 21:40:32 -0400
Message-ID: <513D360F.4060309@sandeen.net>
Date: Sun, 10 Mar 2013 20:40:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Koen De Wit <koen.de.wit@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfstests: 301: sparse copy between different filesystems/mountpoints
 on btrfs
References: <50F9C331.9000501@oracle.com> <513BD2CF.5020204@sandeen.net> <20130310230325.GM23616@dastard>
In-Reply-To: <20130310230325.GM23616@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/10/13 6:03 PM, Dave Chinner wrote:
> On Sat, Mar 09, 2013 at 06:24:47PM -0600, Eric Sandeen wrote:
>> On 1/18/13 3:48 PM, Koen De Wit wrote:
>>> +}
>>> +
>>> +_scratch_mount
>>> +_create_reflinks_to $TESTDIR2
>>> +_scratch_unmount
>>> +
>>> +mount $TEST_DEV $SCRATCH_MNT
>>> +_create_reflinks_to $TESTDIR3
>>> +umount $SCRATCH_MNT
>>
>> TBH this confuses me, not that it's necessarily wrong (?)
>> You mount TEST_DEV on $SCRATCH_MNT which makes my brain hurt a little.
>> Then _create_reflinks_to $TESTDIR3 and at that point, um, what's going on,
>> what's linking what to where?
> 
> Mounting the TEST_DEV on SCRATCH_MNT is almost always a bad thing to
> do. The test harness expects TEST_DEV to be mounted on TEST_DIR, not
> anywhere else.
> 
> If you need multiple scratch filesystems to test cross-device
> linkage errors, use loopback devices or make use of the btrfs
> scratch device pool...

Actually, looking at it again - does this wind up with TEST_DEV mounted
on both TEST_DIR and SCRATCH_MNT?  Maybe what the test wants is more
mountpoints, not more devices?

-Eric

> Cheers,
> 
> Dave.
> 

