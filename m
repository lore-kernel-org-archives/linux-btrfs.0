Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:45952 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbcCGRiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 12:38:15 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acz6i-00007m-M3
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 18:38:12 +0100
Date: Mon, 7 Mar 2016 18:38:11 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-image run time
Message-ID: <20160307173811.GK6939@torres.zugschlus.de>
References: <20160307172717.GJ6939@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160307172717.GJ6939@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 06:27:17PM +0100, Marc Haber wrote:
> how long is btrfs-image taking to run on a 400 GiB filesystem?
> 
> I have /bin/btrfs-image -s -t 8 -s /dev/mapper/mydevice - | pixz -9 >
> file.on.other.fs running for four hours now

Strike my question please, I didn't see that I had the -s doubled.
With one -s I now see actual progress.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
