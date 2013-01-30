Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:54848 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3A3TgY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 14:36:24 -0500
Received: by mail-lb0-f177.google.com with SMTP id go11so2486178lbb.22
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 11:36:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359574114-1804-1-git-send-email-jbacik@fusionio.com>
References: <1359574114-1804-1-git-send-email-jbacik@fusionio.com>
Date: Wed, 30 Jan 2013 11:36:22 -0800
Message-ID: <CADU+-uCv+wG7vt-8gwHUwNboRpBVg7e5pNJyT3KP=yrdd32-AA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix missing i_size update
From: Filipe Brandenburger <filbranden@google.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 11:28 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> +       /*
> +        * We still need to update disk_i_size if outstanding_isize is greater
> +        * than disk_i_size.
> +        */
> +       if (offset <= disk_i_size &&
> +           (!ordered || ordered->outstanding_isize < disk_i_size))

"<=" for the comparison? "ordered->outstanding_isize <= disk_i_size"

Cheers,
Filipe
