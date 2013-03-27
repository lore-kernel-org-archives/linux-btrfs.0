Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:50834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3C0Qmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 12:42:32 -0400
Message-ID: <5153217B.5070909@sgi.com>
Date: Wed, 27 Mar 2013 11:42:35 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: xfs-oss <xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Announce re-factor all current xfstests patches request
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
In-Reply-To: <20130327134606.GJ5861@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/27/2013 08:46 AM, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 08:23:07AM -0500, Rich Johnston wrote:
>> All xfstest developers,
>>
>> Thanks again for all your time in submitting and reviewing patches
>> for xfstests.  The latest patchset posted here:
>>
>> http://oss.sgi.com/archives/xfs/2013-03/msg00467.html
>>
>> requires all current patches to be re-factored.
>
> Given that we are now segregating patches into subdirectories, is it
> correct in the future tests should be named descriptively, instead of
> using 3 digit NNN numbers (which has been a major pain from a central
> assignment perspective)?
Yes
>
> If so, is there a suggested naming convention that is being recommended?
>
> Thanks for getting this change merged in!!
>
> 					- Ted
>

I suggest:

1. They should also be descriptive of the test rather than a number.
2. All lowercase letters separated by _

i.e.
something like
tests/$FSTYP/break_my_filesystem

Thanks
--Rich


