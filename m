Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05ED02253EB
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 12:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781527625; cv=none; b=A06YPKOjHCb5YW+eDsOvC8Beavqq4X8q3bsDM1ZQMtiGUuYWF1Re07uCwbtFs5KWdE7Zkh2sQ7T0RMSNTqrUv3PgT+gMXCLa5uIFGa284eqGzWLvBUuM98qTZPFgxX9QxneCU/m25k/x5NuEUWQreXaCknv9DImsxHWI0PyidRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781527625; c=relaxed/simple;
	bh=0tYQQYTcc4c+rsJVd1WHHOeopTfTdplRzU8t4YWdAoI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OULkLol9h0M8jWxVQVgmyMiclBVBSD4SasJIUoHutaJanC9OnccSAaQAe5A43fyz4iYqLp+jHZfF5G6RgNpnGTDOyL+xjdTPfRLr4PDzshOYeQB4bNXsBDxQwftBKHauglL43U3eA9nhIoUmFy51fVHfeTd9b3wgQsNgoVnviuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xn98B9PE; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xn98B9PE"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9159477c893so391681485a.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 05:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781527623; x=1782132423; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ycaXG2pFYPWbB+f8WFdmaymzDNsA1Ud1hWMHAwCkeq4=;
        b=Xn98B9PETLjGLygciS3szueJ/50HndEVnKM8aK0UOTFA16lzueDv8CWuqQ6p8La/ij
         8Y7wlKvbOlBSurBKUswGHUNd+twCu+hZk3d/5sPobHT7HYTLm7y0Xizj0mhkFBI166ep
         J3cGW0XEdnPkn8SL2o86mZDlvPjtXAxBxPBb6k4gtCbi0LBDAuebLgEaTD/UxZd5lv9n
         DW2GiXuO2tbGEBiuB1T8q8niy7SNcy5E+DTc+NiEf7BpifUu1b0vqADbbLQ53/OHbqWL
         TSThprMSXh4fP0XlTguM/BSqWjbHjhAwDd9K8QjsfA89dVd1MoSt86BJ1dPnXjPjcSSg
         H/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781527623; x=1782132423;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycaXG2pFYPWbB+f8WFdmaymzDNsA1Ud1hWMHAwCkeq4=;
        b=gYQMGTMbvidXgT4WCAoWb71OA74YKZ0v6cY6J9Nmwl2g8kzr+14oeED5FxWbN6+sEj
         7VB21JfPbCyN0GPalk3xpft8ge2gP2BLU6gpaHOhm6r7vQfbFjWUri/1CqND7g1Uhs4u
         nr35jp7NLgT9ElD68dPFr82B0iv0OdD9iXpiQhWjqADX+JfD+qOZSvTvIMscvwU0khMv
         uoW2rqC458etWYea0lcUCv14zlji3OBS4gRd0K0DlPqOxCrDuEgCK7740iKU7DZcOOki
         TNX7G3D66LOWBZKCPCIrz1fM0jogDwHNHYhmIAdrQRK46pIB+PLggUfyHxvwTm3/JaQY
         fbjg==
X-Gm-Message-State: AOJu0Yy3QLjNislbvllNthjBmM8xKDDdYUxligXdP5LctPlpBlpFgNXe
	BS8tgQj3lS+opg/cGI6TIUWKeZ7sDWutAXfBopA+P34n7e6lJPp6awx1SlskFA==
X-Gm-Gg: Acq92OFdq5dpS4Oqa5G9HrAUqg0ApgJbByxUUtXz1Jy8NJjKo5RgNQB7a5RR5J2+Yiq
	qqUvxz/vl4FScGloPS+y1VJe8Rs2xhte5iO5h4QcSuB5Z1YnGNO7WB0kfWKGWQAzpngrVxwddXF
	4JmXCjLrrTZsPc93x9UyfESCpyPVV7s8zLaTE9kAEBdeG4V95WwL/ia0W6FNqbsvjiWBIfM7VT4
	TaqFcHWTuwg4Pwi6aOUJpMuSHW2ijHT1piaGN8whcSWbyaWL1KhqHM/nYAx5L3H+AYpTI2NsKlE
	GwcfVyp0klsQhEI80aC6yQbOW2csauOmUPRDlQxOHo1kIHqbydDnrUb72bTqdiHFUTkH5Lhj7bY
	tNRe9pyX8nJr55t/+bqla45yBZ/rg29C52U8orx0njKfrvBXYT4XKgyFAk7KJuFC5YxeRshzCRS
	FIJy/5wWJLDlvSm12CDy6GL7bNwQw=
X-Received: by 2002:a05:620a:319f:b0:915:a457:bf94 with SMTP id af79cd13be357-9161bd2374cmr2118182585a.48.1781527622832;
        Mon, 15 Jun 2026 05:47:02 -0700 (PDT)
