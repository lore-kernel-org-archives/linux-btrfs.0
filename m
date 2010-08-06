From: Diego Calleja <diegocg@gmail.com>
Subject: Re: [PATCH v3] Btrfs: compressed file size ioctl
Date: Fri, 6 Aug 2010 20:22:24 +0200
Message-ID: <201008062022.24708.diegocg@gmail.com>
References: <1281097304-27628-1-git-send-email-uli@suse.de>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ulrich Hecht <uli@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1281097304-27628-1-git-send-email-uli@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Viernes, 6 de Agosto de 2010 14:21:44 Ulrich Hecht escribi=F3:
>   ioctl(d, BTRFS_IOC_COMPR_SIZE, &size);

I wonder...it's not possible to fit this into FIEMAP somehow? I
though that FIEMAP has been designed with compressed data in
mind.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
