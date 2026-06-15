Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF943EB0F2
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 13:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529147; cv=none; b=aFRBNC1BgLih1R1q8z3Xyhi/S6O30YOAbNCETxhgLFjlXTnifB8eXVGQTW2BT7lnMjHUcuflKc7agUnwSc3SjIkgan78KbGj9RQIMdCeS6QBEcxcYBD6bm3rZxhlNmJDtT4/3dz9d8W0AlEjifP5mQRwjryRXX0efK4NnNPvsg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529147; c=relaxed/simple;
	bh=DiSjxLpXU3snVqmUYEO6GDTd3fPSbfFGaE7sP09am2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdTk3MULhyltoP962fBUP1dKMt78tbFwzdnMAtdWSBR5DGTbovZQEZNNTollQ9gycdj1SX88L70pPnDDNWwPa4DDbZBMffOPvUodzPJ0UeMVASZyLJVcofrqKcXK5vI/U/93O9rlnORdNUmDiinnvTnZY1F1ZyjjL2S6VfWFkh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltborPM9; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltborPM9"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aa68d9d4a3so3733971e87.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 06:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781529144; x=1782133944; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T77tuf8668SRSEkFMJY2zrWlfBIOLK5mmqNvu173HxU=;
        b=ltborPM9tqiJSFbqMlEY74VbGkdPh3Px+G+3mBFkd6ceqOqwcxgsyca9CORjUQvOTW
         BeLIq9qvfwhSF80hjxIWK4wHKrfu0hqodyta9ZrhRQ1y0GyKx5YU7DRpHpPNiB3+2DYD
         mg71dbC8Nye+vP44ylS7TRJ4Nca2HbDWcw4GF3PNovFvBuVEbjxMB+Ptt1JIJsmhQ4iU
         KMQC9FWgCHT+eliK8BC7mlujwO9ntmWk3FErYObjOnORFHKcP4SRlhDbv+vfyQfa2K6X
         vXZliFvb8cvSFCAVt+GM2ZbZPqOsq0sCl4c/L68X0ViGVmXN5BNZpcOR7RBGSSxiosyK
         rsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529144; x=1782133944;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T77tuf8668SRSEkFMJY2zrWlfBIOLK5mmqNvu173HxU=;
        b=GoazSCywelE8/ZyKYegVRM5Tnu8+c/l3OGOyJfMRJ1S+uUtSAWHC5a8z9f+F/13/Ia
         BGmfzIIePokcL3fwE2ATMuVvBQdOy09+DLpP4ac/s/JJf+NGYoGDpmP2U2hSqaX4hyd6
         6SbtuZ5JXKt5PLV9HCLPG6heT71C9Q+CevVRaJNIldmzJ8oqYU6pH4dU51h4qnrZC41i
         2/w3NZM++hhslfO0QdC//ORok4GXt00PkH4+VfowVRgbKf4AJ9mn/zeAIokc+j07RXo8
         e5sooXfvacmI1kOMVcXfu2Gcm2VpkYO4XXNRQElPJDOoD9b7/awKkft+pRSmpVHvR3W8
         +V3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/oWYxkj3OXMLO+eqovxSa3NKDULyN+qR19S2WcLHP+1RXFYZl1VWVfzmMxnuR3kQmfPkh47HyIfY+bqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YylUV2N+vDPXTChsnn90C0SxvKYJZfvRGl7ijyWFrAg/z2ADYp1
	37hQOEASdhV9/JuozmR9p2GLr86Czf4TTcz19JOGa7/2TxbxyG4VURyS
X-Gm-Gg: Acq92OFr5oSk8JUUfKbEbJbge0zEh8pHWta8fbjkMb8M75DnMgP4jW5eerTHQQPW6Al
	VzmwglwEBhKGVaJdhnaS6YslTT3FF9GwbtlOIQD6QF0JTEzDoFHhLmE3Bd3u+UpnEj5ZtBsNS5q
	4VEEb2C5W2i/3dAqlhdLlNJWxwKln4VuacInhmeou0ouz5TAeDcgclPbl+nEPrYHTc6tTBKYECA
	Oo4K2yfHKIHDqbFSRuTd2h0ETlwhGDyfTb0e0oqYXXMxIk8rg7Jd+tTOzWfMbcclzqrFoYZS+PX
	XusDfNg8m4gRVuS602Old36t1SZaEjUd5yQjPXagvx1QZbC3KxRn0Z3pOqQLzkw/UKN1HVky8e0
	MrcMb3u8rWjzQQ1dcv0SDDqzGKLvhUBxgmBne+v9EL0+lYx1JvCcAehnQIi05VgS0lDs1k+bYzY
	YY62PhpSEQVqHGlNoy
X-Received: by 2002:a05:6512:368d:b0:5aa:8823:e311 with SMTP id 2adb3069b0e04-5ad2db73769mr2525858e87.47.1781529144059;
        Mon, 15 Jun 2026 06:12:24 -0700 (PDT)
Received: from localhost ([43.225.189.75])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad2e170386sm2782967e87.30.2026.06.15.06.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 06:12:23 -0700 (PDT)
Date: Mon, 15 Jun 2026 16:12:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [bug report] btrfs: fix corrupt read due to bad offset of a
 compressed extent map
Message-ID: <ai_6MFGvEAD0CJe_@stanley.mountain>
References: <ai_0QHRa0y-_d72k@stanley.mountain>
 <CAL3q7H7h-JKNLrdjbHHACvQpyCGbCwQiHr1p_GNxqvmp+QH3bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7h-JKNLrdjbHHACvQpyCGbCwQiHr1p_GNxqvmp+QH3bw@mail.gmail.com>

On Mon, Jun 15, 2026 at 01:56:22PM +0100, Filipe Manana wrote:
> On Mon, Jun 15, 2026 at 1:47 PM Dan Carpenter <error27@gmail.com> wrote:
> >     957         /*
> >     958          * Try to add the extent map but with a search range of [140K, 144K),
> >     959          * this should succeed and adjust the extent map to the range
> >     960          * [128K, 144K), with a length of 16K and an offset of 20K.
> >     961          *
> >     962          * This simulates a scenario where in the subvolume tree of an inode we
> >     963          * have a compressed file extent item for the range [108K, 144K) and we
> >     964          * have an overlapping compressed extent map for the range [120K, 128K),
> >     965          * which was created by an encoded write, but its ordered extent was not
> >     966          * yet completed, so the subvolume tree doesn't have yet the file extent
> >     967          * item for that range - we only have the extent map in the inode's
> >     968          * extent map tree.
> >     969          */
> >     970         write_lock(&em_tree->lock);
> >     971         ret = btrfs_add_extent_mapping(inode, &em, SZ_1K * 140, SZ_4K);
> >     972         write_unlock(&em_tree->lock);
> >     973         btrfs_free_extent_map(em);
> >
> > This looks like btrfs_free_extent_map() frees "em".
> 
> Nop, false alarm.
> And that's because btrfs_add_extent_mapping() will increase the ref
> count of the extent map if it returns success (one ref for the tree).
> So until the extent map is removed from the tree, we can use the em
> after calling btrfs_free_extent_map().
>

Ah.  Thanks for taking a look...

regards,
dan carpenter

