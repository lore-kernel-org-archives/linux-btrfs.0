Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60645 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbbIIJKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 05:10:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t899A3a2007776
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 17:10:03 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <154afcdd14c259551d843a157814fd0ff3589e8f.1441373012.git.zhaolei@cn.fujitsu.com> <87244a2006270f7f8a32680ce8ba7656e277a4bd.1441373012.git.zhaolei@cn.fujitsu.com> <55EF8F58.4070407@cn.fujitsu.com>
In-Reply-To: <55EF8F58.4070407@cn.fujitsu.com>
Subject: RE: [PATCH 3/3] btrfs-progs: tests: Introduce misc-tests/008-leaf-accross-stripes
Date: Wed, 9 Sep 2015 17:09:37 +0800
Message-ID: <045c01d0eadf$41559a00$c400ce00$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu Wenruo

> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo@cn.fujitsu.com]
> Sent: Wednesday, September 09, 2015 9:46 AM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 3/3] btrfs-progs: tests: Introduce
> misc-tests/008-leaf-accross-stripes
> 
> 
> 
> Zhao Lei wrote on 2015/09/04 21:23 +0800:
> > To check is btrfs-convert create bad filesystem with leaf accross
> > stripes.
> >
> > It is happened in progs version <=v4.1.2, and fixed by patch titled:
> > btrfs: convert: Avoid allocating metadata extent crossing stripe
> > boundary which was merged in v4.2.
> >
> > Notice thar this testcase can not report error in old version of
> > btrfs-progs, because "btrfs check" can't check this type of error in
> > those version, but we have another testcase in fsck-tests, to check is
> > "btrfs check" support this check.
> >
> > So, use above 2 testcase together can check out leaf-accross-stripes
> > bug in all version.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >   tests/misc-tests/008-leaf-accross-stripes/test.sh | 24
> +++++++++++++++++++++++
> >   1 file changed, 24 insertions(+)
> >   create mode 100755 tests/misc-tests/008-leaf-accross-stripes/test.sh
> >
> > diff --git a/tests/misc-tests/008-leaf-accross-stripes/test.sh
> > b/tests/misc-tests/008-leaf-accross-stripes/test.sh
> > new file mode 100755
> > index 0000000..4801dce
> > --- /dev/null
> > +++ b/tests/misc-tests/008-leaf-accross-stripes/test.sh
> > @@ -0,0 +1,24 @@
> > +#!/bin/bash
> > +# test btrfs subvolume run normally with more than one subvolume # #
> > +- btrfs subvolume must not loop indefinetelly # - btrfs subvolume
> > +return 0 in normal case
> > +
> > +source $TOP/tests/common
> > +
> > +check_prereq btrfs-convert
> > +check_prereq btrfs
> > +
> > +# In my test, it happened in 514M~560M, 737M~769M, 929M~917M, # and
> > +HAVE_ERROR=((size + 1) / 2) % 2 if size >= 970 #
> > +SIZE_FROM=514
> > +SIZE_END=560
> > +A_PRIME_NUM=17
> > +for ((size = SIZE_FROM; size <= SIZE_END; size += A_PRIME_NUM)); do
> > +	run_check truncate -s "$size"M "$IMAGE"
> > +	run_check mkfs.ext4 -F "$IMAGE"
> > +	run_check $TOP/btrfs-convert "$IMAGE"
> > +	$TOP/btrfs check "$IMAGE" 2>&1 | grep "crossing stripe boundary" &&
> > +		_fail "leaf accross stripes in btrfs-convert"
> > +done
> >
> Maybe I'm wrong, but even with your script, I still can't reproduce the bug.
> 
It is right case.
In old version of progs, convert have above bug, but btrfs check can not report.
In new version of progs, btrfs check can report the bug, but convert fixed the bug.
It is noticed in patch's description.

> After some search in git log, I found that, from 4.1 btrfs-convert won't allow
> mixed block group since the following commit:
> commit c9b73b702be71bbc1a3a815a745e6e4e57eadffc
> Author: David Sterba <dsterba@suse.cz>
> Date:   Mon Mar 23 19:31:31 2015 +0100
> 
>      btrfs-progs: convert: allow to set filesystem features
> 
> So the new test may not be necessary and won't reproduce the bug.
> 
Yes, it is fixed.
But we found a bug, we need fix the bug and write a testcase
for it simultaneously.

Thanks
Zhaolei

> Thanks,
> Qu

