From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 06 Aug 2009 10:53:24 +0200
Message-ID: <4A7A9A04.5010006@redpill-linpro.com>
References: <4A7A7F9F.1080809@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7A7F9F.1080809@redpill-linpro.com>
List-ID: <linux-btrfs.vger.kernel.org>

* Tore Anderson

> I have btrfs on my root filesystem and at the time of the crash I
> taring together some files from a NFS filesystem onto it.  There was
> plenty of free space on the btrfs filesystem.

Some more info - the file system is acting really strange after a
reboot.  A lot of messages like these are printed to /var/log/messages:

no space left, need 4096, 0 delalloc bytes, 16577376256 bytes_used, 0
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 69816320 may
use16647192576 total

Many commands gives the error message "no space left on device".
Curiously enough /var/log/messages is stored on the very same file
system, and new lines appears in it, so it appears those writes are
avoiding the ENOSPC somehow.

Anyway, there's plenty of free space on the file system:

Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg_echo-lv_root  228G   16G  212G   7% /

It has never been resized, by the way.  I found that this issue had been
mentioned on the mailing list by Hugo Mills (Cc-ed) before after all -
apologies for posting a dupe:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/2694

Is this bug fixed in later versions of btrfs or is it still unresolved,
I wonder?  If the latter, I'll be glad to help out with any debugging
info you might need before I try to fix it (or re-install).

Best regards,
-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
