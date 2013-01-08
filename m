Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63412 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3AHUbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 15:31:22 -0500
Message-ID: <50EC822B.1070102@gmail.com>
Date: Tue, 08 Jan 2013 21:31:39 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=FCnter_Gersdorf?= <G.Gersdorf@tu-bs.de>
CC: linux-btrfs@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
References: <50E9C267.3050302@inwind.it> <kchf4t$scf$1@ger.gmane.org>
In-Reply-To: <kchf4t$scf$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Günter,

On 01/08/2013 04:48 PM, Günter Gersdorf wrote:
> Am 06.01.2013 19:28, schrieb Goffredo Baroncelli:
>>
>> You can pull the change from:
>>     http://cassiopea.homelinux.net/git/util-linux.git
>> from the branch
>>     btrfs-wipefs
>>
> After applying this patch, findfs and blkid didn't find filesystems
> smaller than 256GB, probably because there is no third superblock.

In my system also the stock "findfs" and "blkid" have the same problem:
ie without my patch these utilities were unable to detect a btrfs
filesystem.

Could you confirm that ?

> 
> Günter





-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
