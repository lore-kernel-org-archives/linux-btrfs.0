Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:51735 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750813AbaKTLOE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 06:14:04 -0500
Message-ID: <546DCD20.6030602@inwind.it>
Date: Thu, 20 Nov 2014 12:14:40 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: systemd.setenv and a mount.unit
References: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net> <546DBFCB.4090506@inwind.it> <546DC3EC.1020903@nurfuerspam.de>
In-Reply-To: <546DC3EC.1020903@nurfuerspam.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-20 11:35, Jakob Schürz wrote:
> Am 2014-11-20 um 11:17 schrieb Goffredo Baroncelli:
[....]
>> 
>> rootflags=subvol=debian
>> 
>> so, the subvol=debian option is passed to mount. When
>> grub-mkconfig generates the grub menu entries, does so.
> 
> This I also have in my grub-config, and it works. But it doesn't
> solve the challenge. Mounting more subvolumes according to the
> root-subvolume... :-)
> 

Ah! You never told that this is your request.

I can only suggest that after snapshooting the "/",
you snapshot their subvolumes, placing these under
the root snapshoot itself:

Supposing to have the following four subvolumes

/root/
/root/etc
/root/usr
/root/var

When you need to snapshot, you should:

# btrfs subvolume snapshot /root /backup-root-20141120
# btrfs subvolume snapshot /root/etc /backup-root-20141120/etc
# btrfs subvolume snapshot /root/usr /backup-root-20141120/usr
# btrfs subvolume snapshot /root/var /backup-root-20141120/var

So in order to remount an "old" filesystem, you need to make only
1 mount.










> regards Jakob
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
