Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42270 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKWxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:53:49 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm11so1523804wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 15:53:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=amr90tjbkd7H5_a4dC-UxrhEVhirmisZTLzViYqWO2T3w@mail.gmail.com>
References: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
	<CAFWF=amr90tjbkd7H5_a4dC-UxrhEVhirmisZTLzViYqWO2T3w@mail.gmail.com>
Date: Mon, 11 Mar 2013 23:53:47 +0100
Message-ID: <CAMQ-g0fHk3VQRS4GV6=1_fe3PfHnPT=eOpZi2hO7=d_tVYLnvA@mail.gmail.com>
Subject: Re: Unable to boot btrfs filesystem, and btrfsck aborts
From: Jan Steffens <jan.steffens@gmail.com>
To: Matthew Booth <matthew@heisenbug.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 11:49 PM, Harald Glatt <mail@hachre.de> wrote:
> On Mon, Mar 11, 2013 at 11:44 PM, Matthew Booth <matthew@heisenbug.com> wrote:
>> My laptop crashed hard earlier today. It reset immediately to a black
>> screen followed by the BIOS. I have no idea why.
>>
>> However, it now fails to boot. I took a picture of the kernel panic
>> that results from trying to mount the root filesystem:
>> https://plus.google.com/107763699965053810188/posts/QZZt7GYzBZi
>>
>> To make things worse, btrfsck aborts with a double free, without
>> fixing it. I took a picture of that, too:
>> https://plus.google.com/107763699965053810188/posts/gKYqGgFhWyT
>>
>> As the kernel panic mentions btrfs_remove_free_space, I also tried
>> mounting with clear_cache. Unfortunately it didn't dislodge anything.
>>
>> This is on a fully updated Fedora 18 system. I would really like to
>> get this data back. If anybody could offer a suggestion I'd be very
>> grateful.
> If you can make a complete image backup of the drive before trying any
> things to bring it back.
> Try mounting with -o nospace_cache, also try -o ro and -o recovery as
> well as -o recovery,ro.

I think the bug happens during log recovery, so btrfs-zero-log might
get it mountable again, with the caveat of losing the most recently
fsynced changes.
