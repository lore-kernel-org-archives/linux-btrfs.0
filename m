Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876838;
	b=fwMeY9HjArcqaSzbE8RwpAzRKFRzPZEXe8RlAoKwDwJ4bdh+wLU0oNzpHqEmKM/U0TxV
	 ElhJpL2a/nL5DR0z0VXic0hHnc+3Xeec0TzuXYpRPjXQ7EGXMEeD1caiJufG/FPp5kiK8
	 TLCTEToMQ/M7WNjGky4XvuuM87FVuhQD9I87jrbZmjWCO7xSQmnzbnqdhaU+L+Q3HcqhL
	 x/yQFspyIpV31fVX4HWe+ZUK/2Iqawmieup+MSFTkv94dX2v5cgifoxy6hkC6NWPAaOe8
	 zHBVLSiW8ZqrcHEdGe7FxHQfZR10KXtSfTTTHqBcsC3qGDzEliPKBlpAJQNQv5gFGuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876838;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QZO+JLG/d7uoiPf5v2wfUIFylocd4NsOfLOyggBPkUk=;
	b=F/kx6eODFuAYlbGNaRjZECgxiuMtPf4AUz4xa2b29AxOcoDSxprZ5UdSQwh2qE0NxyTu
	 lYcAEcyef+6ol2zqCsXQ0D2ozQJBWDB7A+4POiacu+aoNtLuaqlrSdhMX2jJd2asEQr0I
	 lGPvCbqtnJw98obAQJXd/g/wyHOKGG3nUh/F2owwQ5FOOIuozQheUqA/fulcWh0bS8gQ+
	 0QJ1ruuHT0X7IVRZT3IMqzDRL5lQCSdEvKbRQp5LvkzcW0gYl3GfrqmSPSzELPjWiTPu1
	 toAmvy/oTucUQJ7HAIaGTYMRyYE7Wp3vbmq0rtjsIq4/njzqQbqgpQJsiz2hM42gRxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=debian.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AD1606D83B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 11:07:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4AD1606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ac9d666d4eso20887947b3.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 03:07:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793876837; x=1794481637;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QZO+JLG/d7uoiPf5v2wfUIFylocd4NsOfLOyggBPkUk=;
        b=nPNME5d3ladYv3OMAb/+RXIBdvAEl+BwwuXIWbcRNYyj8EegxnKXNeDmi3dXo4/eKt
         iNKdZ9I2m3TH2n8VUhs3jc5bE148FQIVb2bD5xY4rN5Qe/md+PEkwfCqPFdGTRsRX2i+
         0WddoUoCSBE97jB6L5rN/RgRuo1DR186+JJikbHVPoSqFWkrTzXoyTgULLcD/JxV78if
         5dtq63Rs4QndJypFXOIAADCRnYYi91DccpAc5o3cnfsyDFSaiDI82xL/FGySLVcGL3N3
         Z+O4o0FXyyU87Yb9JiHqcNGi/sd5/roocuB4+fRKuscFdomjrrJzTidPGwlvWF73X3iM
         hVjg==
X-Gm-Message-State: APuU4Z+gDYU1FPrxP6+nGsx7B3pB3SHasqmI3apP6xtGxWbi21Jj/iO0
	HRsiMGrlbNI6RN5Mnt3uRZ40sb93M3U4LL/IkiZPNzaqcMcCIi3zQNYFtvTMGw==
X-Gm-Gg: AYBFou2bw4D0w8e6dC7HN6LamlzY1ckbA+soYwv/TG8Yrk3YE7L4jiiKw4fMz2g8+rg
	nEEvAs451+oZhMhLyHxyUbA8pOcRMg7O/bDo/ym3J2H+c2wnW4PJ4VnwQ31P+Map1tEN8W4xyHa
	ZfEkx1DcoVSAdr/b9SRwUT0GUb0NcrznYveek/7my98N5q0q+38zLI4f49iUlcqC4Z+k0mUX5ED
	i6ydzOOMFV4wnbe/4sMOgV5s49TzFoDJgbNdwfm4alsaX0o/i69c+1nYaDaRXhDBenata21clhX
	6pe6OhGUhlhQ1cxb1RcbnEQjQ5axqtz4tcS+SAdclM3cCjJ4e0r+NkV/NFljs6NPhlDSY9SUUtZ
	/8MDf29vR/qBKui3KC5MJJOQ033oemZu0Ls3aKsMIqOo5zvAEy+TrIjrSJPRDp77QDlY1fCtW1I
	RLMeLfbFG2K5CLOGrFDOx9jAZnSwsT/xmauU1+/F7LuawoSvtNfhkILEwKHee0zcFW4w3iRC085
	iuYt4H9sw1jZehf7EUn2ekm809E0yHLY3IWEkrDP/cn6ghQSqOoQhOmtqIlo0RrMD6BvzECLLHW
	Apa6nygtDcXuYmh7eA==
X-Received: by 2002:a05:690c:6604:b0:8b0:ce9f:2993 with SMTP id 00721157ae682-8b2b65ac376mr117929817b3.5.1793876836664;
        Thu, 05 Nov 2026 03:07:16 -0800 (PST)
Received: from gmail.com ([2a03:2880:24ff:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309711412sm37461317b3.3.2026.11.05.03.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:07:16 -0800 (PST)
Date: Thu, 5 Nov 2026 03:07:15 -0800
From: Breno Leitao <leitao@debian.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a race between reflink and compressed writes
Message-ID: <auxi6zhiCK1Ss_JO@gmail.com>
References: <38f007be87d8d8889912b9be373460e32741b9b5.1793840873.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38f007be87d8d8889912b9be373460e32741b9b5.1793840873.git.wqu@suse.com>

Hello Qu,

On Thu, Nov 05, 2026 at 11:38:00AM +1030, Qu Wenruo wrote:
> Do not clear the folio dirty early during compress_file_range().
> 
> The early clearing is done through extent_range_clear_dirty_for_io(), so
> remove the folio dirty clearing completely from it.
> 
> And since what's left is only checking the folio write protection,
> rename the function to extent_range_check_write_protected() instead, and
> slightly clean it up, so it doesn't need to return an int.
> 
> Finally since the range is still dirty now, all run_delalloc_cow()
> callers pass @pages_dirty = true, we can remove that parameter along other
> involved functions.
> 
> Fixes: 1d2fbb7f1f9e ("btrfs: allow compression even if the range is not page aligned")
> Reported-by: Breno Leitao <leitao@debian.org>
> Link: https://lore.kernel.org/linux-btrfs/ause7k_HjzUWT3D-@gmail.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Thanks for the quick fix.  I ran the reproducer against next-20261104 with
and without this patch, on arm64, compress-force=zstd:3 (compress=zstd:3
for the compress mode), and CONFIG_BTRFS_DEBUG and CONFIG_BTRFS_ASSERT
enabled:

  pages            run.sh mode   without the patch       with the patch
  64K              clone         stale read after 2s     clean for 600s
  64K              clone -d      read-only after 2s      clean for 300s
  64K              compress      stale read after 2s     clean for 300s
  64K              inline        deadlock after 32s      clean for 300s
  4K, large folio  clone         stale read after 26s    clean for 600s
  4K, large folio  clone -d      read-only after 2s      clean for 300s
  4K, large folio  compress      stale read after 16s    clean for 300s

I've also run fstests (-g clone,compress,punch,fiemap with
compress-force) give the same results with and without the patch, with
no new warnings.

Tested-by: Breno Leitao <leitao@debian.org>
