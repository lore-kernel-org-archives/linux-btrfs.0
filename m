Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:45188 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAKUj1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 15:39:27 -0500
Received: by mail-yh0-f50.google.com with SMTP id b6so8158004yha.9
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Jan 2015 12:39:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150108133036.GA23096@gardel-login>
References: <20150107174315.GA21865@gardel-login>
	<54AD929E.608@fb.com>
	<20150108133036.GA23096@gardel-login>
Date: Sun, 11 Jan 2015 13:39:26 -0700
Message-ID: <CAJCQCtSL-FQfEZptTz7OZc08GKLJ=sDcoS3K3URF49qyOpextA@mail.gmail.com>
Subject: Re: price to pay for nocow file bit?
From: Chris Murphy <lists@colorremedies.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: Josef Bacik <jbacik@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 8, 2015 at 6:30 AM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Wed, 07.01.15 15:10, Josef Bacik (jbacik@fb.com) wrote:
>
>> On 01/07/2015 12:43 PM, Lennart Poettering wrote:
>> >Heya!
>> >
>> >Currently, systemd-journald's disk access patterns (appending to the
>> >end of files, then updating a few pointers in the front) result in
>> >awfully fragmented journal files on btrfs, which has a pretty
>> >negative effect on performance when accessing them.
>>
>> I've been wondering if mount -o autodefrag would deal with this problem but
>> I haven't had the chance to look into it.
>
> Hmm, I am kinda interested in a solution that I can just implement in
> systemd/journald now and that will then just make things work for
> people suffering by the problem. I mean, I can hardly make systemd
> patch the mount options of btrfs just because I place a journal file
> on some fs...
>
> Is "autodefrag" supposed to become a default one day?
>
> Anyway, given the pros and cons I have now changed journald to set the
> nocow bit on newly created journal files. When files are rotated (and
> we hence know we will never ever write again to them) the bit is tried
> to be unset again, and a defrag ioctl will be invoked right
> after. btrfs currently silently ignores that we unset the bit, and
> leaves it set, but I figure i should try to unset it anyway, in case
> it learns that one day. After all, after rotating the files there's no
> reason to treat the files special anymore...

I don't think it makes sense to unset nocow on a non-zero byte file
anymore than it makes sense to set it. The functional equivalent
that'd need to be done is:

touch system@<blah>.journal~
chattr -C system@<blah>.journal~
cp system@<blah>.journal system@<blah>.journal~

The copy won't have nocow set.

I suggest just leaving it alone. +C the /var/log/journal/ directory
before machine-name directories are created, and then everything in
there automatically inherits +C upon creation. No need to unset or
defrag, in particular on SSD's I think it's sorta pointless excess
writing. Set it and forget it policy.


-- 
Chris Murphy
