Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:36090 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbGPDMX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 23:12:23 -0400
Received: by ykay190 with SMTP id y190so53878117yka.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 20:12:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com> <CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 16 Jul 2015 13:12:03 +1000
Message-ID: <CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
To: Chris Murphy <lists@colorremedies.com>
Cc: Johannes Ernst <johannes.ernst@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 July 2015 at 11:35, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Jul 15, 2015 at 6:11 PM, Johannes Ernst
> <johannes.ernst@gmail.com> wrote:
>
>> Cleaning this all up is a bit of pain, and
>>         btrfs subvolume delete -r dir
>> would solve it nicely.

[snip]

> How is all of this backed up properly? How is it restored properly? I
> think recursive snapshotting and subvolume deletion is not a good
> idea. I think it's a complicated and inelegant work around for
> improper subvolume organization.

I for one would love to see authoritative documentation on "proper"
subvolume organization. I was completely lost when writing snazzer and
have so far received very little guidance or even offers of opinions
on this ML.

I've had to create my own logic in my scripts that automatically walk
all subvolumes on all filesystems for the simple reason that
explicitly enumerating it all for dozens of servers becomes a
significant administration burden.

I have different retention needs for /var (particularly /var/cache)
than I do for /home, for example, so carving up my snapshots so that I
can easily drop them from those parts of my filesystems which have a
high churn rate (= more unique extents, occupying a lot of disk) and
yet aren't as important (I need to retain fewer of them) is very
useful.
