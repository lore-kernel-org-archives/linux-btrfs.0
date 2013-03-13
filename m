Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:34271 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3CMK43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 06:56:29 -0400
Received: by mail-qa0-f42.google.com with SMTP id cr7so2121962qab.8
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 03:56:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
References: <201303131238.33692.russell@coker.com.au> <513FDE67.1050907@redhat.com>
 <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Wed, 13 Mar 2013 11:56:08 +0100
Message-ID: <CAGy7Uthf3P-4eefV-RbJQ=mW=OpjR3CXauPfCSbiv5eKMa5H8Q@mail.gmail.com>
Subject: Re: Debian 3.7.1 BTRFS crash
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 13, 2013 at 6:07 AM, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
> It seems the SSD has bad blocks now, BTRFS seems to abuse SSD disks, I
> burnt 1 SSD disk and 2 USB flash drive since I'm using BTRFS, in about
> 2 months for each.

USB flash drives are rubbish for any filesystem except FAT32 and then
still only gracefully accept large sequential writes. A few years ago
I thought it would be a good idea to put the root partition of a few
of my small Debian servers on USB flash, so that the harddisks could
spin down at night and I could easily prepare and switch a new
Debian-version. However, each and every USB stick got trashed within a
year, no matter which brand, size or product line and despite
specifically formatting them ext3 without a journal. I now use low-end
but recent series of SSD's and have had no such problems any more. I
don't use btrfs on them as yet, but ext4 even with a journal is doing
just fine.

Regards,

Bart
