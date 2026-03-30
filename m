Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76367374185
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774893618; cv=none; b=s/DcBF90TpR1kv+joxzPioV9z7JStgs8kH13Fq5RlukISZYwuiFFrNvEO4JCIzGDqDLi0INoViiJZAtEo2k6I9JBYwoc+en0aNbn49Kxe6uHCx2+b4DdG0Ftj9SGXLiyNOHqRdL88JDOZzIhnJhAI/LZ8kgLxNzQ0/O6drRKp3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774893618; c=relaxed/simple;
	bh=l/v3H3LqTzOnJNy6GgQvTgUPsBf1c27T7AM4kxF1xzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHOOSDmya+++LdsQT7JWUS0eKxeWnoMPv/9Rzqo6Sp+bzH4gUv4+i1wf13N02GNF1TILg7ssCbaHlmPIG9KOeMdEDfN8sX0jY2Xq+gpSOMzJUsuo2i4z6+heDro8Tb5rINUmHZaw8Ut1np+a+1LOmITA0QaaYVmVxncWuvT1m2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hyOHLpZG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hyOHLpZG"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so47706435e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 11:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774893616; x=1775498416; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tnzQfOi3Jt+J84UCWHanXVNsgnvhvD4O/O5s0FGahS4=;
        b=hyOHLpZGga55bE7BIg2VBitNuYcL/JjACysqnlaAgV6/nFx7xRGPnhdgW+6xN0j/7a
         a+BCS6k4POtfiwPdK6S/j4hkK5vBLRUxZ7TvgO3GrQuH3e5Yq2FzEOZ1f4jPXc3g4giW
         mqM/3qeoi8EF44u8AVBh04RKojb1YV1JlsNj7pvAt7dumB2ufzy4ZeRQvEXg4rm+cWWd
         TSuHRf1t2CgiVDSxZsj4bWz17fKbOB7KDYpNrSJIiXIObC/tew1mUtJH9Ld/mxVy+hZ6
         TgK1CPDpkivBJ1NZL4I3SSNmbxeXqflNH80jTHtNANehdpGYNfOVMC0uqFTLPEchYls6
         QU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774893616; x=1775498416;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnzQfOi3Jt+J84UCWHanXVNsgnvhvD4O/O5s0FGahS4=;
        b=fRKyOe4fQjzipaD6HsUvRffr9pQeFN8DAdR8kYTzZbs8rhebnw/qhmbAWJKyJXGChe
         cHuOGEOmKfgcXkgd6kOZ1vBPtyWPcB+4WiNnZ/K5RupgNcCX2EElWfIEmjuVC8OevCy6
         q3ssOY6Yn569AjbZWNzYwILcFHdcFeqd9e+wsqBBseH5UBBOIAjDY5ImySlHHSyKtvSe
         hpbsK/35v+7eqbov/UyevPOr0Q0+I1JZ1L8QWYoCofYS68KG1p9Xzq5t9hSvBcODQkZ0
         Yjtb+KSF6Ye7NP94qP2rcBjLm4VtkGMk0BioLh3qqFIQDsumskHhv0r+F5w6PFDUPbF4
         CQJg==
X-Gm-Message-State: AOJu0YyfMFkiBf4y7sJkcSy02lP7G2LtInBfUHV04SK18UE4plNs6pcl
	88WGzHYpeCBobGd+F4tIy0fB102oBByggBU+Et7tSzDLPExUkx9McfKU
X-Gm-Gg: ATEYQzx6VtXYVO6wEwWuAaf4QroxsNLqCff3nag14GC1LLNJ8xfDeE6MWvxEVvoWkBS
	OoCQbTHzr2jjUlbgrSOee/KLJMFYSKNmWfIYdV7TyPScVztesA2H/8aPby+Al9Uo2hMC+yriqAg
	eOwl/6DR3YunKsc/lASJq9rEJ1NL979vbawTFrHV0F8dDCWoSKU+m1eONhZty26Yjs1tg1Ga6f1
	QFIO3goNEKMID+j73l+SIKaVQPfWuyzVPjoLKOIQuksp0DAlyyQQyPi2/TJP618MUZUBeQ/sA4S
	v5MGbTjSuJbA6+BY887H8KeL2btLOAEgG4zfzcOtW5d1DlSY9OxTswyfcDdPF2ol9Ru+AyOflxM
	9kT2PxP6UTgWlws1icaGOYNalDDP/jkiKCte2EhTs83s46aJ8RBH7DNWE8sH06qJWnLiaJkqxBE
	e01jBR59HZ8+H0yxbISrT2tps=
