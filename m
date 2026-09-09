Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945D845D916
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 23:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788996957; cv=none; b=o904bks52+czf7q865jNGyiGSj3qNQq7objjpP5/5mNr9elBIHDwuL70qnnF63WR15soaDpDMEHqz9rDuJvlK88qgfFC9710f4xAp8CUbbBa4KOLJQqWbgie682FE1PN7xLpHFvvbajonAnkDiwmhJcWYc51NsU5ntw02EoM2bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788996957; c=relaxed/simple;
	bh=2/FWvLxK2swVY7Lkt27lEOw4+Yh+lP1rcCDSm2BzOBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJOP2u7PLWUAo3efixlzNP65BEwsVIzSvC9Zi/fXlBCKejqxOPTLwTJ8RPLaC0UC9h4CJ/U2AhBueSZVN3PGnhOcN0ZC2mXHCbxSqfjBAsE38B8+tbQJprHXZtdcuLRgJOW/TOHwoCQHl/RCAdq9dR1dprGo6pMstwbEOnkoR/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PViaICfh; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PViaICfh"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso1376700a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 16:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788996954; x=1789601754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2/FWvLxK2swVY7Lkt27lEOw4+Yh+lP1rcCDSm2BzOBw=;
        b=PViaICfhutJ+YQf5pwd/qoi3l1rlxYUJGyJPz0sii9qCtdcbMORZOyhg/yqL0iAvli
         a+XEZNv5INYGWlqR2rHT+XqSxtwVaIt74lS4jBT2TGZoetS193DfuZNl0ln3FeC8k0We
         Gbg1O0KKdUD0HSCRLQwKpUKZMEFgJoIKSTqvqstDGeJ9rUxhqKu83lL2Z/E/z4exYFm9
         l30JwYxtcz6cIwr7ftErD/6b9oQEYQH1jzZyr+DuZDpi7mBys0Gap16GETgiEbvx6151
         v1Dq5cweYYcYJ1GSwjxVCZq5gOwjzQoZMfBd2+KCXeX1Q00N2Ph/uXwoc+uMbc79qYXZ
         89KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788996954; x=1789601754;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2/FWvLxK2swVY7Lkt27lEOw4+Yh+lP1rcCDSm2BzOBw=;
        b=GHwd3NVIEdKRq4K4C86LsV2Scl+IB9n5C3au16/yERGsr0wj2kTQXKVeUOcbne2K2Y
         zciu9tmCooyDYDBECEwXp/DF9NZoZ9nA6KvztvI1Gf9iycsmk5WYOwSn7q+s5EpcyhJs
         ZQvsVl1kFlxJD0qzopdrEtuuh+m6M3NWbDKSIGPJoQUI5AC79nRkdPufRQC0ZUnzFlVg
         GfiL8SmnH6rZ/JgyXbXL0tKNMD+aeLQiEKasazny1FT69843J4+D3YzVHGZdNTtUYtXP
         o+IEqI28ooX1YpaTrVIgGrwTLBO57DyOhMA7xeHq/Yszlg2CUgTUew7wIKzoC3t+bh2B
         JV+g==
X-Forwarded-Encrypted: i=1; AKwUvByXM0K5N24vCzVXSvxUoa02QEYaKlAtW+Td2Wgy44+ff2mFeiw4CMoIhoL+Vyt+toT/Rw1j/5lenG6A+A==@vger.kernel.org
X-Gm-Message-State: AFuF++ntecOzk10hS9m3dD1Zb60N5ULRbPjfJS9uCIE48HqD1MVxqvbC
	uPWc/xma6QjjDw4xO13PTdPQSmp00392Wj6ybfaiC/764z6abBU57c7h
X-Gm-Gg: AYBFou2H2gPEFuzTpNmARvNFXheeO2UX47aD1Fn3pFlF88Hs8MWRLBpleAU//MTrrOv
	z8QcH9lxLyh7AljQ2P0OJCqXk+t1STRZzIC6ZIadEz19amFVZMvBPcPcQ19Th51W0VRw4OrIqVy
	0QoyHGydex/v8hYWyNh1jC/rj9gGYayjl/Y/32EIAi/nvnW4QVQWUt+zstEjqtFJXjPLCjvVzWm
	TOE2H84a+5dDYm0icTqm/T0EBHfPy6B9SfeA2M+dj1lMn/EqKhi3YZcfPCfzUCQptazb4IgvQXf
	88rXZI71pHNij70pRyR0Yslc0TN4gCkmwn8znSe5Bp3K0vdRbSAAfedwiJz4BiIZXlnvrkMkvYI
	jdE995ACdObrhjWlMAMTIVSqjTklYWPO/GlWaRWDyO+bGKRI0Q+3F2YiaYt8lqcb+kdG/+7/pJW
	1zwBlHUM0Z0tBN1T7YlKGoNTVdXOFxYmK4bF5VhiNaTuObjzKfhUi2+hVPF+AH6YWLabqkO2BrD
	e4EZNOwZKPLAGs38q4=
X-Received: by 2002:a05:6402:5389:b0:6a9:98dd:afd0 with SMTP id 4fb4d7f45d1cf-6a99cd22660mr1588083a12.40.1788996953572;
        Wed, 09 Sep 2026 16:35:53 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6c20c0fsm7819222a12.30.2026.09.09.16.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 16:35:52 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <d27ef15e-2b34-4113-8913-93f4387fb48a@gmail.com>
Date: Wed, 9 Sep 2026 23:35:51 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: Qu Wenruo <wqu@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <7c331e23-d0ea-4611-9bed-d7099dcb41ab@gmail.com>
 <9ca6e653-f89e-4ed2-8f97-783a5663f97c@suse.com>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <9ca6e653-f89e-4ed2-8f97-783a5663f97c@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I think human reporters deserve more attention than bots. But anyway, thanks for responding.

