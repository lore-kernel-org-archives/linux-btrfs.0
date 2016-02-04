Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34103 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756AbcBDKOT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 05:14:19 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Moviuro <moviuro@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
Date: Thu, 04 Feb 2016 11:14:17 +0100
Message-ID: <1724218.nF6PTv1Cei@merkaba>
In-Reply-To: <CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com> <56B2AA51.80908@cn.fujitsu.com> <CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 4. Februar 2016, 09:57:54 CET schrieb Moviuro:
> > Although personally I like to let all the backward compatibility
> > things go hell, but that's definitely not how things work. :(
> > 
> > 2) End-user taste.
> > Some end-users like such info as feedback of success.
> > Of course other users like it act as silent as possible.
> 
> I'm pretty sure that's... not the case. Almost everything on GNU/Linux
> is silent. cd(1) is silent, cp(1) is silent, rm(1)...
> What they all have though is a -v|--verbose switch.

The various mkfs commands are not. Not one of them I know of. Additionally 
each one gives a different output.

pvcreate, vgcreate, lvcreate and as well as the remove commands and probably 
other LVM commands are not (no one could argue, that from their ideas they 
come from HP/UX, but thats a Unix as well):

merkaba:~> lvcreate -L 1G -n bla sata
  Logical volume "bla" created.

And I think, not testing right now, that also mdadm is not silent on creating 
a softraid.

So while I agree with you that regular shell commands (coreutils, util-linux) 
are silent on success usually this does not appear to be the case with storage 
related commands in GNU/Linux.

I don´t have a clear oppinion about it other than I´d like to see some 
standard too. coreutils / util-linux both them to have some kind of standard, 
although not necessarily the same standard I bet. And I am not sure whether it 
is documented somewhere.

-- 
Martin
