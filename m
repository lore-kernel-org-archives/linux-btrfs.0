Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-maira.wadns.net ([196.220.39.139]:64114 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbaEDH1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:27:25 -0400
Message-ID: <5365EBCE.1060605@swiftspirit.co.za>
Date: Sun, 04 May 2014 09:27:10 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        Hugo Mills <hugo@carfax.org.uk>, Russell Coker <russell@coker.com.au>
Subject: Re: copies= option
References: <201405041216.54348.russell@coker.com.au> <pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net>
In-Reply-To: <pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/04 05:27 AM, Duncan wrote:
> Russell Coker posted on Sun, 04 May 2014 12:16:54 +1000 as excerpted:
>
>> Are there any plans for a feature like the ZFS copies= option?
>>
>> I'd like to be able to set copies= separately for data and metadata.  In
>> most cases RAID-1 provides adequate data protection but I'd like to have
>> RAID-1 and copies=2 for metadata so that if one disk dies and another
>> has some bad sectors during recovery I'm unlikely to lose metadata.
> Hugo's the guy with the better info on this one, but until he answers...
>
> The zfs license issues mean it's not an option for me and I'm thus not
> familiar with its options in any detail, but if I understand the question
> correctly, yes.
>
> And of course since btrfs treats data and metadata separately, it's
> extremely unlikely that any sort of copies= option wouldn't be separately
> configurable for each.
>
> There was a discussion of a very nice multi-way-configuration schema that
> I deliberately stayed out of as both a bit above my head and far enough
> in the future that I didn't want to get my hopes up too high about it
> yet.  I already want N-way-mirroring so bad I can taste it, and this was
> that and way more... if/when it ever actually gets coded and committed to
> the mainline kernel btrfs.  As I said, Hugo should have more on it, as he
> was active in that discussion as it seemed to line up perfectly with his
> area of interest.
>
The simple answer is yes, this is planned. As Duncan implied, however, 
it is not on the immediate roadmap. Internally we appear to be referring 
to this feature as "N-way redundancy" or "N-way mirroring".

My understanding is that the biggest hurdle before the primary devs will 
look into N-way redundancy is to finish the Raid5/6 implementation to 
include self-healing/scrubbing support - a critical issue before it can 
be adopted further.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

