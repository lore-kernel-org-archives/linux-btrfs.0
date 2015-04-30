Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58278 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbbD3Nb7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 09:31:59 -0400
Received: from [192.168.178.24] ([78.54.171.237]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LfC4q-1ZcWTE45Rw-00orDl for
 <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2015 15:31:57 +0200
Message-ID: <55422ECC.1010508@gmx.de>
Date: Thu, 30 Apr 2015 15:31:56 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: trinity fuzzer : no space left on device although tjthe directory
 is empty
References: <5541285D.3090300@gmx.de>
In-Reply-To: <5541285D.3090300@gmx.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/29/2015 08:52 PM, Toralf Förster wrote:
> Within a 32 bit KVM (stable Gentoo) I run into this situation using trinity (latest git):

FWIW Linux kernel is 4.1-rc1, trinity is  3c6e5e7 - and it is reproducible. Few minutes ago I got :

tfoerste@n22kvm-clone ~ $ df /mnt/ramdisk/btrfs
Filesystem     1K-blocks                  Used Available Use% Mounted on
/dev/loop0        508928 -73786976294837695788      6448 101% /mnt/ramdisk/btrfs

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
--
"; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel"
Ian Mortimer, 2008, "The Time Traveller's Guide to Medieval England"
