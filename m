Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:37563 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3BLRhf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 12:37:35 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so341252lab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 09:37:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130212163938.GA12339@twin.jikos.cz>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
	<1360283822-23452-3-git-send-email-pomac@demius.net>
	<20130212163938.GA12339@twin.jikos.cz>
Date: Tue, 12 Feb 2013 09:37:33 -0800
Message-ID: <CADU+-uBA3k3wW_tLDR4WvRt1EaitWcUNGXCzs6xhYJ_ExSmXkw@mail.gmail.com>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
From: Filipe Brandenburger <filbranden@google.com>
To: dsterba@suse.cz
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Feb 12, 2013 at 8:39 AM, David Sterba <dsterba@suse.cz> wrote:
> +# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
> +btrfsck: btrfs
> +       @echo "    [CP]     $@"
> +       $(Q)cp btrfs btrfsck
> +

I think the idea was that btrfsck becomes a link (either symbolic or
hardlink works) to btrfs...

Maybe just replace cp with ln?

Cheers,
Filipe
