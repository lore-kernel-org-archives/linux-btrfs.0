Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:47918 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbcC1S5L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 14:57:11 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1akcLc-0005Oi-M9
	for linux-btrfs@vger.kernel.org; Mon, 28 Mar 2016 20:57:08 +0200
Date: Mon, 28 Mar 2016 20:57:08 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160328185708.GB10135@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <20160328184237.GA10135@torres.zugschlus.de>
 <20160328185102.GM29474@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160328185102.GM29474@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 06:51:02PM +0000, Hugo Mills wrote:
>    "Could not find root 8" is harmless (and will be going away as a
> message soon). It just means that systemd is probing the FS for
> quotas, and you don't have quotas enabled.

*phew* That message was not what I wanted to read on this filesystem.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
