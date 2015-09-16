Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33667 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbIPDAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 23:00:42 -0400
Received: by vkgd64 with SMTP id d64so92903169vkg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 20:00:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F88ECC.1040604@menke.ac>
References: <55F88ECC.1040604@menke.ac>
Date: Tue, 15 Sep 2015 21:00:41 -0600
Message-ID: <CAJCQCtR-_=YEWNNZmVTjnv67toWrR-Lz4yH3xvJidA4nfV4wXg@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Chris Murphy <lists@colorremedies.com>
To: Gert Menke <gert@menke.ac>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you don't need image portability use an LVM logical volume for
backing of the VM. That LV gets partitioned as if it were a disk, and
you can use Btrfs for root home data or whatever.

If you need image portability, e.g. qcow2, then I'd put it on ext4 or
XFS, and you can use Btrfs within the VM for data integrity.

If you put the qcow2 on Btrfs, you're advised (by FAQ and many threads
on this topic in the list archives) to set the the image file with
chattr +C, which is nocow and implies nodatasum, so no checksumming.
And also I've run into this problem depending on the qemu cache
setting.

https://www.marc.info/?l=linux-btrfs&m=142714523110528&w=1
https://bugzilla.redhat.com/show_bug.cgi?id=1204569


-- 
Chris Murphy
