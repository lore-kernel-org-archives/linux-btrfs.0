Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:48468 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751167AbeC3QO4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 12:14:56 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Status of RAID5/6
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
Date: Fri, 30 Mar 2018 18:14:52 +0200
MIME-Version: 1.0
In-Reply-To: <20180329215011.GC2446@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/29/2018 11:50 PM, Zygo Blaxell wrote:
> On Wed, Mar 21, 2018 at 09:02:36PM +0100, Christoph Anton Mitterer wrote:
>> Hey.
>>
>> Some things would IMO be nice to get done/clarified (i.e. documented in
>> the Wiki and manpages) from users'/admin's  POV:
[...]
> 
>>   - changing raid lvls?
> 
> btrfs uses a brute-force RAID conversion algorithm which always works, but
> takes zero short cuts.  e.g. there is no speed optimization implemented
> for cases like "convert 2-disk raid1 to 1-disk single" which can be
> very fast in theory.  The worst-case running time is the only running
> time available in btrfs.

[...]
What it is reported by Zygo is an excellent source of information. However I have to point out that BTRFS has a little optimization: i.e. scrub/balance only works on the allocated chunk. So a partial filled filesystem requires less time than a nearly filled one

> 
> btrfs has no optimization like mdadm write-intent bitmaps; recovery
> is always a full-device operation.  In theory btrfs could track
> modifications at the chunk level but this isn't even specified in the
> on-disk format, much less implemented.

It could go even further; it would be sufficient to track which *partial* stripes update will be performed before a commit, in one of the btrfs logs. Then in case of a mount of an unclean filesystem, a scrub on these stripes would be sufficient.

BR
G.Baroncelli

[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
