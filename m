Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47508 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933Ab3AOQay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 11:30:54 -0500
Date: Tue, 15 Jan 2013 16:30:52 +0000
From: Christoph Lameter <cl@linux.com>
To: Liu Bo <bo.li.liu@oracle.com>
cc: linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] mm/slab: add a leak decoder callback
In-Reply-To: <1358143419-13074-1-git-send-email-bo.li.liu@oracle.com>
Message-ID: <0000013c3f0c8af2-361e64b5-f822-4a93-a67e-b2902bb336fc-000000@email.amazonses.com>
References: <1358143419-13074-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 14 Jan 2013, Liu Bo wrote:

> This adds a leak decoder callback so that kmem_cache_destroy()
> can use to generate debugging output for the allocated objects.

Interesting idea.

> @@ -3787,6 +3789,9 @@ static int slab_unmergeable(struct kmem_cache *s)
>  	if (s->ctor)
>  		return 1;
>
> +	if (s->decoder)
> +		return 1;
> +
>  	/*
>  	 * We may have set a slab to be unmergeable during bootstrap.
>  	 */

The merge processing occurs during kmem_cache_create and you are setting
up the decoder field afterwards! Wont work.


