Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:32851 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbbIQET7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 00:19:59 -0400
Received: by vkgd64 with SMTP id d64so3997696vkg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 21:19:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F88ECC.1040604@menke.ac>
References: <55F88ECC.1040604@menke.ac>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 17 Sep 2015 14:19:39 +1000
Message-ID: <CAB3_QuLRu70QhP6X+9ZUzTi2FKba__qThJ1uxKkuMRkk3UjEAQ@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
To: Gert Menke <gert@menke.ac>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As others have said here, it's probably not going to work for you
especially if you want to use regular scheduled btrfs snapshots on the
host (which I consider to be 50% of the reason why I use btrfs in the
first place).

Once I had learned this lesson the hard way, I had a xen server using
libvirt configured to provision from LVM storage. I had some
preseed/kickstart/ansible recipes for VM provisioning that configured
btrfs in the guests with appropriate scheduled snapshotting and remote
send/receive to backup hosts.

This worked well for me but it's not for everyone. I'm a btrfs fan,
but have talked a few admins out of naively using btrfs in the manner
that you've described. Particularly busy Windows HVM guests on a
file-backed image sitting on a btrfs host filesystem with regular
scheduled snapshots will deteriorate depressingly quickly.

Having said that, most of my current btrfs superstitions on this
use-case were formed around kernel 3.12, a long time ago now.

On 16 September 2015 at 07:34, Gert Menke <gert@menke.ac> wrote:
> Hi everybody,
>
> first off, I'm not 100% sure if this is the right place to ask, so if it's
> not, I apologize and I'd appreciate a pointer in the right direction.
>
> I want to build a virtualization server to replace my current home server.
> I'm thinking about a Debian system with libvirt/KVM. The system will have
> one or two SSDs and five harddisks with some kind of software RAID5 for
> storage. I'd like to have a filesystem with data checksums, so BTRFS seems
> like the right way to go. However, I read that BTRFS does not perform well
> as storage for KVM disk images.
> (See here: http://www.linux-kvm.org/page/Tuning_KVM )
>
> Is this still true?
>
> I would appreciate any comments and/or tips you might have on this topic.
>
> Is anyone using BTRFS as an image store? Are there any special settings I
> should be aware of to make it work well?
>
> Thanks,
> Gert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
