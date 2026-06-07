Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62364071DD
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 05:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780810581; cv=none; b=X3g+bK5hNUH+RJctbVNaj+lS1AKY4w5zibVLHtxIF/OZ/Slry9FC27Ag42lBsM7u4+NTYDUrv/Ynr3+m13//WJAniZJeh5h4ffEbDIoZfKMbnKDtAzetOZfjnPqgg1QpQov/8rNSnYV+nPIlI6tVbEXtUa5mXhR9a5nhuvu2AzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780810581; c=relaxed/simple;
	bh=A8t9hCeoQLlihPIbA+jCrdGv38G25Nk9wq9uA8y4IuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DcK+2PEK/NOV8tE2O1+jxmMCIlr6d5f1lDmJIryb2+0tPy2CuGU7kZzHLC/C+fxeYISW87KP7PcnV3r8+b8xBLwXy5PEjG7DLDTpb3VmdFtf/AaBIDJvW/FSd0GyjD6DknWWoQGpV66l/9Z7oDTV72aZoF/IA14FU8Zo6CGrtH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j85ZdVa/; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j85ZdVa/"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c0a5354da1so26175945ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2026 22:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780810579; x=1781415379; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YVtSL8TeTzEFKBL7a/lLlvUpjDj1bGLYk7ZIu2zcnaQ=;
        b=j85ZdVa/4Q26m2ki//0CillodIMfbc9p+Vo2cbzh3laIaPWtJX54dgXFWXyuF2/CHt
         RXOqsPyzbgU9UO1bnwvsDCLhkMTSS57g6n4MYCXn2YP5L+UqMkLZcxdH8gEfyK8sptXU
         y3LPEtw4GKp0xC3IGL4YA/zBCMNlrRvA3d8MdQzXk5Ny+DVGTpx0i29vZcYnHXZEyJmd
         WCAtPIdsN5LwUkMiEcdNFL7vdvVhQzB8Sw5Rg432EaVImiSXAYU/nDos3W+AUCUlCZwI
         cVZkZhXRNJ9eWe1ZwGe8eJwYpM0f5poAw5zECCW+iq7EwtdVoYMXidkUV2MTdQF/b+bi
         a+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780810579; x=1781415379;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVtSL8TeTzEFKBL7a/lLlvUpjDj1bGLYk7ZIu2zcnaQ=;
        b=l12r64Be0FtVDDmXunpNMs1q+OEpABtVnfiYHY1ESKQLZ3wVryz9myOr4bF4Ex3Kch
         KAg+pFDSrAqyAlCkHKCuT3OxU9Sr/mtN51/QPy9GdNwyYNmxb/DepuKDMamq96ahrRJo
         Nyi+a96lXIvmB1+9dXlHMOhiO0DTKQ0y/F9LQQ5tm3ofJdwZbY1nqwWOInst8PTmXfE8
         +Cy4KQBgYt0OG+1tuKJBw2FZD2cL6NRWGW2MdaSp1NfFwaZ/RI4IUrJyG3i56aIwqsCo
         iGJ/anesV5VcfywTDOzS4YmFpRqTUO7WVyt7XrrF+XYSkWLvUq+QvOBTqkM+YaLm5Mk7
         cHRg==
X-Forwarded-Encrypted: i=1; AFNElJ/1JoHsh5OzpcdIb/ZILWiPQa9AjfZYCLf9WJ0jtk06ZFUKQYftxlq+oRvEtVjeKhC0uYrWqOMRTnAoAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFXGgBbCCHSVjag/CVgAR60HX7HMVEAlBC2mvG9IuvFkxwrHBJ
	5AtX+zammeoO3I9tycGPYi9ZmBTqrHmTYAUxWageqOggyx43/MlzJ5Tg
