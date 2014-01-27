Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:43792 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0Vnz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 16:43:55 -0500
Message-ID: <52E6D0C5.7050707@inwind.it>
Date: Mon, 27 Jan 2014 22:33:57 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Gerhard Heift <gerhard@heift.name>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name> <52E6AF3C.1070401@libero.it> <20140127193123.GO3314@carfax.org.uk>
In-Reply-To: <20140127193123.GO3314@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

On 2014-01-27 20:31, Hugo Mills wrote:
>> > One of the main strangeness of the current TREE_SEARCH ioctl, which I
>> > found is the fact that the search was not in a "rectangular" region, but
>> > in a "linear" region.
>> > This is due the fact that after a ioctl call, we have to set the min_*
>> > fields with the sh->{objectid,offset,type} +1 rounding to 0 if case of
>> > overflow.
>> > 
>> > This because the min_* fields are both the "lower bound" of the search
>> > and the "starting point" of the next search. Adding a new set of fields
>> > named start_* could solve this issue.
>> > 
>> > I discussed this topic few years ago in [1].
>> > 
>> > Because we are introducing a new ioctl, is it possible to solve this
>> > issue ? We could avoid some userspace<->kernelspace transition, which
>> > seems be one of the goal of your patch.
>    Aargh, not this again. :(
> 
>    The keyspace is *linear*, consisting of a concatenation of three
> data fields, sorted lexically. This is how they're stored in the
> trees, and it's how they're returned by TREE_SEARCH. 

I never told anything different

> You can't
> traverse the keyspace with an O(1) "next" operation in anything other
> than that order. 

I didn't requested that. I am suggesting to filter out in the kernel
space the "out of range" values, to avoid return them in user space. The
search is still performed in "linear" mode.

Now, the min_* values are updated with the last key found+1 after each
ioctl. I am only suggesting to never reset the min_* values and to add
other three fields to store the "cursor" position.

When a key is found, it is checked in kernel space if it is valid or
none (if it is in the range min_* ... max_*). If it is valid, it is
returned in user space; in *any case* the search starts from the last+1 key.

Today this is not possible, because the min_* values are overridden.

I repeat, the search is still performed linearity (ok, some values could
be skipped but this is a further optimization); I want only to avoid
kernel space returning "out of range" data.

BR
Goffredo


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
