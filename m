Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:43337 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3KLTYe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 14:24:34 -0500
Message-ID: <52828071.8090305@libero.it>
Date: Tue, 12 Nov 2013 20:24:33 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: add support for inode properties
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

On 2013-11-12 14:42, Filipe David Borba Manana wrote:
> This change adds infrastructure to allow for generic properties for
> inodes via a new ioctl. 

I am sure that there is a valid reason, but I was not able to find it:
why implement a new ioctl instead of using the *{set,get)xattr(2) syscall ?

I noticed that you implemented the Compression properties set/get: is
this from "chattr -c" ?

[... cut other lines ... ]

G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
