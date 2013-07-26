Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38130 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab3GZQ6X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 12:58:23 -0400
Message-ID: <51F2AAA5.5010101@sandeen.net>
Date: Fri, 26 Jul 2013 11:58:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Ben Myers <bpm@sgi.com>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: exit out if _scratch_mount fails
References: <1373396847-7975-1-git-send-email-jbacik@fusionio.com> <20130726161235.GK3111@sgi.com> <51F2A091.3010407@sandeen.net> <20130726163352.GL1681@sgi.com>
In-Reply-To: <20130726163352.GL1681@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/26/13 11:33 AM, Ben Myers wrote:
> Josef, Eric,
> 
> On Fri, Jul 26, 2013 at 11:15:13AM -0500, Eric Sandeen wrote:
>> On 7/26/13 11:12 AM, Ben Myers wrote:
>>> Hey Josef,
>>>
>>> On Tue, Jul 09, 2013 at 03:07:27PM -0400, Josef Bacik wrote:
>>>> I test some of the different mkfs options for btrfs, one set doesn't work
>>>> properly with small file systems, so the fs won't mount.  This is fine from a
>>>> btrfs point of view, but tests that fail to mount the scratch fs will run
>>>> anyway, so if it's a "fill the fs" sort of test this will wreak havoc.  To fix
>>>> this just error out of _scratch_mount fails.  Thanks,
>>>>
>>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>>
>>> I noticed that this change causes dmapi tests to try to be run on systems that
>>> don't have dmapi supported, and they fail.  Have you seen this?
>>>
>>> Thanks,
>>> 	Ben
>>
>> I haven't tested either way, but does:
>>
>>      _mount -t $FSTYP `_scratch_mount_options $*` || _fail "Scratch mount failed"
>>
>> work any better?
> 
> This still fails like so:
> 
> xfs/142  [failed, exit status 1] - output mismatch (see /root/xfstests/results/xfs/142.out.bad)
> --- tests/xfs/142.out       2013-05-17 14:23:16.000000000 -0500
> +++ /root/xfstests/results/xfs/142.out.bad  2013-07-26 11:31:00.128200302 -0500
> @@ -1,232 +1,8 @@
> QA output created by 142
> -Attribute tests beginning...
> -Report: success with set #0.
> -Report: success with set #1.
> -Report: success with set #2.
> -Report: success with set #3.
> -Report: success with set #4.
> ...
> (Run 'diff -u tests/xfs/142.out /root/xfstests/results/xfs/142.out.bad' to see the entire diff)

Hm, well, _dmapi_scratch_mount tries a mount, and then does a _notrun if that fails.

Josef's patch calls a _fail (or an exit) if mount fails, and it never gets to "notrun"
in _dmapi_scratch_mount.

So for this test it's an expected mount failure, which changes things a bit.

Still, not quite sure why the test continues after either exit 1 or _fail.

But my bash is rusty...

-Eric

> Thanks,
> 	Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

