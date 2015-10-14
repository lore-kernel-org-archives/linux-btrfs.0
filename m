Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:40542 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbbJNUeI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 16:34:08 -0400
Subject: Re: RAID6 stable enough for production?
To: Donald Pearson <donaldwhpearson@gmail.com>, Sjoerd <sjoerd@sjomar.eu>
References: <2402569.dCkKzGyGNU@hoefnix>
 <CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <561EBC3D.8060004@bouton.name>
Date: Wed, 14 Oct 2015 22:34:05 +0200
MIME-Version: 1.0
In-Reply-To: <CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 14/10/2015 22:23, Donald Pearson a écrit :
> I would not use Raid56 in production.  I've tried using it a few
> different ways but have run in to trouble with stability and
> performance.  Raid10 has been working excellently for me.

Hi, could you elaborate on the stability and performance problems you
had? Which kernels were you using at the time you were testing?

I'm interested because I have some RAID10 installations of 7 disks which
don't need much write performance (large backup servers with few clients
and few updates but very large datasets) that I plan to migrate to RAID6
when they approach their storage capacity (at least theoretically with 7
disks this will give better read performance and better protection
against disk failures). 3.19 brought full RAID5/6 support and from what
I remember there were some initial quirks but I'm unaware of any big
RAID5/6 problem in 4.1+ kernels.

Best regards,

Lionel
