Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:47718 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751911AbdLBRSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Dec 2017 12:18:21 -0500
Date: Sat, 2 Dec 2017 18:18:19 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202171819.GA4629@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl>
 <20171202162812.GA5324@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20171202162812.GA5324@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 02, 2017 at 17:28:12 +0100, Tomasz Pala wrote:

>> Suppose you start with a 100 MiB file (I'm adjusting the sizes down from
> [...]
>> Now make various small changes to the file, say under 16 KiB each.  These
>> will each be COWed elsewhere as one might expect. by default 16 KiB at
>> a time I believe (might be 4 KiB, as it was back when the default leaf
> 
> I got ~500 small files (100-500 kB) updated partially in regular
> intervals:
> 
> # du -Lc **/*.rrd | tail -n1
> 105M    total
> 
>> But here's the kicker.  Even without a snapshot locking that original 100
>> MiB extent in place, if even one of the original 16 KiB blocks isn't
>> rewritten, that entire 100 MiB extent will remain locked in place, as the
>> original 16 KiB blocks that have been changed and thus COWed elsewhere
>> aren't freed one at a time, the full 100 MiB extent only gets freed, all
>> at once, once no references to it remain, which means once that last
>> block of the extent gets rewritten.

OTOH - should this happen with nodatacow files? As I mentioned before,
these files are chattred +C (however this was not their initial state
due to https://bugzilla.kernel.org/show_bug.cgi?id=189671 ).
Am I wrong thinking, that in such case they should occupy twice their
size maximum? Or maybe there is some tool that could show me the real
space wasted by file, including extents count etc?

-- 
Tomasz Pala <gotar@pld-linux.org>
