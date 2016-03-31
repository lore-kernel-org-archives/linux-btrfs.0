Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34766 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbcCaSms (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 14:42:48 -0400
Received: by mail-lf0-f54.google.com with SMTP id c62so65771330lfc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 11:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160328143714.GZ10135@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
Date: Thu, 31 Mar 2016 20:42:46 +0200
Message-ID: <CAPmG0jazYCBHGP3AA+Wocaz9i-huAeNtkEh7DUnEB6agYQcAgA@mail.gmail.com>
Subject: Re: "bad metadata" not fixed by btrfs repair
From: Henk Slager <eye1tm@gmail.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 4:37 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> Hi,
>
> I have a btrfs which btrfs check --repair doesn't fix:
>
> # btrfs check --repair /dev/mapper/fanbtr
> bad metadata [4425377054720, 4425377071104) crossing stripe boundary
> bad metadata [4425380134912, 4425380151296) crossing stripe boundary
> bad metadata [4427532795904, 4427532812288) crossing stripe boundary
> bad metadata [4568321753088, 4568321769472) crossing stripe boundary
> bad metadata [4568489656320, 4568489672704) crossing stripe boundary
> bad metadata [4571474493440, 4571474509824) crossing stripe boundary
> bad metadata [4571946811392, 4571946827776) crossing stripe boundary
> bad metadata [4572782919680, 4572782936064) crossing stripe boundary
> bad metadata [4573086351360, 4573086367744) crossing stripe boundary
> bad metadata [4574221041664, 4574221058048) crossing stripe boundary
> bad metadata [4574373412864, 4574373429248) crossing stripe boundary
> bad metadata [4574958649344, 4574958665728) crossing stripe boundary
> bad metadata [4575996018688, 4575996035072) crossing stripe boundary
> bad metadata [4580376772608, 4580376788992) crossing stripe boundary

In this case, for all  ... [X,Y) ...

X is 64K aligned and Y - X = 16K

So also false alerts.