X-Received: by 2002:a05:600c:a101:b0:485:50ac:b8cf with SMTP id 5b1f17b1804b1-48878113373mr8102015e9.0.1774893615152;
        Mon, 30 Mar 2026 11:00:15 -0700 (PDT)
Received: from rabbitArch ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487271718a9sm100046795e9.27.2026.03.30.11.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 11:00:14 -0700 (PDT)
Date: Mon, 30 Mar 2026 20:00:12 +0200
From: Teng Liu <27rabbitlt@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
Message-ID: <acq5Y9VuDI9htA-I@rabbitArch>
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
 <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com>
 <aclYf4R2XxlUkxAQ@rabbitArch>
 <4a129696-0352-427f-9e0e-7962e789df57@suse.com>
 <840361b6-9b27-4419-b8ab-891ab254fac9@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <840361b6-9b27-4419-b8ab-891ab254fac9@suse.com>

On 2026-03-30 08:51, Qu Wenruo wrote:
> 
> 
> 在 2026/3/30 08:36, Qu Wenruo 写道:
> > 
> > 
> > Even you wait for all bios, it can still cause problems.
> > 
> > As the bio counter is only for btrfs bio layer, we still have
> > btrfs_bio::end_io called after btrfs_bio_counter_dec().
> > 
> > And if the full fs_info has been freed, then at end_bbio_meta_read(), we
> > can still have problems as btrfs_validate_extent_buffer() will access eb
> > (bbio->private) and fs_info (eb->fs_info), which triggers use after
> > free.
> > 
> > So using that bio counter is not going to solve all problems, but only
> > reducing the race window thus masking the problem.
> > 
> > 
> > The following ideas come up to me, but neither seems as simple as your
> > current one:
> > 
> > 1) Introduce a dedicated counter for metadata readahead/reads
> >     This seems to be the simplest one among all.
> >     But the only usage is only the error handling, thus may not be
> >     worthy.
> > 
> > 2) Disable metadata readahead during open_ctree()
> >     Which will delay the mount, especially for large extent tree without
> >     bgt feature.
> > 
> > 3) Use buffer_tree xarray to iterate through all ebs
> >     Since this is only for error handling of open_ctree(), we're fine to
> >     do the full xarray iteration, and wait for any eb that has
> >     EXTENT_BUFFER_READING flag.
> > 
> >     The problem is, we do not have a dedicated tag like
> >     PAGECACHE_TAG_(TOWRITE|DIRTY) to easily catch all dirty/writeback
> >     ebs.
> >     So the only option is to go through each eb and check their flags.
> > 
> >     I think this is the one with minimal impact, but may cause much
> >     longer runtime during this error handling path.
> > 
> > My personal preference is option 3).
> 
> Or the 4th one, which is only an idea and I haven't yet verified:
> 
> 4) Handle error from invalidate_inode_pages2()
>    Currently we just call invalidate_inode_pages2() on btree inode and
>    expect it to return 0.
> 
>    But if there is still an eb reading pending, it will make that
>    function to return -EBUSY, as try_release_extent_buffer() will
>    find a eb whose refs is not 0, and refuse the release that eb which
>    belongs to a folio.
> 
>    That should be a good indicator of any pending metadata reads.
> 
>    So if that invalidate_inode_pages2() returned -EBUSY, we should wait
>    retry until it returns 0.
> 
> 

Thanks! Yes, it makes sense, simply waiting on the bio counter doesnt
fix the problem here. 

Among the options, I prefer option 3. Although it may be slower, but it
only happens in mount failure path so extra cost seems acceptable.

I am quite new to btrfs codebase so I dont know whether
`invalidate_inode_pages2()` would be a reliable solution so maybe I
should start with option 3?


