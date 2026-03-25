Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EF23D1CD0
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 12:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440231; cv=none; b=RbB+6NCDMQjSZPsfuOYqhgScVnu7/8A3K9dWD9tHy/F619AIg5Mcq/B7rw+D1nWktn/stGx9NQsd+Z72vwPjz6a41r3SnnDfTnVYWiQvy9AiJCqOFrdl0QpbFT1JNtrfOrRr9faTG5aqEfIB8+EfbdEm9fClxV30VTGtYv1X04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440231; c=relaxed/simple;
	bh=Es77No52KNJFPGo5T/ww8er3pjI2J58fF+DFC1d5WKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVmGIUZ2luvl9WxozttxXVMWX8SR6CZ8bqeetYko0D4Ll63C3aO0+ipsTrjYFHHXqps2Gg+GC9U1eSIlpHIsrL9DquIS8Q8fGFk4uMDh1TnOeQp7NTLaEzaQrwsJf+FVaZJX7sNI+pF3RasEq/0yxisDDCA6jzk5523J51YuXh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9cD0CZ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPY85kNK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9cD0CZ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPY85kNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774440229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
	b=J9cD0CZ3VnTBi4AYf1rhTaI0l45BftVx0t7Y67wyFAPVCuBjA9p6RpRuR+zsu1pwvNX9sF
	PTP7hTEOtnwI+xtLsurnN8t+M4bQhBhgDlgzPTcCfRmzBb1dixi6ehNa28Mwf20gh6+RdR
	1VPk/pISlNNVWUxXGs3zDcyOCxJVZso=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-yzjqtRC3O6Wmui7NZn8Rzg-1; Wed, 25 Mar 2026 08:03:45 -0400
X-MC-Unique: yzjqtRC3O6Wmui7NZn8Rzg-1
X-Mimecast-MFC-AGG-ID: yzjqtRC3O6Wmui7NZn8Rzg_1774440224
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b8fbe7a6f41so202266866b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 05:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774440224; x=1775045024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
        b=UPY85kNKISxwUNJaz9fXarSB972DdMWQEnPwXztyKjQ1HH0D4sH480T4KKq+SRtwqw
         qoDk5VVHoj8UJRdfYHT+TSAGYmwpXcqixbOJ5DZ1+ZEXPYuB/1f98YTobC54Tii++3jy
         HxCfodC7sj6qShUYp+Kq1WE0MrlY86OVZ3ykJVqmh/RW3xSNrZULAimQeTWEUr9A0zSH
         JHeE7mJyO+Gw7nIQrr7Ar1lVXExGDPj+gGjrUFzx39Poi+yGoB+RrKKrNK4ASwlVc/I7
         smzeTJT8Z53psmWcQz1HHHHwTezoKmWuuKl9FgjZy3Y8+Jgvyd9JgxG7XpBA20gSRe3f
         QW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440224; x=1775045024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
        b=NkdiFUabndIuNa7TrG21FeeD4VNQ4WU6gPbU1IsH69dkEHEQ1kNheKyTecC21fjErc
         ZCEYtlxLfTw3AKf2QyvQF2GbavxIJo2hG5SOozhQk6HDjrjbR09W0qvcJ+nX/+R1L5AW
         ASvhoXFzUXNTq0Awfcl9F/5GaPuVJA3AWMJ2gsAdX8gp6W6zXZ1Azb4zou5fJu8CgjW2
         4VRUloYg1E3Uk6V4kF3EfKKAZbf00MK21dA+bdcpCgJDzcGo5Z8Pu1MsMw8qXAQuetao
         JbxJEuHAjxYQkPdq+oRaT4XKiY6sXNC/s4EMmeF6oPPQWdv++AU1B2nOVWZilkwxydo7
         ENqw==
X-Forwarded-Encrypted: i=1; AJvYcCWvyls8rTEhu54LtLqqwWwBk3N+1PEtysjg0DGb1cbRyIZ2TH9WxPy1AVOw3AtLeV9fPVn+XLDBWbfFDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpUBEtjei/q9SIb2Fb/hxsQXoMPsFDrc6PbdcG8bgcPjHdFlMb
	eHUFSuGM4tjHMsFIUbtZqeclAnq90dvp2SpPBnjv4KbxkTjM+N6UHJC7H/Io/Sy94Bxrd7fLa/s
	v/jCsXDGFAmbOXHaXPIA89gqi6niavBAkRNuRSg/4qQZyvy3dgTyji8LMWRrnUKo=
X-Gm-Gg: ATEYQzwV2LmJzlmZ5BEtR/fZ8cn8t+ikG+/4m2tf6dpxWmk7ChIS6+yrwlDqJiAu1yi
	llPLWYAtVnrVsGOixwP8VSaQONpxNA/9jmAKJ1ao5hqgcj+3Lr5VxK6zi0ncX7iBrLWsQOEuTxf
	jM9ioHWUY1NaEMyG8rErUrgy1FnTzI8/5Zw78pRNItxFgD4xafqLb4vUHVgQLxmOsjdook1PVKv
	aQRLL4xLeiKUnxeGLCFSR59l9MDvyYnMbPZQ1m9X+elW5/jSCdXzoHx1GkE3KCBg85JmuYGDVMX
	E2mD0vGLFYRBLKXYL7tmrNQsUFH3AMmN20w838/73/Hf3rgWXAMfr1pPVEXfhYPvhr74rB/JdN5
	/OP+h/gKFmEWFAQ==
X-Received: by 2002:a17:907:3ea5:b0:b96:ff4f:11ea with SMTP id a640c23a62f3a-b9a542834b3mr225195666b.41.1774440224216;
        Wed, 25 Mar 2026 05:03:44 -0700 (PDT)
X-Received: by 2002:a17:907:3ea5:b0:b96:ff4f:11ea with SMTP id a640c23a62f3a-b9a542834b3mr225190866b.41.1774440223277;
        Wed, 25 Mar 2026 05:03:43 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b983365a159sm760453666b.44.2026.03.25.05.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:03:42 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:03:40 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 03/25] fsverity: generate and store zero-block hash
Message-ID: <vatqzcvepp7z6iotzayuyh7fajwdqs76pn4o3sdn3f5thiwsjc@dt46ylrbjnkp>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-4-aalbersh@kernel.org>
 <20260325075700.GC952@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325075700.GC952@lst.de>

On 2026-03-25 08:57:00, Christoph Hellwig wrote:
> Shouldn't we still try to get this out of the fsverity_info first?

I don't really understand why, this hash depends on salt (inode
specific) and merkle tree block size (also inode specific).

-- 
- Andrey

