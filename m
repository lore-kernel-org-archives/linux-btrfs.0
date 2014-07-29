Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaG2NsQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 09:48:16 -0400
Date: Tue, 29 Jul 2014 15:48:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix some build warnings on 32bit platform
Message-ID: <20140729134814.GT1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406393395-4317-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406393395-4317-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 27, 2014 at 12:49:55AM +0800, Wang Shilong wrote:
> cmds-restore.c:120:4: warning: format %lu expects argument of type
> long unsigned int, but argument 3 has type size_t [-Wformat=]
>     fprintf(stderr, "bad compress length %lu\n", in_len);

> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -117,7 +117,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
>  		in_len = read_compress_length(inbuf);
>  
>  		if ((tot_in + LZO_LEN + in_len) > tot_len) {
> -			fprintf(stderr, "bad compress length %lu\n", in_len);
> +			fprintf(stderr, "bad compress length %u\n", in_len);

in_len is size_t, this prints a warning on 64bit. Let's make it %lu and
cas to unsigned long (fixed locally, no need to resend), we'er not using
the 'z' size_t modifier for printf anywhere.
