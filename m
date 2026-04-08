Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3392E2192FA
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775686701; cv=none; b=WUUKF4wytbLxiqh8tM9kaXaVOfxI5/KrWECe/jje5gEQQhbQM7JbrtJ9j8iNETB6xY8BqTaHqL4HDumBPaRDIZ+EC5ER6VhuEJNs/8dFouC3sBef2f1FktHUlI/x0iZS+chpoJFWz627n1VcTwOYdgt1BOQAv0VOUpgPwI2uJ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775686701; c=relaxed/simple;
	bh=6yWVkbktK4N4ty4TeM43vkY/SAwSBk+FoqB91SwvPVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPCabtF93CjeJbnaET/8KUB03A2BpWsX/VAcRYPg5hcLpzMeTc89F8DelswkUC/7kj10H0EI7KzL6hyuqX1BdlUt6AfPrnNjyyC3wRg0vALl/bF6uMDz56Esd0URSOMIPqEIc6ezYJTv+loXcxCdAF/Rf2aqNNsYrOwleES5fOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBdZEhme; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBdZEhme"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4887fd35e60so1339675e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 15:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775686698; x=1776291498; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8OJU7y2U9Z2hY/Ev0vivVijyXle887NQo8fIojsYc4=;
        b=NBdZEhme/dwWxTjjYbuWoOt6OnUx+7NsYPvkwgHy34dQvvwlIDorqtfZ9nvJ7PWbpw
         3E/8X2fBwwSbieMi3NjYsM3tj/nAVeVuP0P0rGbPh+yg1ZLMUC+8lpD/+3Ry2eKvnqph
         1Oas0rwbtfq0EkltuaF3vO+H06wVq8z/0yY7Db+brYhf72CI7ShwCCrSUO3iSjZEXTNt
         b9zpby3SnXT5UahqkrKBds4l4VpPK8jTmxeW+6Z4nIFWxkY6QM5zzyE/JiAfjSd0m4yG
         VZJY/s412QBsQEkFiZGkMtDR4lNJRKGPmk99iH+pz5R1mmOGJic1nVnVt+3kpGVzW0KI
         SwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775686698; x=1776291498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L8OJU7y2U9Z2hY/Ev0vivVijyXle887NQo8fIojsYc4=;
        b=AmQzMp5nhqwG3dpgACZBQTvUMheFeLW5Cm8lYva3WVOyCs3gW6kg+SVBwlbNbwvyaG
         b6+3L9RHyRqBz3yLGzFdeFFcQBkE+FconASsV3LTbmio6zM9A/cGBpBNz4sJhtyKky4q
         GNHLTyQtDgLILm7Ijj27MF0IdKDusz4qYgsCjg6GX+Y+h7pLMoEe+VJqW5fP9TsGTH3K
         gqGZEEYTFb7GXp+rsIIym8CuYNsk3WZAq2AQCNUzvc7yT3ljKOk19gfeQG4Qbv4QqdLb
         1aHtNlcBREKC6ZPe353EIPwg8eNLsZbo4kp40z6mZPnro7LFQNeRBGayVi+YrhKPuC5k
         YXOg==
X-Gm-Message-State: AOJu0YyLyOij2bmsPA0rw4Gqf4yJ9quRUKYkMXxpwAgG0SkK67VgNicV
	SMAILMcjnPs6rD5nzCb11I73+Z5bVylNzGyVXQAL1KYfEKaWeDP5vGsZ2MlFHJHIbgU=
X-Gm-Gg: AeBDieuZ/HThTWBN+HHgGKwUHTJTiSiKwgrcXoy3WL8AApGBsQmvMtcZPiBeIZvGr0o
	+krtiaHA4NwCMT6PgTl7BOlKTlwv1qPTzfUvWrzHeEDuHAIh8DvQG71EHPlsIgbhdpzraXu5N+6
	fLOgXCJ4CDo8Lwfpr/cE8XS4uZSwUcoWilDnktkIO8S6wL8N7QDqwRT33YATaeHpE+G+WxTCnx7
	COnw6fDIZV6leK7cUZZ9pYOfjcOiGs4ILcNSS1yDIyasgFqKME1+x+1bUjbEe0jqEPxb3qYo+qF
	bfU+K/5uOD+qNHB9CMR8ObMZxgMplsVnG426vTzknjb/UrRp4sNJce2AX7sgtqcciBpRPY393YW
	r1dxoV+v+Bv3kt+xZyBURtnCHKmbKJq/q3ZEwPY/A2O9ZPRDGAh+d0IVHucI722KHL1mHin9EGk
	nQbGh+jXyBtgxAoEfYusKHH9w=
X-Received: by 2002:a05:600c:c0dc:b0:486:f4d2:eac6 with SMTP id 5b1f17b1804b1-488ccf71199mr14689815e9.13.1775686698399;
        Wed, 08 Apr 2026 15:18:18 -0700 (PDT)
Received: from rabbitArch ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cfa75ae2sm5667275e9.14.2026.04.08.15.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 15:18:17 -0700 (PDT)
Date: Thu, 9 Apr 2026 00:18:15 +0200
From: Teng Liu <27rabbitlt@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>
Subject: Re: [PATCH] btrfs: warn about extent buffer that can not be released
Message-ID: <adbTGR5OfU6Bxfsw@rabbitArch>
References: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>

On 2026-04-05 14:26, Qu Wenruo wrote:
> 
> Meanwhile if Ahn or Teng can give this patch a try for the existing
> use-after-free problem, it would be appreciated a lot.

I tested t his patch on a QEMU VM (kernel 7.0.0.-rc4 + this patch) with
a forged corrupted btrfs image.

With the patch, it fails gracefully:

    [root@btrfs-test ~]# mount /dev/sda /mnt
    [  107.497290] BTRFS error (device sda): parent transid verify failed on logical 1081344 mirror 1 wanted 5 found 1
    ...
    [  108.302268] BTRFS error (device sda): parent transid verify failed on logical 1228800 mirror 1 wanted 5 found 2
    [  108.302730] BTRFS error (device sda): bad tree block start, mirror 1 want 1245184 have 0
    ...
    [  108.306296] BTRFS error (device sda): bad tree block start, mirror 1 want 1392640 have 0
    [  109.098136] BTRFS error (device sda): devid 999 uuid 00000000-0000-0000-0000-000000000000 is missing
    [  109.099635] BTRFS error (device sda): failed to read chunk tree: -2
    [  109.998476] BTRFS error (device sda): open_ctree failed: -2
    mount: /mnt: fsconfig() failed: No such file or directory.
           dmesg(1) may have more information after failed mount system call.

No panic observed. Thanks!

Tested-by: Teng Liu <27rabbitlt@gmail.com>
