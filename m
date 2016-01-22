Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35462 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcAVDIq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 22:08:46 -0500
Received: by mail-ig0-f179.google.com with SMTP id t15so140477721igr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 19:08:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A19785.6090702@gmail.com>
References: <56A13176.2050502@gmail.com>
	<CAJCQCtS3roJ84TNROAOwpyEFh_D85RcajAAOFkE5iURoKqVt4Q@mail.gmail.com>
	<56A15B6F.9070300@gmail.com>
	<CAJCQCtRSQTegThx+7P6tDTMDxx136XyuFXaZ5fC+90ASVV6Pow@mail.gmail.com>
	<56A19785.6090702@gmail.com>
Date: Thu, 21 Jan 2016 20:08:45 -0700
Message-ID: <CAJCQCtRb-9UJJwNvR5=X-OVhodrsCBmpSMBgm1CvNzr4mTHTRw@mail.gmail.com>
Subject: Re: "Some devices missing" only while not mounted
From: Chris Murphy <lists@colorremedies.com>
To: Konstantin Svist <fry.kun@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 7:44 PM, Konstantin Svist <fry.kun@gmail.com> wrote:

>
> Wish the FS could be "edited" to remove the phantom device to make it work..

Well that's why I'm saying it's a bug. If there's a missing device,
'btrfs dev del missing' should work. But there's no device missing for
'dev del' it's only missing for 'dev ready' which makes no sense.

I suggest filing a bug, bugzilla.kernel.org. Something like 'bogus
'some devices missing' prevents boot. And then give examples in the
summary:

- mounts OK without degraded
- btrfs check does not report missing devices
- btrfs fi show does not report missing devices
- btrfs fi show -d does report missing devices
- btrfs dev del missing reports there are no missing devices
- btrfs dev ready exit value 1, so boot always fails

I don't know what debug info is useful for this case either. Maybe
btrfs-image, btrfs-debug-tree output to a file maybe the chunk tree
has a clue about this phantom missing device.

And then once you file the bug, and post the URL here, go on the IRC
channel tomorrow (business hours U.S. time) and reference it and ask
what other information devs would want before you blow away the volume
and start over. Because presumably you need to get back to work, and
to do that at this point, baring a dev having an idea how to fix it,
you'll need to blow it away.

Make a backup while you can in the meantime.


-- 
Chris Murphy
