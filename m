Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32981 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbCVRth (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Mar 2015 13:49:37 -0400
Received: by wixw10 with SMTP id w10so21993350wix.0
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2015 10:49:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150322173849.GG31762@carfax.org.uk>
References: <CAAkAgPhF5GF5tq0Pck-dju-m7qf62LV8FobUHS2z6ibMwwUn2g@mail.gmail.com>
	<20150322173849.GG31762@carfax.org.uk>
Date: Sun, 22 Mar 2015 17:49:36 +0000
Message-ID: <CAAkAgPimbFpwkEpvtZg+GcCYveUAmGRRNNh3Nkr_B2i4fALxbg@mail.gmail.com>
Subject: Re: btrfs fstrim status (RAID5)
From: scruffters <scruffters@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, scruffters <scruffters@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks hugo!

Supposing I moved to a later kernel, what would the situation be
regarding fstrim and btrfs R5?

In the long run this feature looks very exciting for building SSD
storage pools in the linux space.

On Sun, Mar 22, 2015 at 5:38 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Mar 22, 2015 at 05:30:59PM +0000, scruffters wrote:
>> Hello list,
>>
>> I wondered if anybody could advise on the status of using fstrim with
>> BTRFS. The motivation for me is to finally try using SSD's in a R5
>> style configuration with some way of running maintenance overnight to
>> maintain performance...
> [snip]
>> My kernel is 3.2.0-4 (Debian Wheezy).
>
>    Then you shouldn't use btrfs RAID-5 at all, and probably shouldn't
> be using btrfs.
>
>    For parity RAID, 3.19 or later is what you should be using, as it
> supports recovery and rebuild. You can get those kernels from the
> Debian experimental repo. If you're not using parity RAID, then the
> last few kernels have been OK, but keeping up with the latest version
> is still a reasonably good idea.
>
>    Hugo.
>
> --
> Hugo Mills             | "You know, the British have always been nice to mad
> hugo@... carfax.org.uk | people."
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |                         Laura Jesson, Brief Encounter
