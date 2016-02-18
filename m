Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35653 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946428AbcBRRek (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 12:34:40 -0500
Received: by mail-lb0-f178.google.com with SMTP id bc4so32868548lbc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 09:34:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMQ-g0cfWswiW94MEocyGU1PoMtOUyio-bB6N79LtpU8jDwJaw@mail.gmail.com>
References: <CAMQ-g0cfWswiW94MEocyGU1PoMtOUyio-bB6N79LtpU8jDwJaw@mail.gmail.com>
Date: Thu, 18 Feb 2016 18:34:38 +0100
Message-ID: <CAPmG0jYs8d63GH6dt3sB30SYMWPYLJd_oEVxKOmc_fTFHia3Eg@mail.gmail.com>
Subject: Re: Oops on Send
From: Henk Slager <eye1tm@gmail.com>
To: Jan Alexander Steffens <jan.steffens@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 9:29 AM, Jan Alexander Steffens
<jan.steffens@gmail.com> wrote:
> Greetings,
>
> I'm getting reproducible Oopses when attempting "btrfs send" on my
> root vol, quickly ending in a hard lockup of the machine. Both
> incremental send and non-incremental send crash, the former much
> earlier. The volume is in a LUKS container.
>
> The initial fault is always during LZO decompression, but scrub does
> not find any errors. Could this be invalid compressed data with good
> checksums? "btrfs check" finds bad extent backrefs which --repair
> claims to fix, but they reappear on a subsequent check.
>
> Is there a way to find out which files' extents are damaged so I can
> delete them and complete my backup?

man btrfs-send
 -v
          Enable verbose debug output. Each occurrence of this option
increases the verbose level more.
