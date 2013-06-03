Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [212.13.216.74] ([212.13.216.74]:46313 "EHLO mail.39.gs"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3FCIJy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Jun 2013 04:09:54 -0400
Received: from mail.39.gs (localhost [127.0.0.1])
	by mail.39.gs (Postfix) with ESMTPA id 21CE188989
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 09:02:26 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 03 Jun 2013 09:02:26 +0100
From: Tim Eggleston <tim@timeggleston.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID10 total capacity incorrect
In-Reply-To: <pan$ac513$8629998c$786e3c74$d6f66ecd@cox.net>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
 <099CD4A1-A70D-4446-8C55-843D21BE4E7F@colorremedies.com>
 <20130602174359.GI20133@carfax.org.uk>
 <pan$ac513$8629998c$786e3c74$d6f66ecd@cox.net>
Message-ID: <3a75ea505eaf023bce3e115533c7f314@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'd guess normal df (not btrfs filesystem df) and doing the math in his
> head will be the simplest for him, as it is for me.

> But it's worth noting that normal df with math in your head isn't
> /always/ going to be the answer, as things start getting rather more
> complex as soon as different sized devices get thrown into the mix, or
> raid1/10 on an /odd/ number of devices (tho there the math simply gets 
> a
> bit more complex since it's no longer integers), let alone the case of
> differing data/metadata allocation mode, without even considering the
> case of subvolumes having different modes, since I don't think that's
> implemented yet.

I think you've hit the nail on the head here Duncan. You're absolutely 
right that given my simple setup (even number of devices, all the same 
size, on raid10) it's trivial to do the math in my head. However I don't 
think this approach really scales as well as btrfs is intended to scale 
(up to big numbers, mixed device sizes, mixed raid levels etc etc).

Obviously the implementation of a sane df output for all this stuff is 
non-trivial, but in the long run I don't think expecting the user to 
figure it out is the best approach. I speak here as an interested 
sysadmin who quite enjoys rough edges... but for a lot of users the 
primary thing they want to know about their storage is "how much space 
do I have left".

The documentation does do a good job of pointing out the problems and 
explaining why free space is a tricky concept. But does "tricky" 
/really/ mean "impossible", or is it just "this is a nice to have thing 
that we'll figure out once the core filesystem functions are stable"?

Cheers,

  ---tim

