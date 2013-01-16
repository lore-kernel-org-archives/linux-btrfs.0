Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16475 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3APBEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 20:04:53 -0500
Date: Wed, 16 Jan 2013 09:02:30 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] mm/slab: add a leak decoder callback
Message-ID: <20130116010229.GB3942@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1358143419-13074-1-git-send-email-bo.li.liu@oracle.com>
 <0000013c3f0c8af2-361e64b5-f822-4a93-a67e-b2902bb336fc-000000@email.amazonses.com>
 <20130115170105.GP12288@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130115170105.GP12288@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 09:01:05AM -0800, Zach Brown wrote:
> > The merge processing occurs during kmem_cache_create and you are setting
> > up the decoder field afterwards! Wont work.
> 
> In the thread I suggested providing the callback at destruction:
> 
>  http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21130.html
> 
> I liked that it limits accesibility of the callback to the only path
> that uses it.

Well, I was trying to avoid API change, but seems we have to, I'll
update the patch as your suggestion in the next version.

thanks,
liubo
