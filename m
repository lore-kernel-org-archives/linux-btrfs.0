Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36674 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbcEEBHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 21:07:38 -0400
Received: by mail-oi0-f44.google.com with SMTP id x201so86577069oif.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 18:07:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
Date: Wed, 4 May 2016 19:07:37 -0600
Message-ID: <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2016 at 5:21 PM, Niccolò Belli <darkbasic@linuxsystems.it> wrote:

> rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,subvolid=257,subvol=/@

I suggest using defaults for starters. The only thing in that list
that needs be there is either subvolid or subvold, not both. Add in
the non-default options once you've proven the defaults are working,
and add them one at a time.



> I have the whole rootfs encrypted, including boot. I followed these steps:
> https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Btrfs_subvolumes_with_swap
>
> Disk is a SAMSUNG SSD PM851 M.2 2280 256GB (Firmware Version: EXT25D0Q).

The firmware is old if I understand the naming scheme used by Dell. It
says EXT49D0Q is current.

http://www.dell.com/support/home/al/en/aldhs1/Drivers/DriversDetails?driverId=0NXHH

If you need to update, you may be best off doing a whole device trim,
which is easiest done with mkfs.btrfs pointed at the whole device. I
wouldn't trust any data on the drive after a firmware update so I'd
start over entirely from scratch, new partition map, new everything.
So the way to do this is:

mkfs.btrfs /dev/sda
wipefs -a /dev/sda

That way the btrfs magic is removed, and now you can partition it,
setup dmcrypt, etc. I advice using all defaults for everything for
now, otherwise it's anyone's guess what you're running into.


Off topic, but at least gmail users see your posts go to spam because
your domain is configured to disallow relaying. Most mail services
ignore this request by the domain but google honors it so no amount of
training will make your email not spam. This is what's in your emails
that's causing the problem:

       dmarc=fail (p=QUARANTINE dis=NONE) header.from=linuxsystems.it

http://webmasters.stackexchange.com/questions/76765/sent-emails-pass-spf-and-dkim-but-fail-dmarc-when-received-by-gmail
http://www.pcworld.com/article/2141120/yahoo-email-antispoofing-policy-breaks-mailing-lists.html



-- 
Chris Murphy
