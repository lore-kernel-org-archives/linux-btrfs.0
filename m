Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46227 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593Ab3BTOPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 09:15:54 -0500
Received: by mail-ob0-f179.google.com with SMTP id un3so7669733obb.24
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 06:15:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5124CA35.2080009@elastichosts.com>
References: <20130201095947.GA32445@gmail.com>
	<20130201103031.GQ16285@carfax.org.uk>
	<5124CA35.2080009@elastichosts.com>
Date: Wed, 20 Feb 2013 14:15:52 +0000
Message-ID: <CAMU1PDhjNpJTO14oB26Dxy+HoEwKEEKcxByh6CO+8DiTd1Grfw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: add '-b' option to filesystem df and show
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 February 2013 13:05, Audrius Butkevicius
<audrius.butkevicius@elastichosts.com> wrote:
> On 01/02/2013 10:30, Hugo Mills wrote:
>>
>> On Fri, Feb 01, 2013 at 09:59:49AM +0000, Audrius Butkevicius wrote:
>>>
>>> Add '-b' and '--bytes' options to btrfs filesystem df and show, for
>>> easier
>>> integration with scripts. This causes all sizes to be displayed in
>>> decimal
>>> bytes instead of pretty-printed with human-readable suffices KB, MB, etc.
>>
>>     Please, not this way.
>>
>
> Hi Hugo,
>
> Just wanted to check which approach you'd prefer to see me adopt:
>
> 1. Providing an option which is handled near the entry point (prior going to
> commands), which would toggle a global flag to indicate the format.
>
> 2. An option in every function which uses pretty sizes. (Though -B seems to
> be used by scrub, -b is used by calc-size and mkfs utils, -u is used by
> subvolume list and so on, meaning the option might have to be different for
> different commands)
>
> 3. An environment variable BTRFS_UNITS, which when set to b[ytes], changes
> the behaviour of pretty printing. Avoids having to touch the multiple sets
> of ad-hoc option parsing code, but is perhaps a slightly non-standard
> interface.
>
> Thanks,
> Audrius.

Just for reference du and df use the following options:
    -b, --bytes    (du only)
    -h, --human-readable
    -k               (equivalent to --block-size=1K)
    --block-size=n[SUFFIX]    (suffixes KB, MB, GB, ... mean 1000,
1000^2, 1000^3 ... and K, M, G, ... mean 1024, 1024^2, 1024^3, ...)

Mike
