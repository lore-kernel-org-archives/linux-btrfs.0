Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38769 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbbEPJOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 May 2015 05:14:53 -0400
Received: by wicnf17 with SMTP id nf17so17129060wic.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2015 02:14:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5556FF5F.1050907@floga.de>
References: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
 <20150515204340.GA20386@mew.dhcp4.washington.edu> <5556FF5F.1050907@floga.de>
From: Markus Baertschi <markus@markus.org>
Date: Sat, 16 May 2015 11:14:11 +0200
Message-ID: <CAKz5JasQE0=0761zjFFbDJLnfs6RZg9YHYsQwHSoki9uDNAyZA@mail.gmail.com>
Subject: Re: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we just want to fix the bashism, then

        if [ "$AUTO" = "false" ]; then

is a good solution. No point to use a yoda condition.


But I like the style proposed by Florian best. It is closest to
traditional shell programming.

On Sat, May 16, 2015 at 10:27 AM, Florian Gamböck <ml@floga.de> wrote:
>
> AUTO=
> # ...
> if [ -z "$AUTO" ]; then

Markus

-- 
Markus Baertschi, Bas du Rossé 16, CH-1163, Etoy, Switzerland
markus@markus.org, +41 (79) 403 1186 (mobile)
