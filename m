Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40595 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2LIFRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Dec 2012 00:17:42 -0500
Date: Sun, 9 Dec 2012 06:17:39 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: linux-btrfs@vger.kernel.org,
        =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Subject: Re: BTRFS, getting darn slower everyday
In-Reply-To: <201210071648.54027.Martin@lichtvoll.de>
Message-ID: <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr>
References: <50714AC8.4010100@petaramesh.org> <201210071259.05801.Martin@lichtvoll.de> <50718C44.2080701@petaramesh.org> (sfid-20121007_163444_636745_E6F75E74) <201210071648.54027.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sunday 2012-10-07 16:48, Martin Steigerwald wrote:
>> 
>> # btrfs su li /
>> ID 256 top level 5 path UBUNTU
>> ID 259 top level 5 path UBUNTU/@
>> ID 261 top level 5 path UBUNTU/@tmp
>> ID 262 top level 5 path UBUNTU/@home
>>[...]
>
>This could be 100 or more subvolumes / snapshots.
>Maybe slowness could be related to this one.

Absolutely. COW snapshots cause severe fragmentation (it's
in their nature). "Easily" reproducible by snapshotting an fs
every day. Been there, had that.
