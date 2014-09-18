Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3132 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753184AbaIRJLe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 05:11:34 -0400
Message-ID: <1411031454.25255.11.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: fix page align issue for lzo compress in
 restore
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 18 Sep 2014 17:10:54 +0800
In-Reply-To: <2555349.8u3kbZMf74@fb07-iapwap2>
References: <1411011283-22079-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <2555349.8u3kbZMf74@fb07-iapwap2>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-09-18 at 10:25 +0200, Marc Dietrich wrote:
> Hello Gui,
> 
> Am Donnerstag, 18. September 2014, 11:34:43 schrieb Gui Hecheng:
> > When runing restore under lzo compression, "bad compress length"
> > problems are encountered.
> > It is because there is a page align problem with the @decompress_lzo,
> > as follows:
> > 		|------| |----|-| |------|...|------|
> > 		  page         ^    page       page
> > 			       |
> > 			  3 bytes left
> > 
> > 	When lzo compress pages im RAM, lzo will ensure that
> > 	the 4 bytes len will be in one page as a whole.
> > 	There is a situation that 3 (or less) bytes are left
> > 	at the end of a page, and then the 4 bytes len is
> > 	stored at the start of the next page.
> > 	But the @decompress_lzo doesn't goto the start of
> > 	the next page and continue to read the next 4 bytes
> > 	which is across two pages, so a random value is fetched
> > 	as a "bad compress length".
> > 
> > So we just switch to the page-aligned start position to read
> > the len of next piece of data when "bad compress length" is encounterd.
> > If we still get bad compress length in this case, then there is a
> > real "bad compress length", and we shall report error.
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  cmds-restore.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/cmds-restore.c b/cmds-restore.c
> > index 38a131e..8b230ab 100644
> > --- a/cmds-restore.c
> > +++ b/cmds-restore.c
> > @@ -57,6 +57,9 @@ static int dry_run = 0;
> >  
> >  #define LZO_LEN 4
> >  #define PAGE_CACHE_SIZE 4096
> > +#define PAGE_CACHE_MASK (~(PAGE_CACHE_SIZE - 1))
> > +#define PAGE_CACHE_ALIGN(addr) (((addr) + PAGE_CACHE_SIZE - 1)	\
> > +							& PAGE_CACHE_MASK)
> >  #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
> >  
> >  static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
> > @@ -101,6 +104,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
> >  	size_t out_len = 0;
> >  	size_t tot_len;
> >  	size_t tot_in;
> > +	size_t tot_in_aligned;
> > +	int aligned = 0;
> >  	int ret;
> >  
> >  	ret = lzo_init();
> > @@ -117,6 +122,20 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
> >  		in_len = read_compress_length(inbuf);
> >  
> >  		if ((tot_in + LZO_LEN + in_len) > tot_len) {
> > +			/*
> > +			 * The LZO_LEN bytes is guaranteed to be
> > +			 * in one page as a whole, so if a page
> > +			 * has fewer than LZO_LEN bytes left,
> > +			 * the LZO_LEN bytes should be fetched
> > +			 * at the start of the next page
> > +			 */
> > +			if (!aligned) {
> > +				tot_in_aligned = PAGE_CACHE_ALIGN(tot_in);
> > +				inbuf += (tot_in_aligned - tot_in);
> > +				tot_in = tot_in_aligned;
> > +				aligned = 1;
> > +				continue;
> > +			}
> 
> Small question, shouldn't the aligned check be moved out of the if block?
> First, we could have a bad length caused by the alignment which could result
> in a stream length less than tot_len.

Ah, you have reminded me of a missing case to be covered.

> Second, if we know that the length record never crosses a page, why not
> always check for proper alignment. I think the overhead should be minimal.

I don't think alignment should be checked always, because in the
"normal" case the lzo stuff is "compact":
	[len][----data----][len][----data----]...
It is never aligned to anything and we never knows where next @len
starts before we read the former one. The alignement-related issue is a
rare case.

Thanks for your comments.
-Gui

> Marc
> 
> 
> >  			fprintf(stderr, "bad compress length %lu\n",
> >  				(unsigned long)in_len);
> >  			return -1;
> > @@ -137,6 +156,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
> >  		outbuf += new_len;
> >  		inbuf += in_len;
> >  		tot_in += in_len;
> > +		aligned = 0;
> >  	}
> >  
> >  	*decompress_len = out_len;
> > 


