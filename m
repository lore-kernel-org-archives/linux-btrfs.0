Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34277 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbcG1OcD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 10:32:03 -0400
Received: by mail-qk0-f194.google.com with SMTP id p126so4966242qke.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 07:32:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz> <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de> <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
From: Patrick Baggett <baggett.patrick@gmail.com>
Date: Thu, 28 Jul 2016 09:32:01 -0500
Message-ID: <CAEk2StnG8BnGSwQd+vCUczK=s-_x-maG+VDOMBvq=2nfW_aSMw@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Anatoly Pugachev <matorola@gmail.com>, dsterba@suse.cz,
        debian-sparc <debian-sparc@lists.debian.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Oh, and you will somehow need to guard this with #if BITS_PER_LONG == 64 ...
> #else ... #endif respectively since you need to use different versions
> (64 vs. 32) of get_unaligned_* depending on the size of unative_t.

Maybe a get_unaligned_unative() would be better so that preprocessor
fun is kept to a minimum. :)

--Patrick
