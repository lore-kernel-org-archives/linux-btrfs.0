Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:58450 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbGXTeO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 15:34:14 -0400
Date: Fri, 24 Jul 2015 21:26:10 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: systemd : Timed out =?utf-8?Q?waiting_?=
 =?utf-8?Q?for_defice_dev-disk-by=E2=80=A6?=
Message-ID: <20150724192610.GB468489@mother.pipebreaker.pl>
References: <1437763277.673610371@apps.rackspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1437763277.673610371@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 02:41:17PM -0400, Vincent Olivier wrote:
> Hi,
> 
> (Sorry if this gets sent twice : one of my mail relay is misbehaving today)
> 
> 50% of the time when booting, the system go in safe mode because my 12x 4TB RAID10 btrfs is taking too long to mount from fstab.
> 
> When I comment it out from fstab and mount it manually, it’s all good.
> 
> I don’t like that. Is there a way to increase the timer or something ?

  man systemd.mount, search for ”x-systemd.device-timeout=”.

  But maybe that's a hint for developers, long mount time for btrfs are
quite common – it would be cool if it could be reduced.

-- 
Tomasz Torcz            There exists no separation between gods and men:
xmpp: zdzichubg@chrome.pl   one blends softly casual into the other.

