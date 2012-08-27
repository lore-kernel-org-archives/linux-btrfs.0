Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45691 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2H0AKv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Aug 2012 20:10:51 -0400
Received: by vbbff1 with SMTP id ff1so3778083vbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Aug 2012 17:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503AA1BD.3030506@harwarth.de>
References: <5037E470.9070508@harwarth.de>
	<CAE5mzvg_-JwiTyJXU0q3swzGtez9Sxt=Zu0TtSRKgmyRqyQqDA@mail.gmail.com>
	<503AA1BD.3030506@harwarth.de>
Date: Sun, 26 Aug 2012 18:10:50 -0600
Message-ID: <CAE5mzviGtqpBicsCFWDsDhjYZ6sGW5=-7a5dPr9LQd1XmgtW6w@mail.gmail.com>
Subject: Re: Unable to mount/restore partition after eSATA fail
From: cwillu <cwillu@cwillu.com>
To: Stefan Harwarth <mailingliste@harwarth.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 26, 2012 at 4:22 PM, Stefan Harwarth
<mailingliste@harwarth.de> wrote:
> Hi cwillu,
>
> thanks for the quick reply. I didn't realize that my debian 6 was shipping
> such an old btrfs/kernel package - though I should have known better :(
>
> Anyways I already tried to recover my files with an Ubuntu 12.04 (Kernel
> 3.2) and following your recommendation, I upgraded to 3.5 and tried btrfsck,
> btrfs-restore and btrfs-find-root on /dev/sdb as well as the partition
> /dev/sdb1 but I only got "no btrfs filesystem" and "could not open root,
> trying backup super" (for btrfs-restore).
>
> I haven't tried -o recovery yet, but it looks to me like there's no starting
> point at all for the tools (which brings me back to the 6.4meg of NULL-bytes
> at the start of the partition).
>
> So is there any chance on recovering FS information, from what I read in
> wikipedia btrfs stores some copies of important FS metadata throughout the
> partition.


-o recovery will try the various copies of the superblock; hopefully
you haven't used "btrfs-select-super" at any point, as it works by
overwriting those copies with the selected one (i.e., you get one
shot).

I believe btrfs doesn't write to the first couple mb of the partition,
so the existence of gibberish or empty bytes there doesn't indicate a
problem; more worrisome is that it isn't actually being detected as
btrfs.  Can you describe the setup (partitions in the filesystem, etc)
a bit more, and possibly include a dmesg from after an attempt to
mount it under 3.5?
