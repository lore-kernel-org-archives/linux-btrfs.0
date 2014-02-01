Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41304 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaBAKFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 05:05:17 -0500
Received: by mail-ob0-f172.google.com with SMTP id vb8so6126947obc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 02:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140130215634.GB8796@birch.djwong.org>
References: <1389475651-19179-1-git-send-email-fdmanana@gmail.com>
	<1389493366-15264-1-git-send-email-fdmanana@gmail.com>
	<20140130031135.GA8796@birch.djwong.org>
	<CAL3q7H7fT9Mz6m=a2iqHgSyGgYO28aRt_BFc95gQYOh4gaRA2A@mail.gmail.com>
	<20140130215634.GB8796@birch.djwong.org>
Date: Sat, 1 Feb 2014 11:05:16 +0100
Message-ID: <CAFDW0jJ__9EbidepKD1uF239H3ZDMvZszw_f_Nsem9iuX4Rv-w@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is still a problem when btrfs is built-in:

err = btrfs_hash_init();

Will not succeed if run on an slow cpu (intel u7300) or in qemu if
btrfs is built-in:

# qemu-kvm -enable-kvm -usbdevice tablet -m 2048 -smp 2 -sdl -kernel
/usr/src/linux/arch/x86/boot/bzImage

But it works, when btrfs is a module.

I really do not want to go back using modules in my initramfs ..

There must be a way to move init_btrfs_fs to the end of Linux built-in
initializations ..

Ahmet
