Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:43832 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbGRSSl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jul 2015 14:18:41 -0400
Message-ID: <55AA9890.1040606@profihost.ag>
Date: Sat, 18 Jul 2015 20:18:56 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: clm@fb.com
Subject: Re: kernel 4.1: no space left on device
References: <558EC1F4.1050301@profihost.ag>
In-Reply-To: <558EC1F4.1050301@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Still nobody? Upgraded to 4.2-rc2 and i still see the out of space 
situation on two 30TB und 40TB arrays every week.

Stefan

Am 27.06.2015 um 17:32 schrieb Stefan Priebe:
> Hi,
>
> while having some big btrfs volumes (44TB + 37TB).
>
> I see on a regular basis the "no space left on device" message. I'm only
> able to "fix" this. By running btrfs balance AND unmounting and
> remounting the btrfs volume.
>
> Is there any way to debug / workaround this one?
>
> Greets,
> Stefan