Received: from localhost ([43.225.189.75])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619ed7857sm1099264485a.4.2026.06.15.05.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 05:47:02 -0700 (PDT)
Date: Mon, 15 Jun 2026 15:46:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: fix corrupt read due to bad offset of a
 compressed extent map
Message-ID: <ai_0QHRa0y-_d72k@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Filipe Manana,

Commit de9f46cb0044 ("btrfs: fix corrupt read due to bad offset of a
compressed extent map") from Jul 11, 2024 (linux-next), leads to the
following Smatch static checker warning:

	fs/btrfs/tests/extent-map-tests.c:979 test_case_8()
	error: dereferencing freed memory 'em' (line 973 btrfs_free_extent_map())

fs/btrfs/tests/extent-map-tests.c
    912 static int test_case_8(struct btrfs_fs_info *fs_info, struct btrfs_inode *inode)
    913 {
    914         struct extent_map_tree *em_tree = &inode->extent_tree;
    915         struct extent_map *em;
    916         int ret;
    917         int ret2;
    918 
    919         em = btrfs_alloc_extent_map();
    920         if (!em) {
    921                 test_std_err(TEST_ALLOC_EXTENT_MAP);
    922                 return -ENOMEM;
    923         }
    924 
    925         /* Compressed extent for the file range [120K, 128K). */
    926         em->start = SZ_1K * 120;
    927         em->len = SZ_8K;
    928         em->disk_num_bytes = SZ_4K;
    929         em->ram_bytes = SZ_8K;
    930         em->flags |= EXTENT_FLAG_COMPRESS_ZLIB;
    931         write_lock(&em_tree->lock);
    932         ret = btrfs_add_extent_mapping(inode, &em, em->start, em->len);
    933         write_unlock(&em_tree->lock);
    934         btrfs_free_extent_map(em);
    935         if (ret < 0) {
    936                 test_err("couldn't add extent map for range [120K, 128K)");
    937                 goto out;
    938         }
    939 
    940         em = btrfs_alloc_extent_map();
    941         if (!em) {
    942                 test_std_err(TEST_ALLOC_EXTENT_MAP);
    943                 ret = -ENOMEM;
    944                 goto out;
    945         }
    946 
    947         /*
    948          * Compressed extent for the file range [108K, 144K), which overlaps
    949          * with the [120K, 128K) we previously inserted.
    950          */
    951         em->start = SZ_1K * 108;
    952         em->len = SZ_1K * 36;
    953         em->disk_num_bytes = SZ_4K;
    954         em->ram_bytes = SZ_1K * 36;
    955         em->flags |= EXTENT_FLAG_COMPRESS_ZLIB;
    956 
    957         /*
    958          * Try to add the extent map but with a search range of [140K, 144K),
    959          * this should succeed and adjust the extent map to the range
    960          * [128K, 144K), with a length of 16K and an offset of 20K.
    961          *
    962          * This simulates a scenario where in the subvolume tree of an inode we
    963          * have a compressed file extent item for the range [108K, 144K) and we
    964          * have an overlapping compressed extent map for the range [120K, 128K),
    965          * which was created by an encoded write, but its ordered extent was not
    966          * yet completed, so the subvolume tree doesn't have yet the file extent
    967          * item for that range - we only have the extent map in the inode's
    968          * extent map tree.
    969          */
    970         write_lock(&em_tree->lock);
    971         ret = btrfs_add_extent_mapping(inode, &em, SZ_1K * 140, SZ_4K);
    972         write_unlock(&em_tree->lock);
    973         btrfs_free_extent_map(em);

This looks like btrfs_free_extent_map() frees "em".

    974         if (ret < 0) {
    975                 test_err("couldn't add extent map for range [108K, 144K)");
    976                 goto out;
    977         }
    978 
--> 979         if (em->start != SZ_128K) {
                    ^^^^^^^^^

    980                 test_err("unexpected extent map start %llu (should be 128K)", em->start);
                                                                                      ^^^^^^^^^
    981                 ret = -EINVAL;
    982                 goto out;
    983         }
    984         if (em->len != SZ_16K) {
                    ^^^^^^^

    985                 test_err("unexpected extent map length %llu (should be 16K)", em->len);
                                                                                      ^^^^^^^
    986                 ret = -EINVAL;
    987                 goto out;
    988         }
    989         if (em->offset != SZ_1K * 20) {
                    ^^^^^^^^^^
    990                 test_err("unexpected extent map offset %llu (should be 20K)", em->offset);
                                                                                      ^^^^^^^^^^
    991                 ret = -EINVAL;
    992                 goto out;
    993         }
    994 out:
    995         ret2 = free_extent_map_tree(inode);
    996         if (ret == 0)
    997                 ret = ret2;
    998 
    999         return ret;
    1000 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
