Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:47733 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2FTLv0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 07:51:26 -0400
Message-ID: <10842956.228491340193071904.JavaMail.defaultUser@defaultHost>
Date: Wed, 20 Jun 2012 13:51:11 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <chris.mason@fusionio.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: R: Re: Subvolumes and /proc/self/mountinfo
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI all,

>----Messaggio originale----
>Da: chris.mason@fusionio.com
>Data: 20/06/2012 1.49
>A: "H. Peter Anvin"<hpa@zytor.com>
>Cc: "linux-btrfs@vger.kernel.org"<linux-btrfs@vger.kernel.org>
>Ogg: Re: Subvolumes and /proc/self/mountinfo
>

>> b. Are there better ways (walking the tree using BTRFS_IOC_TREE_SEARCH?)
>> to accomplish this than using /proc/self/mountinfo?
>
>Not yet, but I'm definitely open to adding them.  Lets just hash out
>what you need and we'll either go through Kay's stuff or add ioctls for
>you.

Chris, what about adding a /sys/btrfs/<fs-uuid>/<subvol-id> interface ?

For example under

/sys/btrfs/<fs-uuid>

we can list the devices which btrfs uses

under 

/sys/btrfs/<fs-uuid>/<subvol-id> 

we can show/set the subvolume properties (like RO, compres....)

>
>-chris
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


