Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2495315D33
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779921705; cv=none; b=Sikp2ZS3X2BNVwE2LfpuJTjNM2M1XrHnuT5yAavr57fiErowAd/Z4r9xA+2/5AVkzDtvfs3qkMSnhVpzODSKwsIQLsriezGxtLxTCzUIC4f9Y5Y0NYzkigPiAq9As9SWScZjD7r4wdogdcQWE9yvNDGAkmC0djW7/E/Z1SyXcKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779921705; c=relaxed/simple;
	bh=LWyhWusqHr4rQgdvmPOrVaCWSEHYAt554Q0TgVqFBAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJXTQ/IMVWyJ92xEVPDmSGJU61t99YU16+BfiYOoJ+9plUyK2W2BBRSiO3BbZVAHjgbHwXWLDwGwNuXOAoIQO7KKV6OIi5pCoO9EP71yhZJP2BzRi0dPwdkaF47zlAfY8C31NIgspxBe4yfRHZJKG93SC7EcA/De76vTsOIBqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DiP3Fx58; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DiP3Fx58"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-83538fbd0b2so4996225b3a.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 15:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779921704; x=1780526504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PS1QiPPseraqYZzSGuyGeQTFkHJ1l+wgxnVan1O+b0I=;
        b=DiP3Fx58Z5VrEdwY7kjptCOepOOHDy8zV0Ac5ySjdW4f+l1+vDiBNiKiBzu636TGcU
         3sd38WaRMSNrRZa7jxWC6anAxvVtqvkF45zWGzfHYfsB63mQpm0pE2dVt0ekNpNkLrGV
         n7b8kNYbZykxiWAz0q80vZwxp1S4oPKT0vqK2gRuKayCrK9iKcs/yLF1DhugXB/yVhzr
         i+cNR7W1V1EHZvWhyp1OGlh8hOpQCMkEieT5Csk7MMjEqzw1c3aSKtzhMAqzX6fx4r/O
         lGL6DMqEu1XxRvJ60EBWZ1DIt9Te+oi3ZPE6r1i02MYAksmoVDr/RVwd3vRlv1pIFcy+
         xIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779921704; x=1780526504;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PS1QiPPseraqYZzSGuyGeQTFkHJ1l+wgxnVan1O+b0I=;
        b=A/GukSuhefoaGvm97j9gD9kc3l6SIlsEEPD/qYImpAvGyw0v1Zmlp6AqBVnEV58vb6
         hRgWsKgKomXUTRt3GcRyROMPugMot8vnY4Yt8rzi5TF3azb8DeHO1BADjXEoHG0LYUWL
         1wBFYIl+Ig1gaIJrwdeA8BktSWL/QHVbkh4xmDfuxzy7g8H0pmRoUMvjlnv47aZbsBIV
         EsIU0HavZFxcKBWrtMQIXQ2yyEpBG7/ebMnLfQ0AVlK2iJ8DJvJWOfXCDOKzxh101QO8
         fa/SQ9aR2ig/P6ptmRwH3wI05zzAJfgNTul4pFJ4R27yfy7IgHhh5cIELm3G+32sS6NA
         cd3w==
X-Forwarded-Encrypted: i=1; AFNElJ/psZOrwc88LzpO576zfUwKQDRK/54f8UTaZowKpnT1RGmO0C+pNvE+n3qI2etX1I0c01vE6fhJp0mU6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1AO7PKyIIGGY3vEZq9bvzwznLrD3aI97XDZjlUO4Qd4q6vRjG
	84m0TcyeRyd+ChA0bcaP4jPVVP6zP32UZpQowcyDc3fwVIwBweKG8s5F
X-Gm-Gg: Acq92OG8biLEOBjJI37XBc9ICFfD8i13c8x3bUHgtPCYgngRaCHMxzkMnIJSbA0WKuk
	o2poKXyj62Vza0sArkq+wQc/nN9L+zsr5tVZHKcAINlhXElAehyxw/c0xRPmNijtin+p+cptOOx
	NdFY9Ex4eMAs4yxM++MX94pGGJ34jZIsLL9y1gLD6BuYH89oE/4Xkm13F+ZTA4/4SyTpBS5dISn
	+5I/ZBGWSc2X7ZXrhbyaj6ZZWLnHR4IMZ5hy6ixukjhrRPEy9dKtk3T4blGeAeOGJ6NwVkqNrq6
	ELVlOPgmzHwmCTy2S6Psx6oovPL6QeJivjIxt+LD+YCwyx68hfEqGh9952gIOH0NSMzigGRGqo7
	8j2l7JrhrUXj5YLsqQpaKN7Xab6BbJt7Waui8XjY2EaxczeilSyRI7yOVYppvNkXB1dQCw/B7CQ
	vi4KfDFwoXk1x52TzEVhJIe9IIVkgdgm4Wtsfk7g==
X-Received: by 2002:a05:6a00:3a14:b0:835:41f3:f453 with SMTP id d2e1a72fcca58-8415f3f67d5mr21283194b3a.17.1779921703896;
        Wed, 27 May 2026 15:41:43 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6eac68esm3382981b3a.15.2026.05.27.15.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 15:41:43 -0700 (PDT)
Message-ID: <e039c677-073b-4201-8588-ad84d58639e4@gmail.com>
Date: Thu, 28 May 2026 06:41:39 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] fstests: verify f_fsid for cloned filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <a24645463979d0550e0010030995b0ed609215c1.1779367627.git.asj@kernel.org>
 <ahP2hjv9zl_WL1kg@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP2hjv9zl_WL1kg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/5/26 15:13, Christoph Hellwig wrote:
> On Thu, May 21, 2026 at 08:54:55PM +0800, Anand Jain wrote:
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
> 
> Seems like these are stuck on the btrfs list.  Any progress on that?

They are in the `for-next` branch of the Btrfs Linux repository:
https://github.com/btrfs/linux.git
