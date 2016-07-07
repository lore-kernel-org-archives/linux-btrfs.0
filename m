Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34444 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbcGGQY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 12:24:59 -0400
Received: by mail-vk0-f50.google.com with SMTP id d67so26983626vkh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 09:24:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160707094621.GB7153@invalid>
References: <20160707094621.GB7153@invalid>
From: Henk Slager <eye1tm@gmail.com>
Date: Thu, 7 Jul 2016 18:24:26 +0200
Message-ID: <CAPmG0jYZ+MboSMn_CXwmZ_mSSOdQWSexCk4thXa+p4BozrVQwQ@mail.gmail.com>
Subject: Re: fstrim problem/bug
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 11:46 AM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
> Hello,
>
> On a filesystem with 40 G free space and 54 G used, ‘fstrim -v’ gave
> this result:
>
>     # fstrim -v /
>     /: 0 B (0 bytes) trimmed
>
> After running balance it gave a more sensible
>
>     # fstrim -v /
>     /: 37.3 GiB (40007368704 bytes) trimmed
>
> As far as I understand, fstrim should report any unused block to the
> disk, so its controller can reuse these blocks. I expected ’fstrim -v’
> to report about 40 G trimmed. The fact, that after balance fstrim
> reports a sensible amount of trimmed bytes leads to the conclusion,
> that fstrim on btrfs does not report unused blocks to the disk (as it
> should), but only the blocks of unused chunks. As the fstrim-command
> only does a ‘ioctl(fd, FITRIM, &range))’ this seems to be a bug in the
> fstrim kernel-code.
> In the field this means, that without regularly running balance,
> fstrim does not work on btrfs.

hmm, yes indeed I see this as well:

# btrfs fi us /
Overall:
   Device size:                  55.00GiB
   Device allocated:             46.55GiB
   Device unallocated:            8.45GiB
   Device missing:                  0.00B
   Used:                         39.64GiB
   Free (estimated):             13.96GiB      (min: 13.96GiB)
   Data ratio:                       1.00
   Metadata ratio:                   1.00
   Global reserve:              480.00MiB      (used: 0.00B)

Data,single: Size:43.77GiB, Used:38.25GiB
  /dev/sda1      43.77GiB

Metadata,single: Size:2.75GiB, Used:1.39GiB
  /dev/sda1       2.75GiB

System,single: Size:32.00MiB, Used:16.00KiB
  /dev/sda1      32.00MiB

Unallocated:
  /dev/sda1       8.45GiB
# fstrim -v /
/: 9,3 GiB (10014126080 bytes) trimmed
# fallocate -l 5G testfile
# fstrim -v /
/: 4,3 GiB (4644130816 bytes) trimmed

Where the difference between 8.45GiB and 9,3 GiB comes from, I
currently don't understand.
