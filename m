Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47256 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CJLX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 07:23:59 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sun, 10 Mar 2013 12:23:56 +0100
Cc: Hugo Mills <hugo@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> (sfid-20130310_104347_651723_C84E4102)
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303101223.56805.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Am Samstag, 9. März 2013 schrieb Hugo Mills:
>    Some time ago, and occasionally since, we've discussed altering the
> "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> number of copies, m is the number of (data) devices in a stripe per copy,
> and p is the number of parity devices in a stripe.
> 
>    The current kernel implementation uses as many devices as it can in
> the striped modes (RAID-0, -10, -5, -6), and in this implementation,
> that is written as "mS" (with a literal "m"). The mS and pP sections are
> omitted if the value is 1S or 0P.
> 
>    The magic look-up table for old-style / new-style is:
> 
> single           1C (or omitted, in btrfs fi df output)
> RAID-0           1CmS
> RAID-1           2C
> DUP                      2CD

What does the "D" in "2CD" mean? Its not explained above, unless I miss 
something.

> RAID-10          2CmS
> RAID-5           1CmS1P
> RAID-6           1CmS2P

I think its great to clarify the RAID-level terminology, but I find the new 
notation a bit, hmmm, cryptic.

Maybe for displaying it would be nice to show a more verbose format like

2 copies, many stripes, 1 parity (1CmS1P)

by default and the abbreviated one in parentheses?

Any other idea to make it less cryptic?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
