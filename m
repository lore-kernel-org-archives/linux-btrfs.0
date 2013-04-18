Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55949 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966458Ab3DRPHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 11:07:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1USqR6-0006Lf-2F
	for linux-btrfs@vger.kernel.org; Thu, 18 Apr 2013 17:07:44 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 17:07:44 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 17:07:44 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [RFC] Online dedup for Btrfs
Date: Thu, 18 Apr 2013 16:07:37 +0100
Message-ID: <kkp27l$hu5$1@ger.gmane.org>
References: <20130401125034.GG1876@localhost.localdomain> <CAFWF=a=ybrYRkpH347-ohDD5CQAknx06vtKfBQ-V==6hyNW3EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CAFWF=a=ybrYRkpH347-ohDD5CQAknx06vtKfBQ-V==6hyNW3EA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apart from the dates, this sounds highly plausible :-)

If the hashing is done before the compression and the compression is
done for isolated blocks, then this could even work!

Any takers? ;-)


For a performance enhancement, keep a hash tree in memory for the "n"
most recently used/seen blocks?...


A good writeup! Thanks for a good giggle. :-)

Regards,
Martin



On 01/04/13 15:44, Harald Glatt wrote:
> On Mon, Apr 1, 2013 at 2:50 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> Hello,
>>
>> I was bored this weekend so I hacked up online dedup for Btrfs.  It's working
>> quite well so I think it can be more widely tested.  There are two ways to use
>> it
>>
>> 1) Compatible mode - this is a bit slower but will handle being used by older
>> kernels.  We use the csum tree to find duplicate blocks.  Since it is relatively
>> easy to have crc32c collisions this also involves reading the block from disk
>> and doing a memcmp with the block we want to write to verify it has the same
>> data.  This is way slow but hey, no incompat flag!
>>
>> 2) Incompatible mode - so this is the way you probably want to use it if you
>> don't care about being able to go back to older kernels.  You select your
>> hashing function (at the momement I only support sha1 but there is room in the
>> format to have different functions).  This creates a btree indexed by the hash
>> and the bytenr.  Then we lookup the hash and just link the extent in if it
>> matches the hash.  You can use -o paranoid-dedup if you are paranoid about hash
>> collisions and this will force it to do the memcmp() dance to make sure that the
>> extent we are deduping really matches the extent.
>>
>> So performance wise obviously the compat mode sucks.  It's about 50% slower on
>> disk and about 20% slower on my Fusion card.  We get pretty good space savings,
>> about 10% in my horrible test (just copy a git tree onto the fs), but IMHO not
>> worth the performance hit.
>>
>> The incompat mode is a bit better, only 15% drop on disk and about 10% on my
>> fusion card.  Closer to the crc numbers if we have -o paranoid-dedup.  The space
>> savings is better since it uses the original extent sizes, we get about 15%
>> space savings.  Please feel free to pull and try it, you can get it here
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git dedup
>>
>> Thanks!
>>
>> Josef
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hey Josef,
> 
> that's really cool! Can this be used together with lzo compression for
> example? How high (roughly) is the impact of something like
> force-compress=lzo compared to the 15% hit from this dedup?
> 
> Thanks!
> Harald




