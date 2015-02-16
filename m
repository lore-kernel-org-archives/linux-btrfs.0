Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:36164 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbBPF3k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 00:29:40 -0500
Received: by mail-yh0-f49.google.com with SMTP id f10so12786028yha.8
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 21:29:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$61fb6$e370d823$43b0d70$79a222c6@cox.net>
References: <loom.20150214T001556-40@post.gmane.org>
	<CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com>
	<pan$61fb6$e370d823$43b0d70$79a222c6@cox.net>
Date: Sun, 15 Feb 2015 22:29:39 -0700
Message-ID: <CAJCQCtR182dNMQoXHtJH5ncSNs3Go_sfRKagPWyPbecyNFU_yQ@mail.gmail.com>
Subject: Re: btrfs raid-1 uuid-fstab
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 14, 2015 at 11:28 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Sat, 14 Feb 2015 04:52:12 -0700 as excerpted:

>> Also, there's a nasty
>> little gotcha, there is no equivalent for mdadm bitmap. So once one
>> member drive is mounted degraded+rw, it's changed, and there's no way to
>> "catch up" the other drive - if you reconnect, it might seem things are
>> OK but there's a good chance of corruption in such a case. You have to
>> make sure you wipe the "lost" drive (the older version one). wipefs -a
>> should be sufficient, then use 'device add' and 'device delete missing'
>> to rebuild it.
>
> I caught this in my initial btrfs experimentation, before I set it up
> permanently.  It's worth repeating for emphasis, with a bit more
> information as well.
>
> *** If you break up a btrfs raid1 and attempt to recombine afterward, be
> *SURE* you *ONLY* mount the one side writable after that.  As long as
> ONLY one side is written to, that one side will consistently have a later
> generation than the device that was dropped out, and you can add the
> dropped device back in,

Right. I left out the distinguishing factor in whether or not it
corrupts. I'm uncertain how bad this corruption is, I've never tried
reproducing it.



-- 
Chris Murphy
