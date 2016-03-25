Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36597 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbcCYOfy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:35:54 -0400
Received: by mail-lf0-f43.google.com with SMTP id d82so56148190lfe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:35:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
	<CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
	<CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
Date: Fri, 25 Mar 2016 15:35:52 +0100
Message-ID: <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Henk Slager <eye1tm@gmail.com>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Brad Templeton <bradtem@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 2:16 PM, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:
> On 23 March 2016 at 20:33, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com> wrote:
>> >
>> > I am surprised to hear it said that having the mixed sizes is an odd
>> > case.
>>
>> Not odd as in wrong, just uncommon compared to other arrangements being tested.
>
> I think mixed drive sizes in raid1 is a killer feature for a home NAS,
> where you replace an old smaller drive with the latest and largest
> when you need more storage.
>
> My raid1 currently consists of 6TB+3TB+3*2TB.

For the original OP situation, with chunks all filled op with extents
and devices all filled up with chunks, 'integrating' a new 6TB drive
in an 4TB+3TG+2TB raid1 array could probably be done in a bit unusual
way in order to avoid immediate balancing needs:
- 'plug-in' the 6TB
- btrfs-replace  4TB by 6TB
- btrfs fi resize max 6TB_devID
- btrfs-replace  2TB by 4TB
- btrfs fi resize max 4TB_devID
- 'unplug' the 2TB

So then there would be 2 devices with roughly 2TB space available, so
good for continued btrfs raid1 writes.

An offline variant with dd instead of btrfs-replace could also be done
(I used to do that sometimes when btrfs-replace was not implemented).
My experience is that btrfs-replace speed is roughly at max speed (so
harddisk magnetic media transferspeed) during the whole replace
process and it does in a more direct way what you actually want. So in
total mostly way faster device replace/upgrade than with the
add+delete method. And raid1 redundancy is active all the time. Of
course it means first make sure the system runs up-to-date/latest
kernel+tools.
