Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54873 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3HWK3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 06:29:51 -0400
Received: from mfilter27-d.gandi.net (mfilter27-d.gandi.net [217.70.178.155])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id EFCAB172067
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:29:48 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter27-d.gandi.net (mfilter27-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id OXpFPQ333WkW for <linux-btrfs@vger.kernel.org>;
	Fri, 23 Aug 2013 12:29:47 +0200 (CEST)
Received: from xavier-ThinkPad-T60p.lan (118.13.103.84.rev.sfr.net [84.103.13.118])
	(Authenticated sender: xavier@bartica.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 304D11720D1
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:29:46 +0200 (CEST)
Date: Fri, 23 Aug 2013 12:29:42 +0200
From: Xavier Bassery <xavier@bartica.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: default mount options 3.10
Message-ID: <20130823122942.18548b21@xavier-ThinkPad-T60p.lan>
In-Reply-To: <52172DB0.1000701@gmail.com>
References: <52172DB0.1000701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 23 Aug 2013 11:38:56 +0200
David Kofler <dkofler92@googlemail.com> wrote:

> Hi,
> can someone tell me which mount options are included in "defaults"
> mount option? Couldn't find this in BTRFS Wiki. I'm using Debian
> Wheezy 7.1 and Linux kernel 3.10.6.
> Thanks in advance.

Hi,
you've looked at the wrong place.
>From mount man page:

FILESYSTEM INDEPENDENT MOUNT OPTIONS
defaults : Use default options: rw, suid, dev, exec, auto, nouser, async

You can also have a look here [1].

Best regards,
Xavier

[1] https://wiki.debian.org/fstab#Field_definitions
