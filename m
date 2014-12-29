Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47536 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaL2KO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 05:14:57 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Mon, 29 Dec 2014 11:14:55 +0100
Message-ID: <2759982.e9GFAp0UsT@merkaba>
In-Reply-To: <CAA7pwKM7Dz-c4G3WtbOKR0CB2Ys-G5dPx2+L2=Y=uOK=yY9hug@mail.gmail.com>
References: <3738341.y7uRQFcLJH@merkaba> <2319142.UG75f3UqXt@merkaba> <CAA7pwKM7Dz-c4G3WtbOKR0CB2Ys-G5dPx2+L2=Y=uOK=yY9hug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Dezember 2014, 18:04:31 schrieb Patrik Lundquist:
> On 28 December 2014 at 13:03, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> >
> > BTW, I found that the Oracle blog didn´t work at all for me. I completed
> > a cycle of defrag, sdelete -c and VBoxManage compact, [...] and it
> > apparently did *nothing* to reduce the size of the file.
> 
> They've changed the argument to -z; sdelete -z.

Now how cute is that. Thank you. This did the trick:

martin@merkaba:~/.VirtualBox/HardDisks> VBoxManage modifyhd Winlala.vdi --compact
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
martin@merkaba:~/.VirtualBox/HardDisks> ls -lh
insgesamt 12G
-rw------- 1 martin martin 12G Dez 29 11:00 Winlala.vdi
martin@merkaba:~/.VirtualBox/HardDisks>

It has been 20 GiB before.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
