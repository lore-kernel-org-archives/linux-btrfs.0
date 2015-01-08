Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:49068 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbbAHIYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 03:24:54 -0500
Received: by mail-yh0-f50.google.com with SMTP id b6so588085yha.9
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 00:24:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54AD929E.608@fb.com>
References: <20150107174315.GA21865@gardel-login>
	<54AD929E.608@fb.com>
Date: Thu, 8 Jan 2015 01:24:53 -0700
Message-ID: <CAJCQCtQGrPSJhxvbivJ4Sx0rqposm72rcC0K-C5SCCRADR_QNg@mail.gmail.com>
Subject: Re: price to pay for nocow file bit?
From: Chris Murphy <lists@colorremedies.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Lennart Poettering <lennart@poettering.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 7, 2015 at 1:10 PM, Josef Bacik <jbacik@fb.com> wrote:
> On 01/07/2015 12:43 PM, Lennart Poettering wrote:
>>
>> Heya!
>>
>> Currently, systemd-journald's disk access patterns (appending to the
>> end of files, then updating a few pointers in the front) result in
>> awfully fragmented journal files on btrfs, which has a pretty
>> negative effect on performance when accessing them.
>>
>
> I've been wondering if mount -o autodefrag would deal with this problem but
> I haven't had the chance to look into it.

I've been using autodefrag and haven't run into journal corruptions
that I can attribute to btrfs since the last one was fixed over a year
ago. Chris Mason has suggested preference to use of autodefrag for
this use case rather than xattr +C. But I don't know the time frame
for autodefrag by default, it's come up a couple times but it's not
the default yet.

I've found autodefrag journals are less than 200 fragments, and
average between 50-150 fragments. Without it, this spirals into
thousands quite quickly. Searches don't seem slower when journal files
are made of a few extents vs ~ 100, but beyond several hundred let
alone several thousand it becomes noticeable.

A somewhat minor negative of +C: In case of RAID 1 or higher and
silent data corruption, there will be no Btrfs detection due to lack
of checksum and therefore no correction. In the case a drive reports a
read error then it's corrected, same as with md or lvm raid1+.


-- 
Chris Murphy
