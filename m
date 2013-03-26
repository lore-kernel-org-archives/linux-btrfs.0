Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52096 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955Ab3CZQAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 12:00:19 -0400
Received: by mail-ie0-f171.google.com with SMTP id e14so7306245iej.30
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 09:00:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130326144855.GM1955@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
 <20130326144855.GM1955@localhost.localdomain>
From: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Date: Tue, 26 Mar 2013 15:59:57 +0000
Message-ID: <CAAr69zbBXr_c1_xroqueHG0Zobo8H94a2p6kB+GTsZVfkFCtGg@mail.gmail.com>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error was just a silly "permission denied" one.

I uploaded the created image to www.morrohun.hu/temp/btrfs/btrfs.img
SHA1: 90ee61e0724700495d26678d58dc229e04a04cc4
Please, write me when you downloaded and I'll delete it.

I have the idea to run btrfsck from your tree on the file system
again, but I won't touch the fs until you said so :).

Ákos
