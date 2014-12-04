Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:39518 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532AbaLDSRu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 13:17:50 -0500
Message-ID: <5480A54C.6050900@pobox.com>
Date: Thu, 04 Dec 2014 10:17:48 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
References: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com> <54806C19.4090503@gmail.com> <CAH-HCWXXerTeeXGoQhpj-eXO78H45f6rDje4Oh2CDuZDS8-cww@mail.gmail.com>
In-Reply-To: <CAH-HCWXXerTeeXGoQhpj-eXO78H45f6rDje4Oh2CDuZDS8-cww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I _think_ the "extra" single entries are the entries that deal with the 
disk/partition itself and therefore can not ever be distributed.

So like the BTRFS signatures that say "this is the third disk of this 
array" (as opposed to the first, second, or fourth etc) and "this is 
where my superblocks are" or whatever. Well that data is in its own 
small space that needs to be accounted for.

So the per-disk copy of the filesystem layout information (all the UUIDS 
of all the disks) and the per-disk copy of the disk specific information 
need to be somewhere, and they are naturally "single" since they are 
per-disk.

Compare to the LVM or MDADM signatures written to/about each element 
those systems control.

If those disappeared, or got stripped off onto other drives then 
not-amusing things would happen.

On 12/04/2014 06:25 AM, Shriramana Sharma wrote:
> On Thu, Dec 4, 2014 at 7:43 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> SuSE may have an old version of btrfs-progs then (which wouldn't surprise
>> me, it is an 'enterprise' distribution after all), because I haven't seen
>> this on anything since 3.16.
>
> Well OK I kinda like the "old" name SuSE since that was the name I was
> using back when I was on 9.3, but actually I'm running openSUSE
> Tumbleweed. See:
>
> $ btrfs --version
> Btrfs v3.17+20141103
>
> I suppose Tumbleweed should be short and clear enough for my future usage.
>
>> Also, for future reference, you can use the switch -mprofiles=single to just
>> balance out those chunks.
>
> Wow, thanks, that returned quickly. (Thankfully I did btrfs bal from a
> separate terminal can rather than ^C.)
>
> BTW I thought you had unintentionally (for brevity) omitted the
> -sprofiles=single and I gave it but it complained saying:
>
> Refusing to explicitly operate on system chunks.
> Pass --force if you really want to do that.
>
> So I did give --force. (Is it the same as -f?)
>
> I hope that was OK?
>

