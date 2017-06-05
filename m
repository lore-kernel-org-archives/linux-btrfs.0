Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:50834 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdFEWQf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 18:16:35 -0400
Subject: Re: [PATCH] Btrfs: Improve btrfs_ioctl_search_key documentation
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
 <6a978495-bbae-97d1-fb21-6b6015898c11@inwind.it>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <aaba3df8-759e-f094-3769-d385caadba67@mendix.com>
Date: Tue, 6 Jun 2017 00:16:33 +0200
MIME-Version: 1.0
In-Reply-To: <6a978495-bbae-97d1-fb21-6b6015898c11@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2017 09:00 PM, Goffredo Baroncelli wrote:
> On 2017-06-05 17:27, Hans van Kranenburg wrote:
>> +	 * When doing a tree search, we're actually taking a slice from a linear
>> +	 * search space of 136-bit keys:
>> +	 *
>> +	 * Key of the first possible item to be returned:
>> +	 *   (min_objectid << 72) + (min_type << 64) + min_offset
>> +	 * Key of the last possible item to be returned:
>> +	 *   (max_objectid << 72) + (max_type << 64) + max_offset
>> +	 *
> As non English people, I prefer a less verbose [...]

Yeah, it's a bit meh... I started to change the text again and ended up
rewriting it in a different way for patch V2 (sending in a minute).

> [...] and more programmatic form, like:
> 
> +	 * When doing a tree search, we're actually taking a slice from a linear
> +	 * search space of 136-bit keys:
> +        *
> +	 * A key is returned if 
> +	 *   ((min_objectid << 72) + (min_type << 64) + min_offset  <=
> +        *        (objectid << 72) + (type << 64) + offset))  &&
> +	 *   ((max_objectid << 72) + (max_type << 64) + max_offset >= 
> +        *        (objectid << 72) + (type << 64) + offset))
> +        *

TBH, these lines mostly have an effect of dancing around before my eyes.

The point is, the search starts somewhere, end it ends somewhere. All
intermediate objects are returned. The min/max values are not applied as
a check to every key found in that range again. This way of explaining
("is returned if") adds to that wrong idea again imho.

>> +	 * [...] In other
>> +	 * words, they are not used to filter the type or offset of intermediate
>> +	 * keys encountered.
> 
> Even this is correct, I still find a bit complicate to fully understand the meaning.
> 
> I would prefer to replace "not used" with "not usable"... But as stated above I am not a native English people :-)

I'm dutch. ;) But for the user, using usable instead of used is nice
indeed, because it provides something that can be acted on, instead of
having something somewhere that "uses" it and apparently makes decisions
about what it does for some reason. Anyway, in the rewrite of that part
above, it's gone.

-- 
Hans van Kranenburg