X-Gm-Gg: Acq92OHHJXMmOl6zD1oUj6bdQodkND3VbSkuw/WUKU82Qv2Teetx19rpcpjeU7WFLuC
	oFli0YUI1tFBS7sAMLocRP5d6RewoU60WNEV6ynyZTs27qCx5kOwAVdDiHji0bGcbzGG1LjUEZr
	jla6FiufwvVkVOpUAaS5f5FG0IMjApbfcc2Cy0pB3bFZuP2zNAINim/ZnXwzV+6ZUsbjsh3pkL9
	kR98uLvRyMZKcCGW/+Tr2CO2FjSdwXmEQOQw2SHNFQNTak6Ihu8VmxhTEJIOgP9ePU4QY1dci7S
	FywWtJC3a1fFddT5OBg9+6ZeU01Ms+PXfiGSgscUnnGJue16fO3MbrsscLiwP9kIj35yW/By3d2
	We1tDU4ON5NuiUeq9tuSwxnxCxd1IGv7KPKKnvYEGLCI7bZI5K/5OCYY1xfbPhCIEnnMbknOwre
	ye2CQEyrstSNY6yGa+5y4gGZuXcOHEgnYPHXYdmnaYmL1n6G6NnFbKpL2zLrfhLCArdo0aUODP
X-Received: by 2002:a17:902:e842:b0:2bc:ac76:c1d0 with SMTP id d9443c01a7336-2c1ec964b51mr90243325ad.17.1780810579043;
        Sat, 06 Jun 2026 22:36:19 -0700 (PDT)
Received: from Air.local ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f70660sm139091645ad.11.2026.06.06.22.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 22:36:18 -0700 (PDT)
Date: Sun, 7 Jun 2026 13:36:12 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Xiang Mei <xmei5@asu.edu>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: lzo: reject compressed segment that overflows the
 compressed input
Message-ID: <aiUDKJ0sBpTvAMGK@Air.local>
References: <20260606174816.723525-2-bestswngs@gmail.com>
 <f825ee51-a2be-46ac-9038-d094ecdf3212@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f825ee51-a2be-46ac-9038-d094ecdf3212@suse.com>

On 26-06-07 08:02, Qu Wenruo wrote:
> 
> 
> 在 2026/6/7 03:18, Weiming Shi 写道:
> > lzo_decompress_bio() validates each on-disk segment length seg_len only
> > against the workspace cbuf size, not against the compressed input size
> > (compressed_len, the total folio bytes of the bio).  A crafted extent can
> > carry a segment whose seg_len passes the cbuf check but runs past the end
> > of the bio, so copy_compressed_segment() walks off the last folio:
> > get_current_folio() then returns the NULL folio from bio_next_folio(), and
> > with CONFIG_BTRFS_ASSERT disabled (default) folio_size(NULL) faults.
> > 
> >   BUG: KASAN: null-ptr-deref in lzo_decompress_bio (fs/btrfs/lzo.c:383)
> >   Read of size 8 at addr 0000000000000000 by task kworker/u8:1/29
> >   Workqueue: btrfs-endio simple_end_io_work
> >    kasan_report (mm/kasan/report.c:590)
> >    lzo_decompress_bio (fs/btrfs/lzo.c:383)
> >    end_bbio_compressed_read (fs/btrfs/compression.c:1065)
> >    btrfs_bio_end_io (fs/btrfs/bio.c:135)
> >    btrfs_check_read_bio (fs/btrfs/bio.c:180 fs/btrfs/bio.c:285)
> >    simple_end_io_work
> >    process_one_work
> >    worker_thread
> > 
> > Reject any segment whose payload would extend beyond compressed_len before
> > copying it.
> > 
> > Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >   fs/btrfs/lzo.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> > index 2de18c7b563a..887d740b27aa 100644
> > --- a/fs/btrfs/lzo.c
> > +++ b/fs/btrfs/lzo.c
> > @@ -491,6 +491,10 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
> >   			return -EIO;
> >   		}
> > +		/* The segment must not extend beyond the compressed input. */
> > +		if (unlikely(cur_in + seg_len > compressed_len))
> > +			return -EIO;
> > +
> 
> In lzo_decompress() we return -EUCLEAN, please follow that pattern.
> 
> Although it would be better to output a message when such -EUCLEAN is
> returned.
> 
> Otherwise looks good to me.
> 
> Thanks,
> Qu
> 
> >   		/* Copy the compressed segment payload into workspace */
> >   		copy_compressed_segment(cb, &fi, &cur_folio_index, workspace->cbuf,
> >   					seg_len, &cur_in);
> 

Thanks for the review. v2 sent.

Thanks,
Weiming Shi
