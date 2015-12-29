Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36574 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbL2C61 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 21:58:27 -0500
Received: by mail-ig0-f179.google.com with SMTP id ph11so155904768igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 18:58:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSfyTAJuEmsddyHEzwU335eQJmHWr6+a4JqpV0shZfjkQ@mail.gmail.com>
References: <CAJCQCtT78=kqXZVDAV-x0C1NW=7okBBM_+vM3+HAc5BtUArsiw@mail.gmail.com>
	<pan$5afbb$4270f15d$d1ce1c42$cc039fab@cox.net>
	<CAJCQCtSfyTAJuEmsddyHEzwU335eQJmHWr6+a4JqpV0shZfjkQ@mail.gmail.com>
Date: Mon, 28 Dec 2015 19:58:27 -0700
Message-ID: <CAJCQCtQHRTVJd8hq5r=guycr9WpZY-S2m01R=+bL8yhNU3NjAQ@mail.gmail.com>
Subject: Re: should btrfsck fix a bad superblock?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 28, 2015 at 7:46 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Dec 28, 2015 at 7:28 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Chris Murphy posted on Mon, 28 Dec 2015 17:10:14 -0700 as excerpted:
>>
>>> Hi,
>>>
>>> I (intentionally) used wipefs -a on a device with a btrfs. As expected
>>> btrfs check doesn't recognize the device as having a btrfs volume
>>> anymore.
>>>
>>> Slightly surprising that it doesn't mention other intact supers are
>>> found.
>>>
>>> Most surprising that options -s1 --repair doesn't fix it.
>>>
>>> I thought maybe it's intentional, only with explicitly bad magic, and
>>> I'd get different results if it were zero'd. So I zero'd it and I get
>>> the same results. s0 superblock isn't repaired with --repair.
>>>
>>> Bug?
>>>
>>> Of course I can fix it with echo+dd.
>>
>> Btrfs check's -s option simply lets you use a different superblock.  I
>> don't believe check is designed to actually fix superblocks, tho I guess
>> with --repair it fixes certain bad fields in them.
>>
>> What you want to actually recover bad superblocks from good copies is
>> btrfs rescue super-recover.
>
> Yep! I forgot about that. But it's still confusing that particular
> repair is split out.

OK so the warning I get from rescue super-recover makes this make sense:

[root@f23m ~]# btrfs rescue super-recover /dev/sdb
Make sure this is a btrfs disk otherwise the tool will destroy other
fs, Are you sure? [y/N]: n


It looks like it's a rudimentary check for only btrfs superblocks and
isn't checking if the fs could plausibly be some other file system,
which is admittedly quite a burden for any tool to have to do.

-- 
Chris Murphy
