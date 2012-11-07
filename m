Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:56003 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2KGK3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2012 05:29:46 -0500
Message-ID: <509A3817.2030709@giantdisaster.de>
Date: Wed, 07 Nov 2012 11:29:43 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Hugo Mills <hugo@carfax.org.uk>, Bart Noordervliet <bart@noordervliet.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <CAGy7UtjR+kZoBYWaeg=-jHbJHQh4pe3Jt5cwX-rTQEBHFkQ-YQ@mail.gmail.com> <50995DAB.6070103@giantdisaster.de> <20121106192054.GC29581@carfax.org.uk> <20121106224836.GQ31248@lenny.home.zabbo.net>
In-Reply-To: <20121106224836.GQ31248@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 6 Nov 2012 14:48:36 -0800, Zach Brown wrote:
>>> Yes, this happens on 32 bit builds, not on 64 bit builds. If you
>>> look at the source code, the compiler is obviously wrong (or I am
>>> blind).
>>>
>>>         ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
>>>                                             args->start.srcdev_name,
>>>                                             &src_device);
>>>         mutex_unlock(&fs_info->volume_mutex);
>>>         if (ret) {  <-- this is line 344
>>>
>>> But thanks for the feedback anyway!
>>
>>    This usually means that somewhere in the call tree under
>> btrfs_dev_replace_find_srcdev(), there's a way that the function can
>> return without returning a value
> 
> Indeed, and that's obviously the case in 15/26 with
> btrfs_dev_replace_find_srcdev() when btrfs_find_device() returns a
> device.
> 
> *mumbles something about the reason for ERR_PTR semantics*

Thanks Bart, Hugo and Zach!
I'll fix it in
git://btrfs.giantdisaster.de/git/btrfs device-replace

