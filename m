Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:33175 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbbJJPq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 11:46:56 -0400
Subject: Re: btrfs says no errors, but booting gives lots of errors
To: covici@ccs.covici.com,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com>
 <11640.1444488108@ccs.covici.com>
Cc: linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <561932EF.2090005@bouton.name>
Date: Sat, 10 Oct 2015 17:46:55 +0200
MIME-Version: 1.0
In-Reply-To: <11640.1444488108@ccs.covici.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 10/10/2015 16:41, covici@ccs.covici.com a écrit :
> Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:
>
>> On 10/10/15 14:46, covici@ccs.covici.com wrote:
>>> Hi.  I am having lots of btrfs troubles  -- I am using a 4.1.9 kernel
>> Just FYI, both 4.1.9 and .10 have serious regressions in the network layer
>> that *will*  lock up the whole machine, either after a few minutes or a
>> few hours (when idle). Try 4.2.x or (also more btrfs fixes) or 4.1.8 (OK).

If I'm not mistaken as the OP uses Gentoo gentoo-sources-4.1.9-r1 should
have distribution patches for this (4.1 is LTS, not 4.2 so you might
want to prefer the 4.1 series).

Lionel
