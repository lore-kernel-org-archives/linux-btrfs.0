Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33745 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbbGPX35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 19:29:57 -0400
Received: by ykeo3 with SMTP id o3so76883164yke.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2015 16:29:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150716075917.GT10539@carfax.org.uk>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
 <CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
 <CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com> <20150716075917.GT10539@carfax.org.uk>
From: Paul Harvey <csirac2@gmail.com>
Date: Fri, 17 Jul 2015 09:29:37 +1000
Message-ID: <CAB3_QuL8eQ82NisTFDrDRUrmfCehN3BjjGVRr8GMUVcJHpx0xQ@mail.gmail.com>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 July 2015 at 17:59, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jul 16, 2015 at 01:12:03PM +1000, Paul Harvey wrote:
>> I for one would love to see authoritative documentation on "proper"
>> subvolume organization. I was completely lost when writing snazzer and
>> have so far received very little guidance or even offers of opinions
>> on this ML.
>
>    Advice on this point has been on the btrfs wiki for several years,
> at:
>
> https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_snapshots
>
>    Hugo.

Which is great, and I've consulted it in the past. But nested
subvolumes aren't exactly discouraged there (in fact, they're not
mentioned in that section at all).

In fact, re-reading it, I'm not even sure that using nested subvolumes
is incompatible with that advice.

What I'm proposing is more thorough and assertive documentation that
matches the wisdom handed out on this list.

--
Paul
