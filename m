Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:53173 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2KLSQH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 13:16:07 -0500
Date: Mon, 12 Nov 2012 19:16:05 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Hugo Mills <hugo@carfax.org.uk>
cc: Roman Mamedov <rm@romanrm.ru>, kreijack@inwind.it, kreijack@libero.it,
        =?UTF-8?Q?S=C3=A9bastien_Maury?= <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
In-Reply-To: <20120928085840.GE6136@carfax.org.uk>
Message-ID: <alpine.LNX.2.01.1211121913370.1611@nerf07.vanv.qr>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu> <20120928085840.GE6136@carfax.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Friday 2012-09-28 10:58, Hugo Mills wrote:
>
>   Data_to_disk_ratio, maybe?
>
>> Why use underscores instead of spaces?
>
>   So that you can use, say, "read" in the shell to extract data from
>each line. To that end, there should be a space between the value and
>the unit throughout.

Eww. Having a special single-line output mode would be much better
for these kinds of integration.

Is it too far fetched to make the info available through sysfs?

 space_used=$(cat /sys/.../space_used)

is so much preferable than an awkful

 space_used=$(btrfs fi df | awk ...)

and hope for that the line is actually in the df output.

