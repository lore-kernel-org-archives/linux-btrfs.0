Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60837 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbaIRJZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 05:25:07 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix page align issue for lzo compress inrestore
Date: Thu, 18 Sep 2014 11:25 +0200
Message-ID: <1416727.rLUkdMm4S0@fb07-iapwap2>
In-Reply-To: <1411031454.25255.11.camel@localhost.localdomain>
References: <1411011283-22079-1-git-send-email-guihc.fnst@cn.fujitsu.com> <2555349.8u3kbZMf74@fb07-iapwap2> <1411031454.25255.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4585556.O6XPaj2BUd"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4585556.O6XPaj2BUd
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Am Donnerstag, 18. September 2014, 17:10:54 schrieb Gui Hecheng:
> On Thu, 2014-09-18 at 10:25 +0200, Marc Dietrich wrote:
> > Hello Gui,
> > 
> > Am Donnerstag, 18. September 2014, 11:34:43 schrieb Gui Hecheng:
> > > When runing restore under lzo compression, "bad compress length"
> > > problems are encountered.
> > > It is because there is a page align problem with the @decompress_lzo,
> > > as follows:
> > > 		|------| |----|-| |------|...|------|
> > > 		  page         ^    page       page
> > > 			       |
> > > 			  3 bytes left
> > > 
> > > 	When lzo compress pages im RAM, lzo will ensure that
> > > 	the 4 bytes len will be in one page as a whole.
> > > 	There is a situation that 3 (or less) bytes are left
> > > 	at the end of a page, and then the 4 bytes len is
> > > 	stored at the start of the next page.
> > > 	But the @decompress_lzo doesn't goto the start of
> > > 	the next page and continue to read the next 4 bytes
> > > 	which is across two pages, so a random value is fetched
> > > 	as a "bad compress length".
> > > 
> > > So we just switch to the page-aligned start position to read
> > > the len of next piece of data when "bad compress length" is encounterd.
> > > If we still get bad compress length in this case, then there is a
> > > real "bad compress length", and we shall report error.
> > > 
> > > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > > ---
> > >  cmds-restore.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/cmds-restore.c b/cmds-restore.c
> > > index 38a131e..8b230ab 100644
> > > --- a/cmds-restore.c
> > > +++ b/cmds-restore.c
> > > @@ -57,6 +57,9 @@ static int dry_run = 0;
> > >  
> > >  #define LZO_LEN 4
> > >  #define PAGE_CACHE_SIZE 4096
> > > +#define PAGE_CACHE_MASK (~(PAGE_CACHE_SIZE - 1))
> > > +#define PAGE_CACHE_ALIGN(addr) (((addr) + PAGE_CACHE_SIZE - 1)	\
> > > +							& PAGE_CACHE_MASK)
> > >  #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
> > >  
> > >  static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
> > > @@ -101,6 +104,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
> > >  	size_t out_len = 0;
> > >  	size_t tot_len;
> > >  	size_t tot_in;
> > > +	size_t tot_in_aligned;
> > > +	int aligned = 0;
> > >  	int ret;
> > >  
> > >  	ret = lzo_init();
> > > @@ -117,6 +122,20 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
> > >  		in_len = read_compress_length(inbuf);
> > >  
> > >  		if ((tot_in + LZO_LEN + in_len) > tot_len) {
> > > +			/*
> > > +			 * The LZO_LEN bytes is guaranteed to be
> > > +			 * in one page as a whole, so if a page
> > > +			 * has fewer than LZO_LEN bytes left,
> > > +			 * the LZO_LEN bytes should be fetched
> > > +			 * at the start of the next page
> > > +			 */
> > > +			if (!aligned) {
> > > +				tot_in_aligned = PAGE_CACHE_ALIGN(tot_in);
> > > +				inbuf += (tot_in_aligned - tot_in);
> > > +				tot_in = tot_in_aligned;
> > > +				aligned = 1;
> > > +				continue;
> > > +			}
> > 
> > Small question, shouldn't the aligned check be moved out of the if block?
> > First, we could have a bad length caused by the alignment which could result
> > in a stream length less than tot_len.
> 
> Ah, you have reminded me of a missing case to be covered.
> 
> > Second, if we know that the length record never crosses a page, why not
> > always check for proper alignment. I think the overhead should be minimal.
> 
> I don't think alignment should be checked always, because in the
> "normal" case the lzo stuff is "compact":
> 	[len][----data----][len][----data----]...
> It is never aligned to anything and we never knows where next @len
> starts before we read the former one. The alignement-related issue is a
> rare case.

sorry, my wording was wrong. I mean always check for page crossing of the length
record and move forward if yes.

Marc


--nextPart4585556.O6XPaj2BUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUGqTsAAoJEKyeR39HFBtooBYH/jRUy3CJ+MG7zXt0vcjJEv7v
yGKsSESEAVOmBMzhebdxlcWn3dK9qfUSm7Nhz/g5dj009qmuJz8t5YQZv0uPV8qf
coCUJDE3HvHMgZIJEkHiNdK9KnK9AlM26/BAcKEZlfcycYj/wr4t78NzNwes23TZ
zrQvAzlCh3QcnAFtzy42FwOs6/ocoCTJ8QbSYkpQJX0v1a1IjLjWNuAfp/TM3i0b
eo1O2sLHrz84c8NywVqAPFHB2+4c7o/tHsYy0ICgQIyYUPYUz38aXwxpFh5SXv4l
/+pgfN5Yjb02mbQRe2rLCy0aFlhiYHwe9p9JM2lIy5Nv/voaGA4t40xYttvdCGg=
=VN14
-----END PGP SIGNATURE-----

--nextPart4585556.O6XPaj2BUd--

