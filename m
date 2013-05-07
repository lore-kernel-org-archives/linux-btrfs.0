Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56068 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3EGVfw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 17:35:52 -0400
Received: by mail-wi0-f177.google.com with SMTP id hq12so1183398wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 14:35:50 -0700 (PDT)
Message-ID: <518973B2.4070308@gmail.com>
Date: Tue, 07 May 2013 23:35:46 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC 0/5] BTRFS hot relocation support
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> How will it compare to bcache? I'm currently thinking about buying an SSD 
>> but bcache requires some efforts in migrating the storage to use. And after 
>> all those hassles I am even not sure if it would work easily with a dracut 
>> generated initramfs.

>   On the side note: dm-cache, which is already in-kernel, do not need to
> reformat backing storage.

On the other hand dm-cache is somewhat complex to assemble, and letting
the system automount the unsynchronised backing device is a recipe for
data loss.

It will need lvm integration to become really convenient to use.

Anyway, here's a shameless plug for a tool that converts to bcache
in-place:  https://github.com/g2p/blocks#bcache-conversion

