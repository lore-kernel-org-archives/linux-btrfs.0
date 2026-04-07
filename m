Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7138C3AB272
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585633; cv=none; b=SeR8CUMX6v/FgCnO05+MON/bv+IC21usiniMGfmq4+DhN1oaOk65iqo/6op99S9W7JW00YG/bmfyf1VtsoP5gUqb2mFqDgryad9danl9shTQ6c/j+RAR0Eosyt7PMiKp4xIpWxCurjR3AQSoRdMHlco65SwLS7I3PCqdRWemkuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585633; c=relaxed/simple;
	bh=pYRXcCZrbXAO/1g3mwS+kVleWGXDK1/4tWyaVxHWtHQ=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cv/hrEmkl/dyuxcDCK2NoUMYn5uVwPTqCItSiNeRSAsSS0kTjLGkiHq1TgR4/rCnJkURqHJULo6WGSqiJGyASplGGIHzjQc8li49UyB/FxvfxZW834vUfPMiE0WvRQ9duVvvly5vwjnYqkS1ufw5E+L6Og8yHJH0BGU/c6Talrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=ik4qxId5; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="ik4qxId5"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 7A61931A477;
	Tue,  7 Apr 2026 19:13:45 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1775585625;
	bh=7XoRHogLJFY6uB0g6UW3hCPrFJzQHX5YoiVksE5GQyU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ik4qxId50BvIF4ktCAodQ/QpYM6WA4PS5XNJY1zliAYr0JBnNIgxp+YfKSUIS99AE
	 xJ5DikmlkFyq8cmkpFbrJmLdjrfiqze/n18kHgVQ07HImc2vcgnxIPsua9hsZmKxz9
	 To15630JN5okb2ULvD4utDtTWIIhlLXqTh/8GOBc=
Message-ID: <a40afd17-bfb6-486d-8632-9663d6cf7ce3@harmstone.com>
Date: Tue, 7 Apr 2026 19:13:45 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
 <20260403224449.GA1806609@zen.localdomain>
 <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I think all three of us are confusing each other a little here.

The ioctl answers the question: if I were to read X bytes of data from a 
file at Y offset and calculated the csums manually, what would the value 
be? To which the kernel responds either with the values, that the read 
is guaranteed to return zero and thus we can use the precomputed csum 
for the zero sector, or that the value isn't known and userspace has to 
do it anyway.

The value isn't known if it's a nodatasum file or if it's compressed. We 
store the csums of compressed extents, but crucially it's over the 
compressed data. So there's no one-to-one mapping between file blocks 
and compressed sectors (by definition, because it's compressed), and 
bookending means that it might be data we don't have access to.

We absolutely can't give non-root users csums to arbitrary data, that's 
definitely a security breach.

Userspace can already obtain the csums from the disk for a file by using 
FIEMAP and the tree search ioctl. But I believe the consensus around the 
tree search ioctl is a) that it's very difficult to use, as you need to 
know the internals of btrfs, and b) it requires CAP_SYS_ADMIN, at a time 
when containerization and finer-grained access controls means this is 
frowned upon.

This ioctl is a simpler way of doing the csum lookup, and without 
requiring root.

On 04/04/2026 12.00 am, Qu Wenruo wrote:
> 
> 
> 在 2026/4/4 09:14, Boris Burkov 写道:
>> On Fri, Apr 03, 2026 at 08:16:26AM +1030, Qu Wenruo wrote:
>>>
>>>
>>> 在 2026/4/3 03:35, Mark Harmstone 写道:
>>>> On 25/03/2026 9.04 pm, Qu Wenruo wrote:
>>> [...]
>>>>>
>>>>> That's done by progs through fiemap. There will be a flag ENCODED
>>>>> for compressed file extents.
>>>>
>>>> No, this still won't work I'm afraid. The ioctl is answering the
>>>> question "what's the csum of the sector no. such-and-such in this
>>>> file?". That can't be answered for compressed extents, as the csums are
>>>> on the compressed data.
>>>
>>> My point is, since you are not trying to fetching the csum of compressed
>>> extent in the first place, you don't need to bother that situation at 
>>> all.
>>>
>>> And even for compressed extents, it is still possible to fetch the csum,
>>> after all we're just search the csum tree for a given logical bytenr.
>>>
>>> There will be some extra concerns like fiemap can not return the real
>>> compressed length, but again we ruled our compressed extents in the 
>>> first
>>> place.
>>>
>>
>> I may be misinterpreting, but I feel like the question at hand is how
>> much hardening the ioctl requires to be correct, and how much work it
>> can delegate to userspace.
>>
>> Suppose we make it require root, I think we could make the interface
>> much simpler and just use the logical offsets instead of a file based
>> interface, and we can leave it up to userspace entirely to figure out
>> which ranges they care about.
>>
>> OTOH, if we agree we want the csums ioctl to be unprivileged, which
>> means that the interface must assume that the input could be bad, on
>> overlapping extents, not marked up properly, etc... In that case, I do
>> not quite know *exactly* what is redundant with fiemap, what is exactly
>> necessary for safety vs for caller convenience, etc.
>>
>> Basically, I think the options are roughly:
>>
>> - Mark's proposal: A smart, convenient GET_CSUMS that does everything
>>    turnkey and as helpfully as possible. Lots of redundance with fiemap.
>>    Safe to make unprivileged.
>> - Qu's review: Require the user to do the fiemap part themselves and
>>    don't make GET_CSUMS quite as turnkey. It is unclear to me whether it
>>    is possible to make such a version unprivileged safely *without*
>>    the fiemap redundancy.
>> - Boris's strawman: A dumb, inconvenient GET_CSUMS that expects a lot of
>>    userspace but doesn't check anything and definitely needs root. If we
>>    do go root-only, I feel like this might be the best interface?
> 
> Well, my idea is more aligned with yours, except the root part.
> 
> Our ideas share the same part, the ioctl just handles things inside the 
> csum tree without bothering subvolume tree.
> 
> Yes, bad inputs can lead to a lot of information leakage if we allow 
> non-root users to use this ioctl, but I doubt if they can really do 
> anything with the information they got.
> 
> One still needs proper privilege to call fiemap on a file, so even if 
> one knows there are some csum at random logical bytenr, unless they can 
> access fiemap result of files that are utilizing those bytenrs, the csum 
> is still useless.
> 
> But I'm also fine with root privilege requirement for the ioctl too, as 
> to me stricter requirement has no obvious disadvantage, and can release 
> us from safety concerns.
> 
>>
>> And the questions are:
>> 1. How badly do we want non-root? In practice, mkfs is root when writing
>> disks but not necessarily when writing image files, so it's a bit of a
>> toss up there. At meta we tend to end up sad when mkfs has root-only
>> functionality that we want.
> 
> I'm fine either way.
> 
>> 2. What is the bare minimum processing needed to safely allow non-root
>> callers with arbitrarily wrong input? I don't see how we can assume they
>> will use fiemap correctly and not hit bookends, or set correct tags on
>> the input, for a few examples.
> 
> They just pass random logical into the ioctl, and we return whatever 
> they want, including something to show which range has csum, and the csum.
> 
> Let me be clear again, it's just a variant of TREE_SEARCH, except the 
> existing TREE_SEARCH is not good enough for csum tree search.
> 
> We don't need to bother if it's bookend/compressed or whatever, if they 
> want to do stupid things, that's their choice, and just reading the csum 
> shouldn't cause any writes/effects/damage to the fs, so let they do 
> whatever.
> 
> Thanks,
> Qu
> 
>>
>> Thanks,
>> Boris
>>
> 

