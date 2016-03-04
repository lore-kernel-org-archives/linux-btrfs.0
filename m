Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5165 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbcCDB4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 20:56:25 -0500
Subject: Re: Byte comparison before hashing
To: Nikolai Viktorovich <nikolai.viktorovich@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <CACSpBpFBW=t1hyejRVxkzuauZy-18e3S4RoyCby4mUJMdtWftw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D8E42C.6030106@cn.fujitsu.com>
Date: Fri, 4 Mar 2016 09:26:04 +0800
MIME-Version: 1.0
In-Reply-To: <CACSpBpFBW=t1hyejRVxkzuauZy-18e3S4RoyCby4mUJMdtWftw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Nikolai Viktorovich wrote on 2016/03/03 20:50 -0300:
> First of all: Thanks for the great work on btrfs!
> How about taking only few bytes of data from each block and compare
> those, before attempting to hash? This way you could quickly discard
> blocks with really no similar data and hash only ones that matched the
> "first look" byte comparison? This could lead to less CPU consumption,
> since hashing is an intense operation, and to less memory footprint,
> since you don't need to store all those non-dedupable hashes.

I assume you're talking about in-band dedup.
For that case, byte-by-byte comparison is in our future planned feature 
list, for using faster but more conflicts algorithm.

The problem we don't do it at beginning(and even not some time soon) is:
1) Lack of facility to read page without inode
    Read page inside one inode is easy, but without inode, maybe I'm
    missing something, but at least I didn't find a proper and easy
    facility to  do it now.

2) Delayed ref hell
    Current implement is already spending a lot of code to handling
    possible delayed ref problem.
    If doing byte-by-byte comparison, we need to handle delayed ref for
    both extents(the one we read to compare and the one we are writing
    back)

    I prefer to do it only after we have a better way to deal with
    delayed ref. E.g only permit run_delayed_ref() inside commit_trans().

3) Performance
    If one hash algorithm needs byte-to-byte comparison, then not the
    beginning, but the whole range must be read out and do the
    comparison.

    Some hash, IIRC md5, is easy to conflict, one user(attacker) can
    easily build two blocks, which have the same md5 and the same
    several beginning bytes.

    Due to this, if we do it performance may be impacted for hash hit
    case.(depending on the memory pressure).

So we may finally add such feature for inband dedup, but not now, not 
anytime soon.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


