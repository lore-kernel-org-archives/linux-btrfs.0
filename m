Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36160 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbIQSfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 14:35:42 -0400
Received: by vkfp126 with SMTP id p126so16363361vkf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 11:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FAFEB8.6030404@menke.ac>
References: <55F88ECC.1040604@menke.ac>
	<pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
	<55FAFEB8.6030404@menke.ac>
Date: Thu, 17 Sep 2015 12:35:41 -0600
Message-ID: <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Chris Murphy <lists@colorremedies.com>
To: Gert Menke <gert@menke.ac>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2015 at 11:56 AM, Gert Menke <gert@menke.ac> wrote:
> Hi,
>
> thank you for your answers!
>
> So it seems there are several suboptimal alternatives here...
>
> MD+LVM is very close to what I want, but md has no way to cope with silent
> data corruption. So if I'd want to use a guest filesystem that has no
> checksums either, I'm out of luck.

You can use Btrfs in the guest to get at least notification of SDC. If
you want recovery also then that's a bit more challenging. The way
this has been done up until ZFS and Btrfs is T10 DIF (PI). There are
already checksums on the drive, but this adds more checksums that can
be confirmed through the entire storage stack, not just internal to
the drive hardware.

Another way is to put a conventional fs image on e.g. GlusterFS with
checksumming enabled (and at least distributed+replicated filtering).

If you do this directly on Btrfs, maybe you can mitigate some of the
fragmentation issues with bcache or dmcache; and for persistent
snapshotting, use qcow2 to do it instead of Btrfs. You'd use Btrfs
snapshots to create a subvolume for doing backups of the images, and
then get rid of the Btrfs snapshot.


-- 
Chris Murphy
