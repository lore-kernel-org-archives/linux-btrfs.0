Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33115 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbcFEPvh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 11:51:37 -0400
Received: by mail-oi0-f66.google.com with SMTP id f12so6888998oig.0
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 08:51:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465080182.6662.1.camel@scientia.net>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
	<1465005092.6648.39.camel@scientia.net>
	<57528238.6080809@gmail.com>
	<CAJCQCtS+GK88LZHY-uoWarn0qCuDuva4rg_TB_jEwAZo3nCcDQ@mail.gmail.com>
	<1465061839.6689.9.camel@scientia.net>
	<CAJCQCtQsfC5U2dSiT-tdPseaHmJPf=9fai+2vGUNxuf8veKx7g@mail.gmail.com>
	<1465080182.6662.1.camel@scientia.net>
Date: Sun, 5 Jun 2016 09:51:36 -0600
Message-ID: <CAJCQCtTrrusKs2BeXN5AFBGFzS3zsU2KFSh0pk=DhER7pELzvg@mail.gmail.com>
Subject: Re: btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 4, 2016 at 4:43 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sat, 2016-06-04 at 13:13 -0600, Chris Murphy wrote:
>> mdadm supports DDF.
>
> Sure... it also supports IMSM,... so what? Neither of them are the
> default for mdadm, nor does it change the used terminology :)

Why is mdadm the reference point for terminology?

There's actually better consistency in terminology usage outside Linux
because of SNIA and DDF than within Linux where the most basic terms
aren't agreed upon by various upstream maintainers. mdadm and lvm use
different terms even though they're both now using the same md backend
in the kernel.

 mdadm chunk = lvm segment = btrfs stripe = ddf strip = ddf stripe
element. Some things have no equivalents like the Btrfs chunk. But
someone hears chunk and they wonder if it's the same thing as the
mdadm chunk but it isn't, and actually Btrfs also uses the term block
group for chunk, because...

So if you want to create a decoder ring for terminology that's great
and would be useful; but just asking everyone in Btrfs land to come up
with Btrfs terminology 2.0 merely adds to the list of inconsistent
term usage, it doesn't actual fix any problems.


-- 
Chris Murphy
