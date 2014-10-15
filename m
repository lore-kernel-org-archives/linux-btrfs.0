Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:38460 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJOWmt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 18:42:49 -0400
MIME-Version: 1.0
In-Reply-To: <1413407515.18175.0@mail.thefacebook.com>
References: <1413398246-17324-1-git-send-email-fdmanana@suse.com>
	<1413407515.18175.0@mail.thefacebook.com>
Date: Thu, 16 Oct 2014 00:42:47 +0200
Message-ID: <CANg_oxx6u3Bk5XHeTYxUHa3t9gnE4J_TWnPyzFCa0aaONxR-6g@mail.gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: race free update of commit root for ro snapshots"
From: john terragon <jterragon@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Filipe Manana <fdmanana@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I applied the patch to 3.17.1 but although I haven't seen any
corrupted ro snapshot yet it's still impossible to do btrfs send. As
soon as I start btrfs send I still get

ERROR: send ioctl failed with -12: Cannot allocate memory

even if I redirect btrfs send's output to a file (instead of involving
btrfs receive)

Maybe this time it's actually a btrfs-progs bug?

Thanks
John
