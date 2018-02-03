Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:54452 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbeBCK2E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Feb 2018 05:28:04 -0500
Date: Sat, 3 Feb 2018 17:51:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] libcrc32c: Add crc32c_impl function
Message-ID: <20180203095137.GD28936@gondor.apana.org.au>
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
 <1515404705-490-2-git-send-email-nborisov@suse.com>
 <20180202172942.GU18553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180202172942.GU18553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 06:29:42PM +0100, David Sterba wrote:
> Adding linux-crypto@vger.kernel.org to CC
> 
> Link to the 2/2 patch https://patchwork.kernel.org/patch/10149203/
> 
> On Mon, Jan 08, 2018 at 11:45:04AM +0200, Nikolay Borisov wrote:
> > This function returns a string with the currently in-use implementation
> > of the crc32c algorithm, i.e crc32c-generic (for unoptimised, generic
> > implementation) or crc32c-intel for the sse optimised version. This
> > will be used by btrfs.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> >  include/linux/crc32c.h | 1 +
> >  lib/libcrc32c.c        | 6 ++++++
> >  2 files changed, 7 insertions(+)
> > 
> > diff --git a/include/linux/crc32c.h b/include/linux/crc32c.h
> > index 357ae4611a45..bd21af828ff6 100644
> > --- a/include/linux/crc32c.h
> > +++ b/include/linux/crc32c.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/types.h>
> >  
> >  extern u32 crc32c(u32 crc, const void *address, unsigned int length);
> > +extern const char *crc32c_impl(void);
> >  
> >  /* This macro exists for backwards-compatibility. */
> >  #define crc32c_le crc32c
> > diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
> > index 9f79547d1b97..eaf71e0e04be 100644
> > --- a/lib/libcrc32c.c
> > +++ b/lib/libcrc32c.c
> > @@ -71,6 +71,12 @@ static void __exit libcrc32c_mod_fini(void)
> >  	crypto_free_shash(tfm);
> >  }
> >  
> > +const char *crc32c_impl(void)
> > +{
> > +	return crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
> > +}
> > +EXPORT_SYMBOL(crc32c_impl);

You could just use crypto_shash_driver_name.

> Crypto maintainers, would it be still possible to squeeze this patch to
> 4.16? It's quite trivial, but as it is not in a code I maintain I'm not
> comfortable to add it to my tree (unless I get an ACK).
> 
> The linked patch depends on that change and would let us get rid of some
> custom crypto wrappers around crc32c.

I'm fine with the patch otherwise.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
