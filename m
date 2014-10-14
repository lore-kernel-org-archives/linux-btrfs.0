Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:62621 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbaJNBaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 21:30:15 -0400
Received: by mail-la0-f41.google.com with SMTP id pn19so7740614lab.28
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 18:30:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=QaPPNLYKePnhpaDuXqW3uqc4Y4nWjj5ca_ixCuU+uXA@mail.gmail.com>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
	<CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
	<CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
	<CAGfcS_=QaPPNLYKePnhpaDuXqW3uqc4Y4nWjj5ca_ixCuU+uXA@mail.gmail.com>
Date: Tue, 14 Oct 2014 03:30:13 +0200
Message-ID: <CANg_oxy2kTJJqXpq8B7h8DWFzcKHxQ2X6sU7Q5gek=oRD0EdJQ@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: john terragon <jterragon@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And another worrying thing I didn't notice before. Two snapshots have
dates that do not make sense. root-b3 and root-b4 have been created
Oct 14th (and btw root's modification time was also on Oct the 14th).
So why do they show Oct 10th? And root-prov has actually been created
on Oct 10 15:37, as it correctly shows, so it's like btrfs sub snap
picks up old stale data from who knows were or when or for what
reason. Moreover, root-b4 was created with 3.16.5....not good.

drwxrwsr-x 1 root staff  30 Sep 11 16:15 home
d????????? ? ?    ?       ?            ? home-backup
drwxr-xr-x 1 root root  250 Oct 14 03:02 root
d????????? ? ?    ?       ?            ? root-b2
drwxr-xr-x 1 root root  250 Oct 10 15:37 root-b3
drwxr-xr-x 1 root root  250 Oct 10 15:37 root-b4
drwxr-xr-x 1 root root  250 Oct 14 03:02 root-b5
drwxr-xr-x 1 root root  250 Oct 14 03:02 root-b6
d????????? ? ?    ?       ?            ? root-backup
drwxr-xr-x 1 root root  250 Oct 10 15:37 root-prov
drwxr-xr-x 1 root root   88 Sep 15 16:02 vms

On Tue, Oct 14, 2014 at 1:18 AM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Mon, Oct 13, 2014 at 5:22 PM, john terragon <jterragon@gmail.com> wrote:
>> I'm using "compress=no" so compression doesn't seem to be related, at
>> least in my case. Just read-only snapshots on 3.17 (although I haven't
>> tried 3.16).
>
> I was using lzo compression, and hence my comment about turning it off
> before going back to 3.16 (not realizing that 3.16 has subsequently
> been fixed).
>
> Ironically enough I discovered this as I was about to migrate my ext4
> backup drive into my btrfs raid1.  Maybe I'll go ahead and wait on
> that and have an rsync backup of the filesystem handy (minus
> snapshots) just in case.  :)
>
> I'd switch to 3.16, but it sounds like there is no way to remove the
> snapshots at the moment, and I can live for a while without the
> ability to create new ones.
>
> interestingly enough it doesn't look like ALL snapshots are affected.
> I checked and some of the snapshots I made last weekend while doing
> system updates look accessible.  They are significantly smaller, and
> the subvolumes they were made from are also fairly new - though I have
> no idea if that is related.
>
> The subvolumes do show up in btrfs su list.  They cannot be examined
> using btrfs su show.
>
> It would be VERY nice to have a way of cleaning this up without
> blowing away the entire filesystem...
>
> --
> Rich
