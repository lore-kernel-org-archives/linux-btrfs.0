Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wnls-smtp3.wa.co.za ([41.185.62.208]:6708 "EHLO
	wnls-smtp3.wa.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3ASVO3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 16:14:29 -0500
Message-ID: <50FB0CA1.4070204@swiftspirit.co.za>
Date: Sat, 19 Jan 2013 23:14:09 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 6/6] Btrfs-progs: detect if the disk we are formatting
 is a ssd
References: <1358618781-26629-1-git-send-email-gene@czarc.net> <1358618781-26629-7-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-7-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/01/19 08:06 PM, Gene Czarcinski wrote:
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
> -values are raid0, raid1, raid10 or single.
> +values are raid0, raid1, raid10, single or dup.  Single device will have dup
> +set by default except in the case of SSDs which will default to single.  This is
> +because SSDs can remap blocks internally so duplicate blocks could end up in the
> +same erase block which negates the benefits of doing metadata duplication.
Can't help but suggest that a "NO_DEDUP" command could be added to the 
SATA Transport Protocol/SCSI Command set. Not sure where to submit that 
idea ... :-/

-- 
Brendan Hide

http://swiftspirit.co.za/

