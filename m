Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50921 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754352AbaIWB1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 21:27:09 -0400
Message-ID: <1411435581.8450.1.camel@localhost.localdomain>
Subject: Re: [PATCH v3] btrfs-progs: fix page align issue for lzo compress
 in restore
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <marvin24@gmx.de>,
        <zooko@leastauthority.com>
Date: Tue, 23 Sep 2014 09:26:21 +0800
In-Reply-To: <20140922134115.GP9715@twin.jikos.cz>
References: <1411376306-10228-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140922134115.GP9715@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-09-22 at 15:41 +0200, David Sterba wrote:
> On Mon, Sep 22, 2014 at 04:58:26PM +0800, Gui Hecheng wrote:
> > So we check page alignment every time before we are going to
> > fetch the next @len and after the former piece of data is decompressed.
> > If the current page that we reach has less than 4 bytes left,
> > then we should fetch the next @len at the start of next page.
> 
> Thanks for the fix.
> 
> > --- a/cmds-restore.c
> > +++ b/cmds-restore.c
> > @@ -57,6 +57,9 @@ static int dry_run = 0;
> >  
> >  #define LZO_LEN 4
> >  #define PAGE_CACHE_SIZE 4096
> > +#define PAGE_CACHE_MASK (~(PAGE_CACHE_SIZE - 1))
> > +#define PAGE_CACHE_ALIGN(addr) (((addr) + PAGE_CACHE_SIZE - 1)	\
> > +							& PAGE_CACHE_MASK)
> 
> This is not type-safe, the PAGE_CACHE_SIZE should be unsigned long.
> 
> >  #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
> >  
> >  static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
> > @@ -93,6 +96,28 @@ static inline size_t read_compress_length(unsigned char *buf)
> >  	return le32_to_cpu(dlen);
> >  }
> >  
> > +static void align_if_need(size_t *tot_in, size_t *in_len)
> > +{
> > +	int tot_in_aligned;
> > +	int bytes_left;
> > +
> > +	tot_in_aligned = PAGE_CACHE_ALIGN(*tot_in);
> 
> size_t -> int, plus other tricks that happen inside the macro
> 
> > +	bytes_left = tot_in_aligned - *tot_in;
> 
> int = int - size_t
> 
> > +
> > +	if (bytes_left >= LZO_LEN)
> > +		return;
> > +
> > +	/*
> > +	 * The LZO_LEN bytes is guaranteed to be
> > +	 * in one page as a whole, so if a page
> > +	 * has fewer than LZO_LEN bytes left,
> > +	 * the LZO_LEN bytes should be fetched
> > +	 * at the start of the next page
> > +	 */
> 
> Nitpick, the comment can use the whole width of the line
> 
> 	/*
> 	 * The LZO_LEN bytes is guaranteed to be in one page as a whole,
> 	 * so if a page has fewer than LZO_LEN bytes left, the LZO_LEN
> 	 * bytes should be fetched at the start of the next page
> 	 */
> 
> > +	*in_len += bytes_left;
> > +	*tot_in = tot_in_aligned;
> > +}

Thanks David, I will pay more attention to the type-safe issue and
resend.

-Gui

