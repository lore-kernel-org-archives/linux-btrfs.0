Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:54994 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2FZGss (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 02:48:48 -0400
Message-ID: <4FE95B45.8030909@arndnet.de>
Date: Tue, 26 Jun 2012 08:48:37 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: chris.mason@fusionio.com
CC: dave@jikos.cz, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ierdnah@gmail.com
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
References: <20120406102232.GH14256@twin.jikos.cz> <1334582871-3670-1-git-send-email-arnd@arndnet.de> <20120416144233.GC20982@twin.jikos.cz>
In-Reply-To: <20120416144233.GC20982@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Am 16.04.2012 16:42, schrieb David Sterba:
> On Mon, Apr 16, 2012 at 03:27:51PM +0200, Arnd Hannemann wrote:
>> Btrfs allows to turn on compression on a mounted and used filesystem
>> by issuing mount -o remount,compress=lzo.
>> This patch allows to turn compression off again
>> while the filesystem is mounted. As suggested by David Sterba
>> if the compress-force option was set, it is implicitly cleared
>> if compression is turned off.
>>
>> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
> 
> Tested-by: David Sterba <dsterba@suse.cz>
> 
> worked perfectly, remounting back and forth with compress=lzo =no
> -force=lzo etc, checked output via 'mount'.

How show should we proceed to get above mentioned patch
(or the similar patch from Andrei Popa) merged?

Best regards,
Arnd


