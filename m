Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:58209 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbcDET1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 15:27:04 -0400
Received: by mail-vk0-f45.google.com with SMTP id k1so30864291vkb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 12:26:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57040A51.5060800@gmail.com>
References: <loom.20160330T155403-473@post.gmane.org>
	<20160330184327.GO29474@carfax.org.uk>
	<CAKWEGV5tsEJHmb_Y0aQD0fsc4v3Un4rWBzS5QUUGhFz2HyTGKg@mail.gmail.com>
	<570400A4.4090609@gmail.com>
	<CAKWEGV4TTbC4PW=VoxbRxFL0L4DrgrCVNaEca-xroHeQDQe4Rg@mail.gmail.com>
	<57040A51.5060800@gmail.com>
Date: Tue, 5 Apr 2016 12:26:58 -0700
Message-ID: <CAKWEGV7Yev9mcfDKdg6FpDXHDoyzEx6a-uOywQGZYOoXC+mc9g@mail.gmail.com>
Subject: Re: good documentation on btrfs internals and on disk layout
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-04-05 11:56 GMT-07:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> On 2016-04-05 14:36, Yauhen Kharuzhy wrote:
>>
>> 2016-04-05 11:15 GMT-07:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>>>
>>> On 2016-04-05 13:53, Yauhen Kharuzhy wrote:

>>> In general, it isn't allowed, but we don't explicitly disallow it either.
>>> The worst case here is that the devices both get written two separately,
>>> and
>>> you end up with data not matching for correlated generation ID's.  The
>>> second scrub in this case shows no errors because the first one corrects
>>> them (even though they are reported as uncorrectable, which is a bug as
>>> far
>>> as I can tell), and from what I can tell from reading the code, it does
>>> this
>>> by just picking the highest generation ID and dropping the data from the
>>> lower generation.
>>
>>
>> Hmm... Sounds reasonable but how to detect if filesystem should be
>> checked by scrub after mounting? There is one way as I understand — to
>> check kernel logs after mount for any btrfs errors and this is not a
>> good way for case of some kind of automatic management.
>
> There really isn't any way that I know of.  Personally, I just scrub all my
> filesystems shortly after mount, but I also have pretty small filesystems
> (the biggest are 64G) on relatively fast storage.  In theory, it might be
> possible to parse the filesystems before mounting to check the device
> generation numbers, but that may be just as expensive as just scrubbing the
> filesystem (and you really should be scrubbing somewhat regularly anyway).

Yes, size matters — we have 96TB massive and scrubbing, rebalancing,
replacing etc. can be expensive operations :)
In fact, I implemented some kind of filesystem status reporting in
kernel & btrfs progs already but still have no time to prepare this to
sending as patches for commenting. But it will be done soon, I hope.
