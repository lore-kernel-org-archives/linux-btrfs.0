Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:56783 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2KWUnO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Nov 2012 15:43:14 -0500
Received: by mail-yh0-f46.google.com with SMTP id m54so738929yhm.19
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2012 12:43:14 -0800 (PST)
From: "Garry T. Williams" <gtwilliams@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
Date: Fri, 23 Nov 2012 15:43:11 -0500
Message-ID: <2925363.jTFvA7mLni@vfr>
In-Reply-To: <50AFB620.6040707@prnet.org>
References: <50AFB620.6040707@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, November 23, 2012 18:45:04 David Arendt wrote:
>   for (i = 0; i < attrslen; i+= strlen(&attrs[i]) + 1)
>   {
>     printf("processing attribute %s\n", &attrs[i]);
> 
>     valuelen = lgetxattr(argv[1], &attrs[i], value, 1024);
> 
>     if (valuelen < 0);
  Hmmm ----------------^



-- 
Garry T. Williams

