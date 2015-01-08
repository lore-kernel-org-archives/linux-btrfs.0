Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45510 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbAHSYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 13:24:17 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5070230wiv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 10:24:16 -0800 (PST)
Message-ID: <54AECB72.9@gmail.com>
Date: Thu, 08 Jan 2015 20:24:50 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, Josef Bacik <jbacik@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
References: <20150107174315.GA21865@gardel-login> <54AD929E.608@fb.com> <20150108133036.GA23096@gardel-login>
In-Reply-To: <20150108133036.GA23096@gardel-login>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/1/2015 3:30 μμ, Lennart Poettering wrote:
> On Wed, 07.01.15 15:10, Josef Bacik (jbacik@fb.com) wrote:
>
>> On 01/07/2015 12:43 PM, Lennart Poettering wrote:
>>> Heya!
>>>
>>> Currently, systemd-journald's disk access patterns (appending to the
>>> end of files, then updating a few pointers in the front) result in
>>> awfully fragmented journal files on btrfs, which has a pretty
>>> negative effect on performance when accessing them.
>> I've been wondering if mount -o autodefrag would deal with this problem but
>> I haven't had the chance to look into it.
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
Can this behaviour be optional? I dont mind some fragmentation if i can 
keep having checksums and the ability for raid 1 to repair those files.

> I'll keep an eye on this, and see if I still get user complaints about
> it. Should autodefrag become default eventually we can get rid of this
> code in journald again.
>
> One question regarding the btrfs defrag ioctl: playing around with it
> it appears to be asynchronous, the defrag request is simply queued and
> the ioctl returns immediately. Which is great for my usecase. However
> I was wondering if it always was async like this? I googled a bit, and
> found reports that defrag might take a while, but I am not sure if
> those reports were about the ioctl taking so long, or the effect of
> defrag actually hitting the disk...
>
> Lennart
>

