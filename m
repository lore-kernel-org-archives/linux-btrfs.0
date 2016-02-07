Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:51765 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbcBGN1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 08:27:10 -0500
Subject: Re: Fi corruption on RAID1, generation doesn't match
To: a.t.hild@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56B7462B.8060403@bouton.name>
Date: Sun, 7 Feb 2016 14:27:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 07/02/2016 14:15, Andreas Hild a écrit :
> Dear All,
>
> The file system on a RAID1 Debian server seems corrupted in a major
> way, with 99% of the files not found. This was the result of a
> precarious shutdown after a crash that was preceded by an accidental
> misconfiguration in /etc/fstab; it pointed "/" and "/tmp" to one and
> the same UUID by omitting a subvol entry.
>
> Is there any way to repair or recover a substantial part of this RAID?

I don't think the RAID is damaged: most distributions including Debian
remove nearly all files from /tmp at boot.
If /tmp and / were as you described the same filesystem your server most
probably did what amounts to "rm -rf /". You would probably have got the
same result with any filesystem as mounting the same filesystem at
several points in the VFS is not BTRFS-specific.

Unless you can restore a snapshot or there is a way to debug the
filesystem to restore a previous state, I'm afraid there's nothing to be
done.

Best regards,

Lionel
