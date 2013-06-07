Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3FGOuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Jun 2013 10:50:40 -0400
Message-ID: <51B1F32A.9080404@redhat.com>
Date: Fri, 07 Jun 2013 09:50:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Jan Schmidt <list.xfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>,
        sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests btrfs/314: test send / receive
References: <1370532033-20561-1-git-send-email-list.xfs@jan-o-sch.net> <51B0CCC6.2010500@redhat.com> <51B18962.3090504@jan-o-sch.net> <20130607102904.GC13113@dastard>
In-Reply-To: <20130607102904.GC13113@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/7/13 5:29 AM, Dave Chinner wrote:
> On Fri, Jun 07, 2013 at 09:18:58AM +0200, Jan Schmidt wrote:
>> (cc Arne for far-progs discussion)
>>
>> On Thu, June 06, 2013 at 19:54 (+0200), Eric Sandeen wrote:
>>> On 6/6/13 10:20 AM, Jan Schmidt wrote:
>>>> Basic send / receive functionality test for btrfs. Requires current
>>>> version of fsstress built (-x support). Relies on fssum tool, which is
>>>> not part of the test suite but can skip the test if it is missing.
>>>>
>>>> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
>>>
>>> w/o commenting on the test itself, I'm a little uneasy about requiring
>>> some external, not-widely-installed tool for this to run.  The fear is
>>> that it won't be run as often as it could/should be.
>>
>> The main purpose is to have it run by developers changing something around btrfs
>> send / receive and probably the backref walker (while there exists a separate
>> test not requiring fssum for backrefs). I think we can get them to install fssum.
> 
> There's no point in having tests that require you to go find
> something else before the tests can be run. That's been tried
> before, and it doesn't work - the test just won't get run by
> the majority of people who run xfstests.
> 
>>> Could the same test be done w/o fssum, or should we maybe put a copy
>>> of fssum into xfstests/src/fssum.c ?
>>
>> I don't know any adequate replacement for fssum in this case. The purpose is to
>> build a checksum for a whole file system tree, including data and partly metadata.
>>
>> I don't feel like copying fssum from far-progs into xfstests, though it probably
>> won't hurt much. However, I cannot promise we won't make changes to it for
>> far-progs, probably creating two incompatible versions of fssum in the wild. Arne?
>>
>>> Or does fssum exist in any standard distro package?
>>
>> It doesn't. Perhaps Josef can hurry and make a Fedora package for it, if that
>> prevents a separate copy to xfstests :-)
> 
> No, it doesn't. Packages would be needed for debian, suse, SLES,
> RHEL, etc for that to be a useful method of distribution. Just dump
> a snapshot of the utility in the xfstests src dir so we don't have
> to care about distribution issues...

Yup I agree with this, if it's not widely available or replaceable by more
common tools, let's just put a snapshot in xfstests.

-Eric

> Cheers,
> 
> Dave.
> 

