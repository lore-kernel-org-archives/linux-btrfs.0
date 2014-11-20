Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-macy.wadns.net ([41.185.62.148]:26612 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbaKTMEo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 07:04:44 -0500
Message-ID: <546DD8D8.2070004@swiftspirit.co.za>
Date: Thu, 20 Nov 2014 14:04:40 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: systemd.setenv and a mount.unit
References: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
In-Reply-To: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/20 00:48, Jakob Schürz wrote:
> Hi there!
>
> Another challenge...
> I'm using btrfs. So i make snapshots from my system. And in a script, 
> I make a symlink (for example: @system.CURRENT and @system.LAST) for 
> the current and the last snapshot.
>
> So i want to add 2 entries in grub2 from which i can boot into the 
> current and the last snapshot.
>
> I tried to pass an environmental variable with 
> systemd.setenv=BOOTSNAP=@system.CURRENT, and i have a mount-unit 
> containing the option
>
> Options=defaults,nofail,subvol=archive-local/@system.$BOOTSNAP
Perhaps I'm reading it incorrectly. I interpret this as:
Options=defaults,nofail,subvol=archive-local/@system.@system.CURRENT

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

