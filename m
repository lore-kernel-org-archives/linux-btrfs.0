Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44361 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2KFEZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 23:25:38 -0500
Received: by mail-ob0-f174.google.com with SMTP id uo13so20172obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2012 20:25:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5097ABF6.6010605@profihost.ag>
References: <5097ABF6.6010605@profihost.ag>
Date: Tue, 6 Nov 2012 11:25:36 +0700
Message-ID: <CAG1y0sdZy=4H1M0OPMvdNEBJwPOKT_vR1UA+LoPY__dpR0RZOg@mail.gmail.com>
Subject: Re: Production use with vanilla 3.6.6
From: "Fajar A. Nugraha" <list@fajar.net>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 5, 2012 at 7:07 PM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> Hello list,
>
> is btrfs ready for production use in 3.6.6? Or should i backport fixes from
> 3.7-rc?
>
> Is it planned to have a stable kernel which will get all btrfs fixes
> backported?

I would say "no" to both, but you should check with distros that
supports btrfs (Oracle Linux and SLES). In particular, whether they
backport fixes, and what exactly does "supported" status gives you
when you buy support for that distro.

-- 
Fajar
