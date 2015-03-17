Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:56749 "EHLO
	smtp-16.italiaonline.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbbCQXFW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 19:05:22 -0400
Message-ID: <5508B245.5080607@inwind.it>
Date: Wed, 18 Mar 2015 00:01:25 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, peer.loz@gmx.net
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount option
 at same time?
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46> <C879D0AA-018D-4C52-94F8-37D322F8DCD4@gmail.com>
In-Reply-To: <C879D0AA-018D-4C52-94F8-37D322F8DCD4@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-03-15 10:09, Wang Shilong wrote:

Hi Wang,

> 
> Btrfs use COW feautr to do defrag, acutally there was bug in the past
> (nocow and defrag)..
> 
> But make sure your kernel include following commit:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=47059d930f0e002ff851beea87d738146804726d
> 
> With above commit, i think autodefrag should work well with nocow.

If I read correctly, autodefrag disables the NOcow behavior. This to me doesn't seem be "work well"; these are two incompatibles features: enabling autodefrag disables the nocow behavior on all files.
Do I understood correctly ?

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
