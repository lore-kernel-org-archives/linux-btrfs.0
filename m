Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2FMBts (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 21:49:48 -0400
Received: by dady13 with SMTP id y13so241606dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 18:49:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477951.uUzcAEg64Z@when>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
	<pan.2012.06.12.01.53.23@cox.net>
	<1477951.uUzcAEg64Z@when>
Date: Wed, 13 Jun 2012 08:49:47 +0700
Message-ID: <CAG1y0sfRE502A1vEGyNUz9O9XdNZ+iu4bKs0=OKsWGtoSZKT_w@mail.gmail.com>
Subject: Re: Moving top level to a subvolume
From: "Fajar A. Nugraha" <list@fajar.net>
To: Randy Barlow <randy@electronsweatshop.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 9:52 PM, Randy Barlow
<randy@electronsweatshop.com> wrote:
> I personally run Gentoo, but I've been told by some coworkers that the Ubuntu
> installer offers btrfs as an option to the users without marking it as
> experimental, unstable, or under development. I wonder if that is why we see
> so many people surprised when they lose their filesystems. Can anyone verify
> whether that is true of Ubuntu, or of any other Linux distributions?

Oracle linux (when used with UEK2) officially supports btrfs. Opensuse
also supports btrfs, and use its functionality for snapper.

I haven't found any updated (i.e. released post 12.04) official
support status statement from Ubuntu, but they do offer btrfs as
installation option.

As for "lose their filesystems", are there recent ones that uses one
of the three distros above, and is purely btrfs "fault"? The ones I
can remember (from the post to this list) were broken on earlier
kernels, or caused by bad disks.

-- 
Fajar
