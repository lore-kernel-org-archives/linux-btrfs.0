Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58632 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2L2JoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 04:44:10 -0500
Received: by mail-qa0-f48.google.com with SMTP id l8so7217837qaq.14
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2012 01:44:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212291604.52597.russell+btrfs@coker.com.au>
References: <201212291604.52597.russell+btrfs@coker.com.au>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Sat, 29 Dec 2012 10:36:15 +0100
Message-ID: <CAGy7Utj=HpO-EetPJQzAkiXKWg8XvWE2mB6s8kRGJ9nBR34OKw@mail.gmail.com>
Subject: Re: determining filesystem mount points
To: russell+btrfs@coker.com.au
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Russell,

all of the information you need should be available from the 'mount'
and 'btrfs subvol list' commands. Though I realise it can be awkward
to parse it out of there, this will be the only way to get accurate
information in the face of bind-mounts and other fancy tricks. One
other datapoint that you might be able to use is that btrfs, I
believe, always shows inode number 256 for subvolumes in 'stat'. Keep
in mind there that the root subvolume is, as the name implies, also
technically a subvolume.

Regards, Bart

On Sat, Dec 29, 2012 at 6:04 AM, Russell Coker
<russell+btrfs@coker.com.au> wrote:
> What's a good way of determining the mount point for a BTRFS filesystem in a
> shell script?
>
> /home/user might be a filesystem, a directory under a filesystem /home, a
> directory under a subvol /home of /, a subvol of /, or a subvol of the /home
> filesystem.  How do I determine which it is?
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
