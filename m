Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-lucinda.wadns.net ([196.220.39.179]:39968 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756737AbaEEVra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 17:47:30 -0400
Message-ID: <536806E5.9010409@swiftspirit.co.za>
Date: Mon, 05 May 2014 23:47:17 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Thoughts on RAID nomenclature
References: <20140505211738.GS24298@carfax.org.uk>
In-Reply-To: <20140505211738.GS24298@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/05 11:17 PM, Hugo Mills wrote:
>     A passing remark I made on this list a day or two ago set me to
> thinking. You may all want to hide behind your desks or in a similar
> safe place away from the danger zone (say, Vladivostok) at this
> point...

I feel like I can brave some "mild horrors". Of course, my C skills 
aren't up to scratch so its all just bravado. ;)
>     If we switch to the NcMsPp notation for replication, that
> comfortably describes most of the plausible replication methods, and
> I'm happy with that. But, there's a wart in the previous proposition,
> which is putting "d" for 2cd to indicate that there's a DUP where
> replicated chunks can go on the same device. This was the jumping-off
> point to consider chunk allocation strategies in general.
>
>     At the moment, we have two chunk allocation strategies: "dup" and
> "spread" (for want of a better word; not to be confused with the
> ssd_spread mount option, which is a whole different kettle of
> borscht). The dup allocation strategy is currently only available for
> 2c replication, and only on single-device filesystems. When a
> filesystem with dup allocation has a second device added to it, it's
> automatically upgraded to spread.

I thought this step was manual - but okay! :)
>     The general operation of the chunk allocator is that it's asked for
> locations for n chunks for a block group, and makes a decision about
> where those chunks go. In the case of spread, it sorts the devices in
> decreasing order of unchunked space, and allocates the n chunks in
> that order. For dup, it allocates both chunks on the same device (or,
> generalising, may allocate the chunks on the same device if it has
> to).
>
>     Now, there are other variations we could consider. For example:
>
>   - linear, which allocates on the n smallest-numbered devices with
>     free space. This goes halfway towards some people's goal of
>     minimising the file fragments damaged in a device failure on a 1c
>     FS (again, see (*)). [There's an open question on this one about
>     what happens when holes open up through, say, a balance.]
>
>   - grouped, which allows the administrator to assign groups to the
>     devices, and allocates each chunk from a different group. [There's
>     a variation here -- we could look instead at ensuring that
>     different _copies_ go in different groups.]
>
>     Given these four (spread, dup, linear, grouped), I think it's
> fairly obvious that spread is a special case of grouped, where each
> device is its own group. Then dup is the opposite of grouped (i.e. you
> must have one or the other but not both). Finally, linear is a
> modifier that changes the sort order.
>
>     All of these options run completely independently of the actual
> replication level selected, so we could have 3c:spread,linear
> (allocates on the first three devices only, until one fills up and
> then it moves to the fourth device), or 2c2s:grouped, with a device
> mapping {sda:1, sdb:1, sdc:1, sdd:2, sde:2, sdf:2} which puts
> different copies on different device controllers.
>
>     Does this all make sense? Are there any other options or features
> that we might consider for chunk allocation at this point? Having had
> a look at the chunk allocator, I think most if not all of this is
> fairly easily implementable, given a sufficiently good method of
> describing it all, which is what I'm trying to get to the bottom of in
> this discussion.

I think I get most of what you're saying. If its not too difficult, 
perhaps you could update (or duplicate to another URL) your 
/btrfs-usage/ calculator to reflect the idea. It'd definitely make it 
easier for everyone (including myself) to know we're on the same page.

I like the idea that the administrator would have more granular control 
over where data gets allocated first or where copies "belong". 
"Splicing" data to different controllers as you mentioned can help with 
both redundancy and performance.

Note: I've always thought of dup as a special form of "spread" where we 
just write things out twice - but yes, there's no need for it to be 
compatible with any other allocation type.
>     Hugo.
>
> (*) The missing piece here is to deal with extent allocation in a
> similar way, which would offer better odds again on the number of
> files damaged in a device-loss situation on a 1c FS. This is in
> general a much harder problem, though. The only change we have in this
> area at the moment is ssd_spread, which doesn't do very much. It also
> has the potential for really killing performance and/or file
> fragmentation.
>


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

