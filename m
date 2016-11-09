Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751202AbcKIOuw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 09:50:52 -0500
Date: Wed, 9 Nov 2016 15:50:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/4] btrfs-progs: utils: Introduce function to escape
 characters
Message-ID: <20161109145047.GY12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
 <20161103040734.8098-2-quwenruo@cn.fujitsu.com>
 <20161107102027.GK12522@twin.jikos.cz>
 <58be30ff-591c-6a96-0f48-ea3ba8b8c76d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <58be30ff-591c-6a96-0f48-ea3ba8b8c76d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 08:33:25AM +0800, Qu Wenruo wrote:
> While still some small comment.
> +                         if (!isprint(c)) {
> +                                 printf("\\%c%c%c",
> +                                                 '0' + ((c & 0300) >> 6),
> +                                                 '0' + ((c & 070) >> 3),
> +                                                 '0' + (c & 07));
> 
> For non-printable chars, isn't it more common to print it as hex other 
> than octal?

Ok, hex would be better.
