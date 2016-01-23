Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c.mail.sonic.net ([64.142.111.80]:56861 "EHLO c.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbcAWXhh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 18:37:37 -0500
Subject: Re: "Some devices missing" only while not mounted
To: Chris Murphy <lists@colorremedies.com>
References: <56A13176.2050502@gmail.com>
 <CAJCQCtS3roJ84TNROAOwpyEFh_D85RcajAAOFkE5iURoKqVt4Q@mail.gmail.com>
 <56A15B6F.9070300@gmail.com>
 <CAJCQCtRSQTegThx+7P6tDTMDxx136XyuFXaZ5fC+90ASVV6Pow@mail.gmail.com>
 <56A19785.6090702@gmail.com>
 <CAJCQCtRb-9UJJwNvR5=X-OVhodrsCBmpSMBgm1CvNzr4mTHTRw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Konstantin Svist <fry.kun@gmail.com>
Message-ID: <56A40EBD.90900@gmail.com>
Date: Sat, 23 Jan 2016 15:37:33 -0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRb-9UJJwNvR5=X-OVhodrsCBmpSMBgm1CvNzr4mTHTRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2016 07:08 PM, Chris Murphy wrote:
> On Thu, Jan 21, 2016 at 7:44 PM, Konstantin Svist <fry.kun@gmail.com> wrote:
>
>> Wish the FS could be "edited" to remove the phantom device to make it work..
> Well that's why I'm saying it's a bug. If there's a missing device,
> 'btrfs dev del missing' should work. But there's no device missing for
> 'dev del' it's only missing for 'dev ready' which makes no sense.
>
> I suggest filing a bug, bugzilla.kernel.org. Something like 'bogus
> 'some devices missing' prevents boot. And then give examples in the
> summary:
>
> - mounts OK without degraded
> - btrfs check does not report missing devices
> - btrfs fi show does not report missing devices
> - btrfs fi show -d does report missing devices
> - btrfs dev del missing reports there are no missing devices
> - btrfs dev ready exit value 1, so boot always fails
>
> I don't know what debug info is useful for this case either. Maybe
> btrfs-image, btrfs-debug-tree output to a file maybe the chunk tree
> has a clue about this phantom missing device.
>
> And then once you file the bug, and post the URL here, go on the IRC
> channel tomorrow (business hours U.S. time) and reference it and ask
> what other information devs would want before you blow away the volume
> and start over. Because presumably you need to get back to work, and
> to do that at this point, baring a dev having an idea how to fix it,
> you'll need to blow it away.
>
> Make a backup while you can in the meantime.
>

I've made a dd copy of the problematic array, changed the UUID in the copy and whittled it down to 0 files (removed all subvolumes)
Made an image of the 0-file array by "btrfs-image -c9", now posted to the bug (https://bugzilla.kernel.org/show_bug.cgi?id=111161)

Need to know if that's enough to go on or more info is needed..
Also would like to know if it's worth waiting a day or two for someone to give me a way to fix the original "broken" array -- or better to
just copy all the files and start over, as mentioned above?


