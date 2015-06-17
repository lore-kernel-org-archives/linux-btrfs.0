Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36620 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbFQOWm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 10:22:42 -0400
Received: by ykdr198 with SMTP id r198so41164968ykd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 07:22:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55816E7B.5040905@gmail.com>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
Date: Wed, 17 Jun 2015 08:22:41 -0600
Message-ID: <CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
From: Chris Murphy <lists@colorremedies.com>
To: Christian Dysthe <cdysthe@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 6:56 AM, Christian Dysthe <cdysthe@gmail.com> wrote:
> Hi,
>
> Sorry for asking more about this. I'm not a developer but trying to learn.
> In my case I get several errors like this one:
>
> root 2625 inode 353819 errors 400, nbytes wrong
>
> Is it inode 353819 I should focus on and what is the number after "root", in
> this case 2625?

I'm going to guess it's tree root 2625, which is the same thing as fs
tree, which is the same thing as subvolume. Each subvolume has its own
inodes. So on a given Btrfs volume, an inode number can exist more
than once, but in separate subvolumes. When you use btrfs inspect
inode it will list all files with that inode number, but only the one
in subvol ID 2625 is what you care about deleting and replacing.

-- 
Chris Murphy
