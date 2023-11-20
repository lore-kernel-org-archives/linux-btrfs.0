Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="NBkiAhqF"
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EE0CD
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2023 09:05:09 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-db048181cd3so4455781276.3
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2023 09:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1700499909; x=1701104709; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dPwJZNCQUEK7opKeTDdyKI6zQoAZt7yv1Z3KXSg1WJk=;
        b=NBkiAhqFqePygRWpPLuS9ssAfktG6eShO3eA0RYOPoKltA/Wr6+EC/cgkTAGxG/irs
         1f9TJmJq1PNfxPtm4kVA/fHESH7GQvFPklH8+EcplvPwh9LQq6mz4kIk9mf8BaxN9EIf
         GY3UWQPKwEq2+wsMGRkBFNJuVSSjxOCimp9Z6tQUZMuYjwU3c4kGZWpcdP57IJddO1UM
         npN8NrOv23NtMAhoylmInduhP4g/GcVahIH1rnklVxXwXKUdvQWakf1i1e9CnDU3i0Hi
         16zCibLsy5qgeQv+ltrtf3S9z6o3LZKvr736GLAx/t+lw9aCgopLlh9r4PUWY0Vma0J2
         tXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700499909; x=1701104709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPwJZNCQUEK7opKeTDdyKI6zQoAZt7yv1Z3KXSg1WJk=;
        b=IAT6Bl0SLHqjFSVRVGJjcEXRc3URxVjigaRT3XxAKcfK3W2XiHKWcaqPgZ2o8n0/Bo
         HfckZe4zSTcL2+0PUQiyl95x+7FH+nxdbR/gICrFwUktvn8deh9iy+5x8t1LHvodIZrq
         XKJ5mc6iSQbFPnckPTPakg94zwZW3hnWDYYXP1PTkmvRaBdd+BKol4pwfCMVfNAuZP9f
         kwYVbFY35cSMKJXdDh4TWTS+p6vtHwm7f2pLGzWbqWPn64bOy/HF2ZGq5G6cmaNfVOZn
         znsIXGiogNF9eP1fHVpJEIiIDkZlIRxR30keyV/VPVF++gqC/kTZum2fyFLCToyWgXn7
         xpVQ==
X-Gm-Message-State: AOJu0Yy0fgLGhMaXoUPc0DFoh8EQKS4OJpT81NQjFMlbcF5Bf0b9H0R4
	mGjszKktCAuRC3mvOCOjDfYQfQ==
X-Google-Smtp-Source: AGHT+IHFUw/GMMpBZ5V5YHPXtCPs/zIKWWt0sITng8Rpks9EQ+gKeie60T7sXjsxcavgz+oxnJABLA==
X-Received: by 2002:a25:25d4:0:b0:da3:b5dd:d9 with SMTP id l203-20020a2525d4000000b00da3b5dd00d9mr6952560ybl.39.1700499908886;
        Mon, 20 Nov 2023 09:05:08 -0800 (PST)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 133-20020a25028b000000b00da034601e2esm113236ybc.52.2023.11.20.09.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 09:05:08 -0800 (PST)
Date: Mon, 20 Nov 2023 12:05:07 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Pool for compression pages
Message-ID: <20231120170507.GC1606827@perftesting>
References: <cover.1700067287.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1700067287.git.dsterba@suse.com>

On Wed, Nov 15, 2023 at 05:59:37PM +0100, David Sterba wrote:
> Add wrappers for alloc/free of pages used for compresion and keep a
> small cache (for all filesystems, ie. per module). This can speed up
> short compression IO when we don't need to go to the allocator. Shrinker
> is attached to free the pages if there's memory pressure.
> 
> David Sterba (2):
>   btrfs: use page alloc/free wrapeprs for compression pages
>   btrfs: use shrinker for compression page pool
>

Sorry I thought I responded to this last week,

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef 
