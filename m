Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43980 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab2EXV2n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 17:28:43 -0400
Received: by qadb17 with SMTP id b17so4488757qad.19
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2012 14:28:43 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 May 2012 23:28:42 +0200
Message-ID: <CAG-aW05GkhWBC+ee_6iu8uRDnTQYZCCkB1+oz3bU64=1CjV4jA@mail.gmail.com>
Subject: Btrfs and more compression algorithms
From: Matt <jackdachef@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris, Hi Josef,

Hi Btrfs-List and all other Btrfs-devs that I've forgot,


is there a chance we'll see a xz file-compression support in Btrfs
anytime soon ?

I'm sure folks have been waiting for additional compression support
besides gzip and lzo (bzip2 seems out of question due to its slowness,
there's pbzip2 but that's not included in the kernel).

This would be a really nice bonus due to the processors getting faster
and SSD usage is more and more widespread - add an efficient
implementation and

we would have a fast, extremely efficient and feature-rich filesystem.

My current situation is that several of my harddrives are almost
completely full - even with forced gzip-compression - so I thought I'd
asked whether there was any change in the near future ahead.
There's fusecompress but that probably wouldn't end up being as stable
as a btrfs with xz/lzma-support.


Thanks for your consideration and your work on Btrfs !

It got significantly more stable compared to the past :)

(I use it mainly for some small backup hdds;

a troublesome usage however is still suspending-to-ram/to-disk
regularly and with that the partition [I have a dedicated partition
for the portage-tarball of Gentoo Linux]
where the filesystem seems to take some damage where it can't be
written to anymore via rsync (or other programs). The bash session
hangs (and nothing gets written to the partition).
Running scrub revealed no issues. I haven't had a chance to test it
yet with the new btrfs-progs - haven't suspended meanwhile)


Kind Regards

Matt
