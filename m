Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51730 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdDCWn7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 18:43:59 -0400
Subject: Re: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
References: <20170331171016.GN4781@twin.jikos.cz>
 <20170331200850.7067-1-kilobyte@angband.pl>
 <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
 <20170403122454.GT4781@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <06cd6e94-1ffa-f6b7-acd2-cc122d2fd5f2@mendix.com>
Date: Tue, 4 Apr 2017 00:43:57 +0200
MIME-Version: 1.0
In-Reply-To: <20170403122454.GT4781@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2017 02:24 PM, David Sterba wrote:
> On Fri, Mar 31, 2017 at 10:24:57PM +0200, Hans van Kranenburg wrote:
>>>> Adding the 'nossd_spread' would be good to have, even if it might be
>>>> just a marginal usecase.
>>
>> Please no, don't make it more complex if not needed.
> 
> The only use is when ssd,ssd_spread are on and then I'd just want to
> disable ssd_spread, without disabling ssd at the same time.
> 
> 1. mount -o ssd,ssd_spread
> 2. mount -o remount,nossd_spread
> 
> compared to
> 
> 1. mount -o ssd,ssd_spread
> 2. mount -o remount,nossd
> 3. mount -o remount,ssd
> 
> I'd vote for adding nossd_spread, as the 'no-' options are common and
> otherwise disabling ssd_spread would be another usage exception.

Yes, 'nossd_spread' would intuitively be the thing to try to get rid of
'ssd_spread' on a mounted fs. But, nossd_spread is not a feature, just
like noautodefrag isn't. nossd *is* a feature, but also a remount
option... :o)

The mount manpage displays the values as a choice between 3 exclusive
options: ssd|nossd|ssd_spread

They're like an increasing level of magic that is being applied:
   nossd < ssd < ssd_spread

So, that documentation with the | makes me think: I have to choose
either one. But that's not how it behaves, since some of them can appear

But don't listen to me, I don't know what the best thing is.

>>> Not sure if there's much point.  In any case, that's a separate patch.
>>> Should I add one while we're here?
>>
>> Since the whole ssd thing is a bit of a joke actually, I'd rather see it
>> replaces with an option to choose an extent allocator algorithm.
> 
> Yeah, SSD is not the shiny new tech anymore, so we'd need something more
> future proof.
> 
>> The amount of if statements using this SSD things in btrfs in the kernel
>> can be counted on one hand, and what they actually do is quite
>> questionable (food for another mail thread).
> 
> That's right, do you have suggestions for futher SSD optimizations?
> Other than better block alignment, faster flushes and no seek penalty, I
> don't see much else.

Yes, I'd like to start a discussion about that, but not buried in this
thread, and it's not about SSDs, but about a larger filesystem than the
average desktop computer and trade-offs between free space fragmentation
(going ENOSPC when 30 of your 40TiB is in use...) and metadata write
amplification (smaller writes leading to more cow, and, "let's track
extent tree storage inside the extent tree", which causes huge
avalanches of writing and writing and writing metadata with nossd).

And currently it's the ssd options that are influencing this a bit. But,
it doesn't make sense to punish people with a slow rotating drive with
things like having to write 40GiB of metadata when you feed 1 GiB of
data to balance...

But, more about that later, otherwise this is going to look too much
like a rant.

-- 
Hans van Kranenburg
