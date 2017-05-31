Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34313 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751148AbdEaN0Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 09:26:16 -0400
Date: Wed, 31 May 2017 15:25:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: Re: [PATCH v4 01/20] btrfs-progs: raid56: Introduce raid56 header
 for later recovery usage
Message-ID: <20170531132514.GD14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
 <20170525062205.11660-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525062205.11660-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 02:21:46PM +0800, Qu Wenruo wrote:
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright (C) 2017 Fujitsu.  All rights reserved.

Please use just plain GPL v2 header in newly created files. The history
of who modified what in the given file is stored in git. I can't simply
remove the copyright notice from existing files without checking first,
but I can stop addding more.

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef _BTRFS_PROGS_RAID56_H
> +#define _BTRFS_PROGS_RAID56_H

The pattern for the ifndef macro name is:

"__BTRFS_" + descriptive header name + "_H__"

just look to other files.
