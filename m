Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56806 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921Ab3BTNGA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 08:06:00 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so4234625eek.37
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 05:05:57 -0800 (PST)
Message-ID: <5124CA35.2080009@elastichosts.com>
Date: Wed, 20 Feb 2013 13:05:57 +0000
From: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add '-b' option to filesystem df and show
References: <20130201095947.GA32445@gmail.com> <20130201103031.GQ16285@carfax.org.uk>
In-Reply-To: <20130201103031.GQ16285@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/02/2013 10:30, Hugo Mills wrote:
> On Fri, Feb 01, 2013 at 09:59:49AM +0000, Audrius Butkevicius wrote:
>> Add '-b' and '--bytes' options to btrfs filesystem df and show, for easier
>> integration with scripts. This causes all sizes to be displayed in decimal
>> bytes instead of pretty-printed with human-readable suffices KB, MB, etc.
>     Please, not this way.
>

Hi Hugo,

Just wanted to check which approach you'd prefer to see me adopt:

1. Providing an option which is handled near the entry point (prior 
going to commands), which would toggle a global flag to indicate the 
format.

2. An option in every function which uses pretty sizes. (Though -B seems 
to be used by scrub, -b is used by calc-size and mkfs utils, -u is used 
by subvolume list and so on, meaning the option might have to be 
different for different commands)

3. An environment variable BTRFS_UNITS, which when set to b[ytes], 
changes the behaviour of pretty printing. Avoids having to touch the 
multiple sets of ad-hoc option parsing code, but is perhaps a slightly 
non-standard interface.

Thanks,
Audrius.
