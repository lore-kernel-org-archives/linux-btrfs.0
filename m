Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083334A3D6
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 07:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778226574; cv=none; b=GMupH2GMIhWaEShMerv9JZXWC7ci4/rEU0OKSC9/9ZDu+qBPCOg+cFQ81u2MHIpk2ay04FEMXdHp1XCbM4Ru0cLAGeHH2Kdd6GD8ZK7PWjEpDGyJiepe9l1Pyk4RXd4xqMvGR833J93x1I/8OlOmNwuj1Bh7/b5qVIWaeSWpQfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778226574; c=relaxed/simple;
	bh=wAjgHClalcWLBPOeTWxQBEwJjiyoMwNQwn3gb0Nd28g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tMxFMhmAOV8JcYjZC1A8kllu3IKmXizuPT6MhtzUXqWzcw8bNL2rKq6IU9YIgYEyfQ7nAt/zr+VMvaFf/XVxjzZmLI7GmlnPoFXH+f0BkAFnixy9ZlqhRV77mcDX3PyGeNuEY3L69sg7KTKuWXWMHmeBNkcEcoE5MRfdKtAD5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N4pla70d; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4pla70d"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8b4aeddfacaso19162806d6.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2026 00:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778226572; x=1778831372; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RKA3ZB7qt6438oQMpn6u6fsoHurkfSmoYda15flNgWU=;
        b=N4pla70dO4rTwQHICtQbbwQ8b5DM6wF4jlfiACYgq3HkkapvS17oIvOSaFKcMS8+97
         nKvDkP2rUdGlPjE/GdoiOrNbzdNjdPG30Hn6WG1tkG7S+Vb/fLY4dJGoUiBA6QzAXkdm
         I4271HRVKGypAOon5rgFwoxTV43kzChNtqts463CnQO+AI9hz25KAICkknRlZ6BgBhyE
         tghXSA8BIgyhGf7qXZxnOfLIgNTsbPLLTszyG7owSC0PAScib10IeWUu3ZhRw+mo7rCP
         i/7JDqqIaATbt1URCFaa9vxs3mDf92/YFkeLpZvEXpv372oEtswgh0U558j0OMt9KWsy
         sVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778226572; x=1778831372;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RKA3ZB7qt6438oQMpn6u6fsoHurkfSmoYda15flNgWU=;
        b=msNI5szQy3gnxdGvi1scEjlQNwRt3F3TUPLqY2qZv+SdKaNxRymd3PO7x7g+5hXCdS
         3Nsi3KqIb2Wqx87BtueZ3ENUQY3KLxPlm+znlPb6H0+djX0UtATPbcObdtHVacjm3sw/
         k5sp1Y6WSZlmGRnNeuk9FJSELrMd9UNwmfEYoIP+GRWRxk6foatCmUbcRZaKvRAYyRGR
         pPbDuUxuEUVK7RCJwwjrlNVtXSddcYMR+++4D27m6fsyrGMH9sAWJo4XoThGuDf7MVEL
         WeKJN7AmI23mkH3BqK06s0OPJrNWYPLL3yObCHqwkqs6FjWObkOvC4zW2l6qIkqktQC3
         LKWA==
X-Gm-Message-State: AOJu0YwzH45HmpW2OjpQv9LR/BY+Vj6MCzkIuRc8dE92LoPsPAlT1Ufd
	+5t5HLvNNlx9lTGC6IGzfHreZqHx61MtF+9vFpoq0vh8vMnrnLtIiM5HhmEjwQKo
X-Gm-Gg: Acq92OGUiwfLDBdMcoSFwr9rJ61fWG0ZPZbtz391YDR3RfiFGVeonRxr4bJkcqMz4Ii
	DWo23i0akUJYC6/7yPFHiVdmNAhysX8B8+Gh6JpjjWkkiH7d+43bG1jnkwwfpBh5ekF03R9IJ6y
	tthKlvWax8OEPKZX+06N3hpSy9o0XYi/qBFdOpH/SN2CUtfg7e3jOUtVI62rCkAE9V/vKpbiaT3
	55lPDy9uWr4wPqS3Up5if4bpmUfxEgxbL+jIPhkLBV3lZT0gOY8XZyLoGUlbFGbmJuii7BBoGjt
	Wn4zzxrXXHqSROdAe/P68df90fibZW5hoYmAkNvXsbGLkdn6OX4tAokWJsRV1DA6hPZXeRZ3+9s
	zxaObFRwLv0E/6tkrmEhpYSkMNDRjnIDmh08MM6uw6ddx7tOflFdiFVk8tDPxI5zIGXp2VyqVPC
	DZPmzrAbEq0tVTAnMOnw==
X-Received: by 2002:ad4:5f06:0:b0:899:f1bc:c6ab with SMTP id 6a1803df08f44-8bc45750909mr170552836d6.42.1778226572355;
        Fri, 08 May 2026 00:49:32 -0700 (PDT)
Received: from localhost ([185.141.119.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53d831ac7sm223850786d6.49.2026.05.08.00.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 00:49:31 -0700 (PDT)
Date: Fri, 8 May 2026 10:49:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: periodic block_group reclaim
Message-ID: <af2VhjMA8YP8NTvW@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Boris Burkov,

Commit e4ca3932ae90 ("btrfs: periodic block_group reclaim") from Feb
2, 2024 (linux-next), leads to the following Smatch static checker
warning:

	fs/btrfs/space-info.c:2139 do_reclaim_sweep()
	warn: iterator 'bg' changed during iteration

fs/btrfs/space-info.c
    2125 static bool do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
    2126 {
    2127         struct btrfs_block_group *bg;
    2128         int thresh_pct;
    2129         bool will_reclaim = false;
    2130         bool urgent;
    2131 
    2132         spin_lock(&space_info->lock);
    2133         urgent = is_reclaim_urgent(space_info);
    2134         thresh_pct = btrfs_calc_reclaim_threshold(space_info);
    2135         spin_unlock(&space_info->lock);
    2136 
    2137         down_read(&space_info->groups_sem);
    2138 again:
--> 2139         list_for_each_entry(bg, &space_info->block_groups[raid], list) {
    2140                 u64 thresh;
    2141                 bool reclaim = false;
    2142 
    2143                 btrfs_get_block_group(bg);

We bump the refcount here.

    2144                 spin_lock(&bg->lock);
    2145                 thresh = mult_perc(bg->length, thresh_pct);
    2146                 if (bg->used < thresh && bg->reclaim_mark) {
    2147                         will_reclaim = true;
    2148                         reclaim = true;
    2149                 }
    2150                 bg->reclaim_mark++;
    2151                 spin_unlock(&bg->lock);
    2152                 if (reclaim)
    2153                         btrfs_mark_bg_to_reclaim(bg);
    2154                 btrfs_put_block_group(bg);
                                               ^^

This decrements the "bg" so now presumably a different thread could free
it.  The race window between this btrfs_put_block_group() and the
btrfs_get_block_group() on the next iteration is pretty small.
Most likely this get/put pair could be removed.  I can't see a reason
for it.

    2155         }
    2156 
    2157         /*
    2158          * In situations where we are very motivated to reclaim (low unalloc)
    2159          * use two passes to make the reclaim mark check best effort.
    2160          *
    2161          * If we have any staler groups, we don't touch the fresher ones, but if we
    2162          * really need a block group, do take a fresh one.
    2163          */
    2164         if (!will_reclaim && urgent) {
    2165                 urgent = false;
    2166                 goto again;
    2167         }
    2168 
    2169         up_read(&space_info->groups_sem);
    2170         return will_reclaim;
    2171 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
