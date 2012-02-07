From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Understanding Default RAID Behavior
Date: Tue, 07 Feb 2012 08:25:10 +0100
Message-ID: <o70709-9m4.ln1@hurikhan.ath.cx>
References: <4F30AF89.4090402@techsym.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mario Lopez <mario.lopez@techsym.com> schrieb:

> The Wiki does not make it clear as to why adding a secondary device
> defaults to RAID1 metadata and RAID0 data. I bought two SSDs with the
> intention of doing a BTRFS RAID0 for my root.
> 
> What is the difference between forcing RAID0 on metadata and data as
> opposed to the default behavior? Can anyone clarify that?

I think the purpose is that on meta data corruption (which can happen and is 
probably more important than file data) the file system can "heal" itself by 
replacing a corrupted meta data block with an intact copy. Also during 
scrubbing btrfs will check all those blocks and magically fix broken ones.

HTH
Kai

