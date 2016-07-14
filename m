Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21755 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751210AbcGNXrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 19:47:17 -0400
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1468538030.git.osandov@fb.com>
CC: <kernel-team@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <7d7ada29-f53a-bcc8-9344-85733f030c4b@fb.com>
Date: Thu, 14 Jul 2016 19:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1468538030.git.osandov@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2016 07:31 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> So it turns out that the free space tree bitmap handling has always been
> broken on big-endian systems. Totally my bad.
>
> Patch 1 fixes this. Technically, it's a disk format change for
> big-endian systems, but it never could have worked before, so I won't go
> through the trouble of any incompat bits. If you've somehow been using
> space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> to want to mount with nospace_cache to clear it and wait for this to go
> in.
>
> Patch 2 fixes a similar error in the sanity tests (it's the same as the
> v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> oversight that patch 1 fixes.
>
> Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> pass on x86_64 and MIPS.

Thanks for fixing this up Omar.  Any big endian friends want to try this 
out in extended testing and make sure we've nailed it down?

-chris
