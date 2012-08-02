Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51347 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2HBXM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 19:12:28 -0400
Received: by ggnl2 with SMTP id l2so107723ggn.19
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 16:12:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120802221644.GS17430@twin.jikos.cz>
References: <20120802221644.GS17430@twin.jikos.cz>
Date: Fri, 3 Aug 2012 01:12:27 +0200
Message-ID: <CAB9VWqA59cF7TbqyWowv032tR7xoPJb8kh6ajLqm0WH_tpHdBw@mail.gmail.com>
Subject: Re: [current linus/master] deadlock during snapshot, sb_writers
From: Alexander Block <ablock84@googlemail.com>
To: dave@jikos.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 3, 2012 at 12:16 AM, David Sterba <dave@jikos.cz> wrote:
> Hi,
>
> top commit (v3.5-9237) fc6bdb59a501740b28ed3b616641a22c8dc5dd31, observed with
> btrfs-next/master as well.
>
> mount:
> /dev/sdb on /mnt/sdb type btrfs (rw,relatime,space_cache)
>
> fresh mkfs, snapshot stresstest, stuck on first snapshot call afaics
>
The problem seems to be a merge error. Commit a874a63 removed the
mnt_want_write call from btrfs_mksubvol and added a replacement call
to mnt_want_write_file in btrfs_ioctl_snap_create_transid. Commit
e7848683 however tried to move all calls to mnt_want_write above
i_mutex. So somewhere while merging this, it got mixed up. The
solution is to remove the mnt_want_write call completely from
mksubvol. Will send a patch in a few minutes.
[...]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
