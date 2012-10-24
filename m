Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:55141 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935320Ab2JXR5L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 13:57:11 -0400
Message-ID: <50882C0B.3@gmx.net>
Date: Wed, 24 Oct 2012 19:57:31 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: "frantz.hacquard" <frantz.hacquard@ensi-bourges.fr>
CC: linux-btrfs@vger.kernel.org
Subject: Re: help with btrfs send
References: <d867c8a573d19560c7b7f3aba7394b10@ensi-bourges.fr>
In-Reply-To: <d867c8a573d19560c7b7f3aba7394b10@ensi-bourges.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/2012 06:53 PM, frantz.hacquard wrote:
> Hi,
> 
> I don't know if it's the good place to ask my question.
> I'm a french student who studies IT.
> I'm working on a project with the btrfs filesystem on Gentoo 64 bits.
> I have to create snapshots and to compare the differences between them
> (new files, deleted files, modified files...).
> So i tried to use btrfs send -i old-snap new-snap.
> To make this command working i created my snapshots thanks to the -r
> option.
> However i only see on the standard output many weird characters but i
> don't understand them.

If you want to dissect the contents, you can pull the tool fardump
from here:

git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git

'far' is the name we're going to give the stream format.

-arne

> I know it's still in developement but is it working ?
> I tried with kernel 3.6.2 and 3.7.0
> 
> Thanks for help.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

