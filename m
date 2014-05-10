Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41442 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEJMuC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 08:50:02 -0400
Received: from p5106-ipbfp505yosemiya.okinawa.ocn.ne.jp ([118.3.73.106]:48245 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Wj6j3-0006Pp-3V by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 05:50:01 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wj6iz-0006XJ-03
	for linux-btrfs@vger.kernel.org; Sat, 10 May 2014 05:49:57 -0700
In-Reply-To: <20140510010902.GQ16185@carfax.org.uk>
References: <20140507233959.GB11401@merlins.org>
	<536AD20E.70004@fb.com>
	<20140508004344.GE11401@merlins.org>
	<20140508013440.GH11401@merlins.org>
	<CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
	<20140508220242.GO11401@merlins.org>
	<CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
	<423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
	<20140509223659.GW11401@merlins.org>
	<0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
	<20140510010902.GQ16185@carfax.org.uk>
Date: Fri, 9 May 2014 20:40:26 -0700
Message-ID: <CAKhhfD5c+poPPEYd=VLcU7m8xjORx9yc8TY7M3jZDRUapRX__w@mail.gmail.com>
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 10, 2014 10:09 AM, "Hugo Mills" <hugo@carfax.org.uk> wrote:
>    As in, "Your filesystem got corruption as a result of a bug in some
> earlier version. Upgrading to the new version isn't magically going to
> make that corruption go away". (Not saying that's what's happened
> here, but it's common, and commonly misunderstood).

That's a fair point but I run scrub every day with errors if any, mailed to
me.
Can scrub miss latent corruption?

Marc
