Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:44446 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3AIRsM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 12:48:12 -0500
Message-ID: <50EDAD6C.4050901@gmail.com>
Date: Wed, 09 Jan 2013 18:48:28 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Goffredo Baroncelli <kreijack@inwind.it>, util-linux@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
References: <50E9C267.3050302@inwind.it> <20130108164314.GA9177@x2.net.home>
In-Reply-To: <20130108164314.GA9177@x2.net.home>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Karel,

> 
>  You can specify more than one magic strings for the same filesystem,
>  the .magics = { } is array.

thanks for you suggestion. However this seems to me not applicable. I
tried to change the code, and what I got to me seems inconsistently:

Whit this change

1) if I do "wipefs <device>", I got the offset of the first superblock
(good enough)
2) if I do "wipefs -a <device>", I clean-up *all three* superblocks
(very good)
3) if I do "wipefs -o <offset> <device>", I clean-up only the superblock
located at <offset> (very bad)

If the user doesn't know enough btrfs, trying 1) and 3) could think that
the disk is cleaned-up. Instead the 2nd and the 3rd super-blocks still
exist.

>  see for example libblkid/src/superblocks/reiserfs.c 

I think that this is a different case: the reiser superblocks are
*alternative*; instead in the btrfs case, *all the three superblocks*
exist at the same time.

>  Karel
Ciao
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
