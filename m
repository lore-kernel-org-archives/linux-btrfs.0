Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06193FB7F1
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114464; cv=none; b=df3JXsO/be7XZYxCbe9NHs1VyY8HjQUyLiXQF70JMNrzMa946yp9b0MQZBI+gQZ4H/xeG/4hn4WPPjqh4L7DapVAP1yCq8JwDEhkzS077Jw54LsX05LNBx2Knp0Ipd/sXm0JfjbMN5egffp+nFQBNf0PUEqa/dQZ0JNG1xLGrXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114464; c=relaxed/simple;
	bh=56sWDZSA5ZNIBjB/oNotI09lBuHC1nOmFFOAgN/NOPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZgeHOiPIyZtOkcdDquA0M9ZF3PsIApt0/3nF2TBEoUGQvbfRrDbhsDWUvcc6e6v0QZINXeZI1dhwSk0+AbJ+Eo9f3zrS6erS4C/xl/XQnNuWPpzb68R98idl18z78qgcMxfeGYE0bG2CT95xAWOfmWQATLxtzKI/znyDDseD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bu1YOoyl; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bu1YOoyl"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3697f25d26eso1042696a91.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 07:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114460; x=1779719260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOAvfoTQyHNmhGQizKaH8ZeJlbp3fMLtJxwZtNlPMco=;
        b=Bu1YOoylQdoXGLSRGbc+FeNPAdYEXONPajxy10NEJ9/9pem+7ErubmIHLK8qYHYqbR
         M9BcN8nJmIj9WAtswHFYnL41+vyl/oFZ5K3YYQTU6yOhp10dNa3Z1lYLr9RYJuZ8bae9
         vu8SSalIxPwdicF3Zt+ROHKsdie6pYIpImxqhwsRcK5iQifVWH2fvg0LeJdH2wnnK1Y3
         C1Wxa+aZKUHS+1rTDROoxNsFgUe33Xt078+IE71KxRQXCZnLqpzTPqUOKUhUYNFzUKjB
         0Jf3BvfUG9VhqMRWI4UEOVIk0UPl+KDa3U/n3/H6eiydgdOwxwLziIPa4atUWkdVBo/v
         GaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114460; x=1779719260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOAvfoTQyHNmhGQizKaH8ZeJlbp3fMLtJxwZtNlPMco=;
        b=mdaNNWpaUpdCc2PWYLQO7nTBaoYx8KyyybZfAxpsY0VzT0h+bzbavTVhYu/CTX/JLb
         9I9+GrjebztUAkyHvovv5ReJQLzhCg6CPz1MtgbMrvO6IpBaFhK8sCxcVNh7WpcBXZ5P
         ndr9tpgsYHhS22VA6GsPAfaVmNC9ZzakapoQHksj8ANw29Rw59Z5/SVBgdcmXHInEhLk
         fC1dS7DkWno/iHXY+ch616CmSejUQ3/s2hOf3jgf5QdKHHNo6MzNzuY9gBzQcfCYxuuC
         2dnrh3BA7bVPO+//t3DIG37bjKf5ytRFVL+1QY93l9BMPTCKLia2F+8NGXB9DrGUNFA4
         k1uw==
X-Forwarded-Encrypted: i=1; AFNElJ8mklkTgU+hGXfjq4z8mZImaKUP2J/XKRH5/VsGVEoXn9h0gs54iN7wgy02BxqO57jzIlsP0Ij6e0K8Xw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yybzwcvj4BgkJyaRLbepKf5F0tmTUHB0NRywLcJXx4lDG5lJkUv
	772q4hhAqPVzAnHhVFuq9a6cV26FypJrYZKe/IbRVR7RcIPj3bqO+ixl
X-Gm-Gg: Acq92OHb4rP3jjX9h/K1Dw//fxYSxI91bvkmsJlMpsO1m+mEXOD1/jdRFqWJtBMf9Jn
	nDAAr9hyC1e474gCDwEXQLW4pSBU5bsmwkxPNemMue/OY8GQGom9ZmTQMnp7+HqKG7kef5grf13
	/yQUgu5gnMwNcMXSUS+LhNATKD0zDoE1ahpurBrajQLfCGto+D6Rk0tRY9yQPpaTv+6FT7SZfDZ
	6dXoKao10fxMvBa8AhIHxN/h3G85pjWWU0FYEfCHVW9NkBZ9UGd/0YJ+ZZOFPMN9snW5hyf/b/x
	0BkM1ZfHf3cLGJ5cX/RKBfgze1j79VfQFqAk7I6k+Q8y/YxRdcIouRhiGtitGqa/dtz0YOSLq3H
	NZn2F1GsqQ5LRHD1IRZ/UOj8GRx1C2N2f0Iq9ZTVrhtYuCEuGrGGIcJ58b/MYMbYWRdXEHgbJ0v
	un2sofQcmIuy85F76lda7wRNz+CC8=
X-Received: by 2002:a17:90a:a81:b0:369:73a:3266 with SMTP id 98e67ed59e1d1-369519e40bbmr10216834a91.10.1779114460408;
        Mon, 18 May 2026 07:27:40 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3695a09ed1dsm4205256a91.7.2026.05.18.07.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:27:39 -0700 (PDT)
Message-ID: <e4fcacb0-ec95-4289-a647-8e85bf432a2a@gmail.com>
Date: Mon, 18 May 2026 22:27:35 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] fstests: add test coverage for cloned filesystem
 ids
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com
References: <cover.1777357320.git.asj@kernel.org>
 <agK8gc2niqpTuHHt@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK8gc2niqpTuHHt@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/26 13:37, Christoph Hellwig wrote:
> This is missing a real cover letter saying what this series is trying
> to archive.

I should have copied from v1. See below [1]

SCRATCH_DEV_POOL support for non-btrfs was dropped in v2.
Instead, using the newly added helper  _loop_image_create_clone().

[1]
https://lore.kernel.org/fstests/cover.1772095513.git.asj@kernel.org/
-----
This series adds fstests infrastructure and test cases to verify correct
filesystem identity behaviour when a filesystem is cloned (e.g. via
block-level copy), covering inotify, fanotify, f_fsid, libblkid, IMA,
and exportfs file handles.

  - SCRATCH_DEV_POOL support extended to non-Btrfs filesystems
  - _mkfs_scratch_sized_clone() helper to create a cloned filesystem
  - _clone_mount_option() helper to apply per-filesystem clone mount options

New tests verify:
  - inotify and fanotify events are isolated between cloned filesystems
  - f_fsid is unique across cloned filesystem instances
  - libblkid correctly resolves duplicate UUIDs to distinct devices
  - IMA distinct identity for each cloned filesystem
  - exportfs file handles resolve correctly on cloned filesystems
-----

