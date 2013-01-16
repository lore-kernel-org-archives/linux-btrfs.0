Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49950 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab3APBCP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 20:02:15 -0500
Date: Wed, 16 Jan 2013 08:59:43 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] mm/slab: add a leak decoder callback
Message-ID: <20130116005942.GA3942@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1358143419-13074-1-git-send-email-bo.li.liu@oracle.com>
 <0000013c3f0c8af2-361e64b5-f822-4a93-a67e-b2902bb336fc-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0000013c3f0c8af2-361e64b5-f822-4a93-a67e-b2902bb336fc-000000@email.amazonses.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 04:30:52PM +0000, Christoph Lameter wrote:
> On Mon, 14 Jan 2013, Liu Bo wrote:
> 
> > This adds a leak decoder callback so that kmem_cache_destroy()
> > can use to generate debugging output for the allocated objects.
> 
> Interesting idea.
> 
> > @@ -3787,6 +3789,9 @@ static int slab_unmergeable(struct kmem_cache *s)
> >  	if (s->ctor)
> >  		return 1;
> >
> > +	if (s->decoder)
> > +		return 1;
> > +
> >  	/*
> >  	 * We may have set a slab to be unmergeable during bootstrap.
> >  	 */
> 
> The merge processing occurs during kmem_cache_create and you are setting
> up the decoder field afterwards! Wont work.

You're right, I miss the lock part.

thanks,
liubo
