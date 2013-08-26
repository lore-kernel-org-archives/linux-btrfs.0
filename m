Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3HZO3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 10:29:41 -0400
Message-ID: <521B664B.7030404@redhat.com>
Date: Mon, 26 Aug 2013 09:29:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: chandan <chandan@linux.vnet.ibm.com>
CC: Eric Sandeen <sandeen@sandeen.net>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, sekharan@linux.vnet.ibm.com
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
References: <2909046.09LYLQvZ6q@localhost.localdomain> <521A36C6.40006@sandeen.net> <44437668.FEX1DiRokR@localhost.localdomain>
In-Reply-To: <44437668.FEX1DiRokR@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/26/13 12:38 AM, chandan wrote:
> On Sunday, August 25, 2013 11:54:30 AM Eric Sandeen wrote:
>> Can you explain why this is necessary?
>>
>> What failures do you see, on what filesystems?
> 
> generic/255 currently fails on Btrfs on a ppc64 machine with 64k page size and
> hence 64k block size.
> 
> generic/255 has been written to test the corner cases for 4k block size. I did
> try to make it work with variable sized block sizes, But I got stuck
> working with md5sum (since we would need two sets of md5sums, due to
> _test_generic_punch() being invoked with and without '-k' option per block
> size). 
> 
> Since 4k block size support for Btrfs on ppc64 is already being worked on, I
> think its better to prevent execution of generic/255 for block sizes greater
> than 4k.
> 
> Apologies for not including the above description in the patch.

It happens.  ;)

To be honest I haven't really looked at how _test_generic_punch & generic/255
works lately.

Just as a sanity check, does it also fail on xfs for 64k block sizes on ppc64?

Thanks,
-Eric

