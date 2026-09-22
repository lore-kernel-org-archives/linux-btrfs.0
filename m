Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A344189BA
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068445; cv=none; b=G/tyBH8ZRax8lKNSPyqyACzUqbcl04SVH6J47+8phQ2EGvmh+ttJrY5ygjFH9MWHmxxcumCEm9Cjs+WgQ/GS/3KTGLjDF5Py9yjwejgyARvmWPhfEQ+KoG3ntQMiznqI76P5c0eyQlrI1mbMc4IU+s25WTGplY53Hrs4Fiwbzio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068445; c=relaxed/simple;
	bh=x6HQo2Ql98Umszl1bLbKyaBGyakHflH2Y/8sgqKcP6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yxxxzg83jtBiNV6aDrdqHZKmJpNsuro5H+oA5sOhVOWs7m3tFkVkAHPH4udTrDrGz43nH+9OaFKmx8X/iZYBkTsduKgjrj7fU5l5xhwL044qDDmTS2kliwMhDbeMSKaLU2IEsfAJng4Jml51zs8hXTGPd9wvUI9QX1xSgJVazXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LxEqbqpA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l1HC45aM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxEqbqpA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l1HC45aM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790068443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
	b=LxEqbqpA48CzjEIfWwWsfdnJQ6DT+0Gjr7rFHl0yKicXf1qYOb1O62HmQqJJbrcdgsZOvI
	0APRDD3VKbsWISf1sRQfEoUpx1K0YWTA79KKjXpgsPaLSz84QhbWeoqvoeRTD2Yf/OMui5
	MP4xAfhC71olnrxRGu96mC00EWFG9Yw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-n5Df4r7mOHms6fizLucqUg-1; Tue, 22 Sep 2026 05:14:00 -0400
X-MC-Unique: n5Df4r7mOHms6fizLucqUg-1
X-Mimecast-MFC-AGG-ID: n5Df4r7mOHms6fizLucqUg_1790068439
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49d0ae342b9so28111865e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 02:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790068439; x=1790673239; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
        b=l1HC45aMBgZ3xdsjio+YOyFachXKLMHZ43yaEiUZSxWNLhureP/1vW00dqcUTs4Cfs
         cAZ7eDbExdfqfd7jumDGq05Wqgy43tgavAFljqCZwrZDPlodroYA7n0cw53ZsFu88knm
         /vUil+LjTJ2WzWoEnH/r2T1nHlFILNDmT8T84h5WGMfoWudwr6aALc4ysvJURZyvNsm+
         WkHIfqXvEnDl7/f+lAfOPN2nP/ooQQTMbcT5x2AodvDKawVN93woRz2w7FCYoDQ8UmJV
         4o/kz4S8Oxs91owRFPG390XpDgUi3Z9VrbKXP8ePWIar68iP6lU+M0SuEWokdxpZkRu6
         eexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790068439; x=1790673239;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o4baz/6RzxjMCiX3WhcQq7uKFgXpKloXgi45FkMIoFs=;
        b=RMuvA5Jnhr+WvB5tMg/A+z47F0qTZN8Rhvbb+1C0JmuUATBdmsJJY83WRCJ0D/nha3
         5ydhAiQLVOQ1cedttBmESjX/tjfCBRpBfOKtVCnhxjQZKTFbY/h3NRXk/7Y6HA7Ua30I
         TVxU9sS4LFOIubyyh+3vBLc8AQGg2zIzjL1QFQjBWPS/TdUNQ4RJpYaXpcn0SPUXwIBw
         4n6gJzHwyDJ7SwrINQgMnIugEiSzgXmSXEipuvQlYIvH2bEyLqG0JhqvY1cLEGSDvAg1
         DTo8eD+NEYiOrOxEAcc60iqPW1fUUFJJbxv2d9YzOO7njHEtups3uncCooDGUdBWGD1c
         zoWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYJgVK2J7pROF3f0cRAMgYazDQHMAljDy3yTHe0eH1ABblJgVRsw4ysvblnwDXpooo+bzFequs1bRv1w==@vger.kernel.org
X-Gm-Message-State: AFuF++ma/QiaZniANLRWsY8lps6swCulCaEjaWvAVaOEByU4eYDQjf1a
	L7gjgTOesM9m0kmi7p9ZrezhAQtnpNWVclpCEzTPmR8hrdxMNohBumGbeW1yH17YpgsHHq+xoc6
	rLvWiWKBYQAXM7Ym/QaLIf1XDUd7gv0E/nu7IqXprhdhQf7NHfHmqXC+sx2T+OZ4=
X-Gm-Gg: AYBFou0/1+73DMtlXrPU4R2GfAdiFAm8TNpc89qN3nPzaVRkhU9X65bTwNhrJjnBJLf
	HSuudr/uvs5QYL/vgQiEdcPbAr8j8HFscrvPuKsoC8v4K1mil3xkZwXZ3mkp7rH5rTS8FbeioYB
	5FWNq41knQTWrQk4UuTNGUyv69PsuwRJReEw9sfC0//dr+w6Y6qDGhN7QlwMA7Ax5ldA58whIOL
	x4e2CE/VUnLyqt4e4/Xi1KuCenKlngn3BHWbBm0O3y0FQAym7yrT0+mdaDx9bH/QOtXIcZjz7ws
	tGisF7mzUFCVL4VYl3u1Rylo728zvw3CP6i0MoPhxFCRyd27OtZck1+UODU8vRnQ9nox0xb0Cmk
	AfUivUqX5tGHn6yAvKjHzWBTk6uconkmcfA==
X-Received: by 2002:a05:600c:46c7:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fc56dbb20mr184454675e9.4.1790068438828;
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
X-Received: by 2002:a05:600c:46c7:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fc56dbb20mr184454405e9.4.1790068438389;
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdaa4e47csm74372105e9.1.2026.09.22.02.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:13:58 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:13:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	ebiggers@kernel.org, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <arJFUV3WDkY6zmfD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
 <arIrtgZ3-9zNuru_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIrtgZ3-9zNuru_@infradead.org>

On 2026-09-22 00:18:14, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:24PM +0200, Andrey Albershteyn wrote:
> > +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> > +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> > +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
> > +			fsv_ioend = kmem_cache_zalloc(xfs_fsverity_ioend_cache,
> > +					GFP_KERNEL);
> > +			if (!fsv_ioend) {
> 
> This needs a mempool to be deadlock safe.
> 
> > +				iomap_finish_ioends(ioend, -ENOMEM);
> > +				return;
> > +			}
> > +			fsv_ioend->ioend = ioend;
> > +			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> > +
> > +			fsverity_enqueue_verify_work(&fsv_ioend->work);
> > +			return;
> > +		}
> > +
> > +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
> > +		error = blk_status_to_errno(ioend->io_bio.bi_status);
> 
> And I think you always need to do the offload because fsverity can
> synchronously read metadata.
> 

hmmm not sure what case you see here.

Without integrity:
For data reads we get here. Here, while verifing data page, fsverity
requests reads of merkle tree pages which WILL NOT go through this
path as no read completion is done for them.

With integrity:
For data reads we get here. Here, while verifing data page, fsverity
requests reads of merkle tree pages which WILL go through this
path as they need integrity verification on the read completion.
Therefore, to use this workqueue for merkle tree pages integrity
verification we offload data block verification to fsverity
workqueue.

-- 
- Andrey

