Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:51162 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2FURLX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 13:11:23 -0400
Message-ID: <4FE355AE.9030305@zytor.com>
Date: Thu, 21 Jun 2012 10:11:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>, cwillu <cwillu@cwillu.com>,
        helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it> <4FE20B3D.5060704@zytor.com> <4FE21134.9090501@libero.it> <4FE2455E.2090007@zytor.com> <4FE2B576.3030301@libero.it> <4FE323DB.1070507@zytor.com> <4FE35473.4050005@libero.it>
In-Reply-To: <4FE35473.4050005@libero.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2012 10:05 AM, Goffredo Baroncelli wrote:
> On 06/21/2012 03:38 PM, H. Peter Anvin wrote:
>>> But if /boot has to be in a separate filesystem, which is the point to
>>>> support btrfs at all ? Does make sense to support only a subset of btrfs
>>>> features ?
>>>>
>> Yes, and that's another good reason for /boot: btrfs supports that kind
>> of policy (e.g. "no compression or encryption in this subtree.")
> 
> But what about large disk ? Syslinux is able to handle large disk ? Or
> it uses BIOS interrupt?

It uses the firmware.. how well the firmware can handle large disks is
another matter.
	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

