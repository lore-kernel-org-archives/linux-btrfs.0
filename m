Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41276 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754686AbdDPAlm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 20:41:42 -0400
Subject: Re: remount and conflicting ssd options?
To: Chris Murphy <chris@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
 <20170415183156.mmgm6t4rygm2mt3j@angband.pl>
 <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
 <20170415185049.ig65w5pi22d42ajm@angband.pl>
 <CAJCQCtTyGHUFVsXcK35N3fA_xjb04UGo+j7UFaf2_Aj6pFs0_Q@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b3d118de-b4ec-ef74-e8b4-bc8aaed8dd62@mendix.com>
Date: Sun, 16 Apr 2017 02:41:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTyGHUFVsXcK35N3fA_xjb04UGo+j7UFaf2_Aj6pFs0_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/15/2017 10:35 PM, Chris Murphy wrote:
> On Sat, Apr 15, 2017 at 12:50 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> On Sat, Apr 15, 2017 at 12:41:14PM -0600, Chris Murphy wrote:
>>> On Sat, Apr 15, 2017 at 12:31 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>>>> On Sat, Apr 15, 2017 at 12:17:25PM -0600, Chris Murphy wrote:
>>>>> Then later I tried
>>>>>
>>>>> mount -o remount,ssd
>>>>>
>>>>> To go back to regular ssd option, but nothing happens, mount still
>>>>> shows ssd_spread.
>>>>
>>>> ssd_spread implies ssd.
>>>
>>> OK so it's possible to remount from ssd to ssd_spread but not back to
>>> ssd? If I trust the mount output, it's only possible to transition
>>> from ssd to ssd_spread, but not from ssd_spread to ssd.
>>
>> Yeah.  This is a very minor problem (workaround: remount with nossd then
>> ssd), but in the light of Hans van Kranenburg's findings, it'd be a bad idea
>> to introduce new mount options the kernel would need to keep recognizing
>> forever, as the effect of those options needs some rethinking anyways.
> 
> Yeah it's confusing aside from the mount behavior.
> 
> I have a performance test based on doing a bunch of system updates
> (~100 rpm packages), and even with the same mount options, back to
> back tests are sufficiently inconsistent that I can't tell which of
> the allocator options is better.

Do you run the test with exact the same starting point (all bits on disk
in the same place, drop caches), or do you run it over and over again
while the filesystem is deepening its own grave every time?

> So the allocation options must be
> about something other than time based performance.

They're about the size of free space fragments that are (re)used.
Switching allocator policy on the same fs rapidly might give weird
results because some fragmented free space that was left behind by the
previous test might suddenly show up as delicious supper for the next.

> I can't tell what is a slow ssd these days so I'm not sure what ssd vs
> ssd_spread really mean.

afaikrn:
ssd = ignore 'small' free space fragments ('small' being something I
haven't figured out yet)
ssd_spread = do not split up a write in multiple extents

> Plus then on spinning rust people have
> reported better performance with ssd rather than the default of nossd.
> While others who are using iSCSI end up with ssd by default and worse
> results than with nossd.

<rant:)>So far we learned that the options were designed for the types
of SSD that you would be able to buy 10 years ago, that they cause
changes in write behaviour and that they tend to forget to take
(recursive-exploding) cow overhead for metadata writes into account.</rant>

-- 
Hans van Kranenburg
