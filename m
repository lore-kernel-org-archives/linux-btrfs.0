Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f42.google.com ([209.85.216.42]:32810 "EHLO
	mail-vn0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbbGQA1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 20:27:19 -0400
Received: by vnbf7 with SMTP id f7so9835895vnb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2015 17:27:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3_QuLKXHB6kK1SKLgR_nOVJ6hss1+HRNSawZTPosYMQgfMVw@mail.gmail.com>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
	<CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
	<CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com>
	<20150716075917.GT10539@carfax.org.uk>
	<CAB3_QuLKXHB6kK1SKLgR_nOVJ6hss1+HRNSawZTPosYMQgfMVw@mail.gmail.com>
Date: Thu, 16 Jul 2015 18:27:18 -0600
Message-ID: <CAJCQCtRUbM0s+G=O34VapHTh2V19bpxLJ2pKGOd+vCf3EQ2p5Q@mail.gmail.com>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
From: Chris Murphy <lists@colorremedies.com>
To: Paul Harvey <csirac2@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Johannes Ernst <johannes.ernst@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 16, 2015 at 4:06 AM, Paul Harvey <csirac2@gmail.com> wrote:
> On Thu, 16 Jul 2015 17:59 Hugo Mills <hugo@carfax.org.uk> wrote:
>
>
>>
>> On Thu, Jul 16, 2015 at 01:12:03PM +1000, Paul Harvey wrote:
>> > On 16 July 2015 at 11:35, Chris Murphy <lists@colorremedies.com> wrote:
>> > > On Wed, Jul 15, 2015 at 6:11 PM, Johannes Ernst
>> > > <johannes.ernst@gmail.com> wrote:
>> > >
>> > >> Cleaning this all up is a bit of pain, and
>> > >>         btrfs subvolume delete -r dir
>> > >> would solve it nicely.
>> >
>> > [snip]
>> >
>> > > How is all of this backed up properly? How is it restored properly? I
>> > > think recursive snapshotting and subvolume deletion is not a good
>> > > idea. I think it's a complicated and inelegant work around for
>> > > improper subvolume organization.
>> >
>> > I for one would love to see authoritative documentation on "proper"
>> > subvolume organization. I was completely lost when writing snazzer and
>> > have so far received very little guidance or even offers of opinions
>> > on this ML.
>>
>>    Advice on this point has been on the btrfs wiki for several years,
>> at:
>>
>> https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_snapshots
>
> Which is great, and I've consulted it in the past. But nested subvolumes
> aren't exactly discouraged there (in fact, they're not mentioned in that
> section at all).
>
> In fact, re-reading it, I'm not even sure that using nested subvolumes is
> incompatible with that advice.

It's not so much an incompatibility problem as we start seeing
consequences that rapidly approach pathological behavior. There's no
solution yet for snapshot aware defrag for example, and there are
still performance problems that happen with many snapshots. So making
it easy to exponentially create many snapshots, with a recursive
snapshot option, seems premature.

For the original poster, machinectl has already implemented a
recursive removal of subvolumes.
http://lists.freedesktop.org/archives/systemd-devel/2015-April/031026.html
http://lists.freedesktop.org/archives/systemd-devel/2015-April/030297.html


-- 
Chris Murphy
