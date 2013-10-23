Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52778 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3JWVYF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 17:24:05 -0400
Received: by mail-vc0-f181.google.com with SMTP id id10so901275vcb.26
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 14:24:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131004231948.0ee4e03c@datenkhaos.de>
References: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
	<20131004231948.0ee4e03c@datenkhaos.de>
Date: Wed, 23 Oct 2013 23:24:04 +0200
Message-ID: <CAD_cGvEtFnyVBoaEc13-gqX95Uv6njdEqji_PBS5iczQBYkGQg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: relocate csums properly with prealloc extents
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was hit by this when trying to rebalance a 16TB RAID10 to 32TB
RAID10 going from 4 to 8 WD SE 4TB drives today. I cannot finish a
rebalance because of failed csum.

[10228.850910] BTRFS info (device sdq): csum failed ino 487 off 65536
csum 2566472073 private 151366068
[10228.850967] BTRFS info (device sdq): csum failed ino 487 off 69632
csum 2566472073 private 3056924305
[10228.850973] BTRFS info (device sdq): csum failed ino 487 off 593920
csum 2566472073 private 906093395
[10228.851004] BTRFS info (device sdq): csum failed ino 487 off 73728
csum 2566472073 private 2680502892
[10228.851014] BTRFS info (device sdq): csum failed ino 487 off 598016
csum 2566472073 private 1940162924
[10228.851029] BTRFS info (device sdq): csum failed ino 487 off 77824
csum 2566472073 private 2939385278
[10228.851051] BTRFS info (device sdq): csum failed ino 487 off 602112
csum 2566472073 private 645310077
[10228.851055] BTRFS info (device sdq): csum failed ino 487 off 81920
csum 2566472073 private 3600741549
[10228.851078] BTRFS info (device sdq): csum failed ino 487 off 86016
csum 2566472073 private 200201951
[10228.851091] BTRFS info (device sdq): csum failed ino 487 off 606208
csum 2566472073 private 1002916440

The system is running a scrub now and I will return with some more
details later. I do not think systemd is logging to this volume, but
the scrub wil probably show which files are affected.

As this is a very serious issue for those hit by the corruption (it
basically makes it impossible to run rebalance with all its
consequences) hopefully this wil go upstream soon.
I am on Kernel 3.11.6 by the way.
Mvh

Hans-Kristian Bakke
Mob: 91 76 17 38


On 4 October 2013 23:19, Johannes Hirte <johannes.hirte@datenkhaos.de> wrote:
> On Fri, 27 Sep 2013 09:37:00 -0400
> Josef Bacik <jbacik@fusionio.com> wrote:
>
>> A user reported a problem where they were getting csum errors when
>> running a balance and running systemd's journal.  This is because
>> systemd is awesome and fallocate()'s its log space and writes into
>> it.  Unfortunately we assume that when we read in all the csums for
>> an extent that they are sequential starting at the bytenr we care
>> about.  This obviously isn't the case for prealloc extents, where we
>> could have written to the middle of the prealloc extent only, which
>> means the csum would be for the bytenr in the middle of our range and
>> not the front of our range.  Fix this by offsetting the new bytenr we
>> are logging to based on the original bytenr the csum was for.  With
>> this patch I no longer see the csum errors I was seeing.  Thanks,
>
> Any assessment when this goes upstream? Until it hit Linus tree it
> won't won't appear in stable. And this seems rather important.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
