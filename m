Return-Path: <SRS0=l4CM=5L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085DAC43331
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Mar 2020 09:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9722078E
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Mar 2020 09:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="s/I1vWYH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgCZJCs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 05:02:48 -0400
Received: from lists.nic.cz ([217.31.204.67]:34720 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgCZJCr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Mar 2020 05:02:47 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id BE312142776;
        Thu, 26 Mar 2020 10:02:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1585213365; bh=Jja1pDZixewgXbcTva8Ibx0vV0/qZF0GjxafVrfgjD4=;
        h=Date:From:To;
        b=s/I1vWYH96NFlhdXonasWsOCrkkDALm9criFPrw+RT4PtH/EC0D9DokL3yUJClDrD
         JYTC0Zb6nJAzX6/ZNmWNbpLXIfvVcc+YeGZmlggAtFClb/sAPM9Cq1m8SAVWdFGnwh
         cZC5Zj7ND2+U7ZHejP2klvnmeMPp3BLqE7gbIdTo=
Date:   Thu, 26 Mar 2020 10:02:45 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH U-BOOT v2 1/3] fs: btrfs: Use LZO_LEN to replace
 immediate number
Message-ID: <20200326100245.730679aa@nic.cz>
In-Reply-To: <20200326053556.20492-2-wqu@suse.com>
References: <20200326053556.20492-1-wqu@suse.com>
        <20200326053556.20492-2-wqu@suse.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 26 Mar 2020 13:35:54 +0800
Qu Wenruo <wqu@suse.com> wrote:

> Just a cleanup. These immediate numbers make my eyes hurt.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Cc: Marek Behun <marek.behun@nic.cz>
> ---
>  fs/btrfs/compression.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 346875d45a1b..4ef44ce11485 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -12,36 +12,38 @@
>  #include <u-boot/zlib.h>
>  #include <asm/unaligned.h>
> =20
> +/* Header for each segment, LE32, recording the compressed size */
> +#define LZO_LEN		4
>  static u32 decompress_lzo(const u8 *cbuf, u32 clen, u8 *dbuf, u32 dlen)
>  {
>  	u32 tot_len, in_len, res;
>  	size_t out_len;
>  	int ret;
> =20
> -	if (clen < 4)
> +	if (clen < LZO_LEN)
>  		return -1;
> =20
>  	tot_len =3D le32_to_cpu(get_unaligned((u32 *)cbuf));
> -	cbuf +=3D 4;
> -	clen -=3D 4;
> -	tot_len -=3D 4;
> +	cbuf +=3D LZO_LEN;
> +	clen -=3D LZO_LEN;
> +	tot_len -=3D LZO_LEN;
> =20
>  	if (tot_len =3D=3D 0 && dlen)
>  		return -1;
> -	if (tot_len < 4)
> +	if (tot_len < LZO_LEN)
>  		return -1;
> =20
>  	res =3D 0;
> =20
> -	while (tot_len > 4) {
> +	while (tot_len > LZO_LEN) {
>  		in_len =3D le32_to_cpu(get_unaligned((u32 *)cbuf));
> -		cbuf +=3D 4;
> -		clen -=3D 4;
> +		cbuf +=3D LZO_LEN;
> +		clen -=3D LZO_LEN;
> =20
> -		if (in_len > clen || tot_len < 4 + in_len)
> +		if (in_len > clen || tot_len < LZO_LEN + in_len)
>  			return -1;
> =20
> -		tot_len -=3D 4 + in_len;
> +		tot_len -=3D (LZO_LEN + in_len);
> =20
>  		out_len =3D dlen;
>  		ret =3D lzo1x_decompress_safe(cbuf, in_len, dbuf, &out_len);

Reviewed-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
