Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34803 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbIIVdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 17:33:17 -0400
Received: by qgez77 with SMTP id z77so20252098qge.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 14:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150909222713.60d7d9de@natsu>
References: <CAE+qdJbDCaBpiw2JQdOVPk0qmR4NE3NZV+mF8-cXk2y697a3Hg@mail.gmail.com>
 <20150909171951.GQ23944@carfax.org.uk> <20150909222713.60d7d9de@natsu>
From: Jon Keane <jkeane@gmail.com>
Date: Wed, 9 Sep 2015 16:32:57 -0500
Message-ID: <CAE+qdJb2uoNcLb5413JyTg5WN6x4fDtY8x8Nb8Jt2E-gnc-Q4A@mail.gmail.com>
Subject: Re: Unmountable btrfs after power failure
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you all for the quick response! For anyone running into similar issues:

I updated my kernel, and then ran btrfs-zero-log. Everything worked
fine, and the drive is mountable with no issues so far.

-Jon


On Wed, Sep 9, 2015 at 12:27 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 9 Sep 2015 17:19:51 +0000
> Hugo Mills <hugo@carfax.org.uk> wrote:
>
>>    The bug you've hit is almost certainly fixed in more recent
>> kernels. I can't recommend stongly enough that you upgrade it (or
>> contact your vendor's support department to find out how they will
>> support your use of btrfs on a kernel that old). 3.19 is about the
>> earliest kernel I'd feel happy about using at this point.
>
> 3.19 is EOL and is not featured on https://www.kernel.org/ anymore.
>
> I hope 3.18 is also good enough, for those of us who prefer to stay on a
> "longterm" kernel and not jump every time onto a new series only to find out
> that it's in fact destined to go into the EOL trashcan. (There's a certain
> amount of tinkering with the .config required each time when switching
> releases, and I'd like to minimize that).
>
> --
> With respect,
> Roman
