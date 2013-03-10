Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49310 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CJVpc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 17:45:32 -0400
Received: by mail-lb0-f182.google.com with SMTP id gg6so2661251lbb.13
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 14:45:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130310213606.GE30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <201303101223.56805.Martin@lichtvoll.de> <20130310213606.GE30771@carfax.org.uk>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 10 Mar 2013 22:45:10 +0100
Message-ID: <CAFWF=amgMRcBaoTXZiFSEQnJkmayf7SPXddktbGuvN0q3qd7UA@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
To: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 10:36 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>    Oh, sorry. It's "reduced redundancy", aka DUP -- i.e. you get that
> number of copies, but not guarantee that the copies all live on
> different devices. I'm not devoted to showing it this way. Other
> suggestions for making this distinction are welcomed. :)
>
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- There's many a slip 'twixt wicket-keeper and gully. ---

I've noticed through my own tests that on a single device I can
corrupt around 5% of the data completely before btrfs fails. Up to
that point both filesystem as well as data integrity stays at 100%.
However the default layout for one disk seems to be having the data
once, the metadata DUP and the system DUP too. Having these 5% isn't
mentioned anywhere... Is this a value that could maybe be manipulated
and could it be introduced into a naming scheme like this? Also where
do the 5% redundancy come from?
