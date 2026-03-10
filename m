Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1530343E9CB
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 09:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773135806; cv=pass; b=hHweQQPw7aV/G/u/M+ypAHHLV7t7/+QYgh3lzsWFTtqxN/+1Dy5yVpVtFGvDRB0WF5GrEBuScGsyB1kIAEP4HEK0OFEjdHhYuWoPOREAL0x9Ni3pkElCJyog016Z3gHxTRSo32fyEn5v9RHwr208SbVnRY0b2ghZ4DXHKBxra1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773135806; c=relaxed/simple;
	bh=D6BEttDHIZ8SMAl+BzTFPlqZNeDWk3kXgelyvPsAYsQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uzf7/6r4DDhdHBF/l5M2vkW4jTDitx1DBn6ifIG7qomN1u9GuUHFktYauw+JM2rzRmnRFOP9HPgBY7I1aI3h0JO2OZaI+ByQdat1tcM18g2MXMB/r7ce9TpdYFHo/c43THHFm661kJWtyDPlUTkyZO7U+h4MKUc7C+U0zHiakyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LvtN+Tcp; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvtN+Tcp"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-662a1855af2so2616831a12.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 02:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773135802; cv=none;
        d=google.com; s=arc-20240605;
        b=BjJHiF+SUWU2n5lGCVOaT9K5EaVmREnTtZJvjeKTiTV+zv6u0YzAMr7BcNlrLNecJ9
         VDba9bTVTsKxJztfdWV1kpytRbv9SS6Y18sOgZD25f5LVb9vxhD9Ui4S1QGS77qWGWJj
         I+plgY07wazYWcgKdGwKStDSnyDLygQxovsPhBsG1tS4VKqgkMb+uipyC4ELSX287sGQ
         09bTCO2taW6IPWlsjJVKvAWH2fXFK7XB4tjjhI16F1QiJ1vSu+0sovkahiVXTlVWQ3Gh
         9TYT7che0TuFnZiiu7b/9d3Z/3QAhSk4rxn5Hc8sNj1DEgqcogjisqrWVGFWVI8DRWSB
         q+eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D6BEttDHIZ8SMAl+BzTFPlqZNeDWk3kXgelyvPsAYsQ=;
        fh=t236rE980Lsm93i75SgHItj3/bBrzs0QcOkhd5Sentg=;
        b=cD3xzvtKfFcWAtte2vCnpsRAMoc2YvnmWNckIBQgjvYcYMhkM7JlO5iejsAV702ldO
         Y89Lx2mR4SUzXgMVIizXb/7Uwwko4onEv9ACQ+e72d7rjuF3P92aP4us/x43ZA6rbV0U
         NVHjWmDTORzkl/3XlrtBYSYBDVmxPrtR6xPNKfNzD7VdgNTtaZwOLXIJShyk/tzVIZKM
         BxiSTsEe9GnMn01Jn6ydFl+LyqfKDA10/xgXgv65olsaaNK5LcF0Zz5RJQ/GzlJ2M/TD
         nB3Yghzq0psY9EJjZcpnWtPZItIidUFLsq+BSUbdjJDKw8Gjkla1zIoer2tL8UFi8qkU
         7FYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773135802; x=1773740602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6BEttDHIZ8SMAl+BzTFPlqZNeDWk3kXgelyvPsAYsQ=;
        b=LvtN+TcpsaTHiJXKR25JYWuQMDH/Z+lJpcJajEfYQSMqMPSHiRl1XWpHqXm8c3A8t+
         rFxwpgXSFZLKiDqSTm1RCCTfGk6ChUj+Q30eyGXI3ag4s/nQS1mP/cobwAwTp31HTv0d
         8lKBweO0/mQhw/aa0t0a6kRZd+kz0NyjWfCN+ooM6o+0Cc8PwLVJ2tTh2psjRxKWN/oK
         VEcbya7g91FU0dIQYfq8HGj3Jv8jyaV37Hi5GOj5LQaLvxzWajq/nP5OUSb/qSMH6oe3
         LwHh3SrfFo5ECSXITJnHKpvPxnlTfQ3k0BRftvvNZki7DwpRFKRJDt7MN6HiThBMc4OP
         uXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773135802; x=1773740602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6BEttDHIZ8SMAl+BzTFPlqZNeDWk3kXgelyvPsAYsQ=;
        b=nfeJ/YZ7Ryl5jSqJY1QZ9g4j9hI6M9/O9LaIEvF8t92W0gTdZaus1bfSGsGGm4YVMp
         YyXTRnJu6CiQoWRIMn9zdoLLEVd+JOBCrCTBiYA/HrLt1LaUiIkuMz633zwmShiE4sPq
         T06gFl5SsYVNm4j9sGjb0S090cYtozMxsLdt7+oRK1zYqKwdW35g+i8TsPt4Aow53XNV
         wldRwSgdSiGBHX/Zri2mbXi+mv8yTCYkMtT2kSe1UJXlatbtxzw7DE/Xa3RgtpQAYYnM
         +csIpK9IbzSd63c7H2e8coOeE/EA0jbm93eybrkoGCUKHdMQpwMWtdRY6d5z0YNtBzrT
         ZoHA==
X-Forwarded-Encrypted: i=1; AJvYcCVZxb6VHuYMJE8KdyuDYbMV6HXreWS4FJEHZl2/PxYLXT00NTTTMlIIBK6O+ARjJ12m0z9WoKTTV7UCkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh+qj7p32GzQBM5w3VU5/0CUm3EXHFhDSBfXav9YSXeHGhgeMy
	Fmksj8myMPi4uojgGYJMVv7y1yIc37vguHAjdgNWk31Hna8YCFopQd1PQ9KDF9maXF6dJmxe7ic
	ZelVIt/DHG5CBfVdAxtKRKZwrYeQXK8Q=
X-Gm-Gg: ATEYQzyUyoYHeQHVivDgaYhWE3oHNlO4Mphk4UQhXhpuID1A3o5vb8yEYcJl8hgGqb5
	0ywc8CzPDFlv1f1ps9CJPHqjzow9xRwSyRHARYFhwbeHKyoK5EX56ju23PMkT1I0p9yGnUYOEZ4
	HvHyjC7l6nz6hnH9RKSrUMyFh4sUyWa2BxTRfS/lTLGL4pTRyTAoX0otpIJ6jLKdibRzJ08j5DY
	MyBWcyrTWrzcC0RC9wBrQmLjoZuoD428OfVmEjQgcl7kprdScvWaGKtPC0hFjQVdo06s3JLg1YG
	Ug6ihbJltcAdONJkof+v4lxS6rzP7mf9U1XyiRk/IskWse+zbtE2MjcU1Rk6MIgNJGldb0SsoPS
	pAvlE9WZYfOw=
X-Received: by 2002:a17:907:960d:b0:b93:5744:aee1 with SMTP id
 a640c23a62f3a-b942dfb9f56mr860539966b.51.1773135801970; Tue, 10 Mar 2026
 02:43:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310075447.2088205-1-gality369@gmail.com> <19e81a86-a8ce-42df-8cf7-da74205584ce@suse.com>
 <CAOmEq9Umi=3AA+0DkmHrfFjj2hBnkq4xGSFdfS40x5F7DpEtuw@mail.gmail.com> <4e697f30-1057-451c-9238-5ea748dd3236@suse.com>
In-Reply-To: <4e697f30-1057-451c-9238-5ea748dd3236@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 10 Mar 2026 17:43:10 +0800
X-Gm-Features: AaiRm536-m2uYjLqi9U5ujWYS_-IxuEn188Eo6qNjtn33hUuJVhYfzIx46MnQs4
Message-ID: <CAOmEq9UNR3ykGP6exskiJLQpUT36xe91aAs_4Jk8mNvEfNkJ8g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: reloc: unlink orphan reloc roots before dropping them
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 5:33=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
> I just grabbed one from Johannes:
>
> https://lore.kernel.org/linux-btrfs/20260224125113.14831-1-johannes.thums=
hirn@wdc.com/
>
> And from Filipe:
>
> https://lore.kernel.org/linux-btrfs/b99cee6ce652b926463a080ef052a2e8e37bf=
f33.1772105193.git.fdmanana@suse.com/
>
> And myself, which is more aligned to your style:
>
> https://lore.kernel.org/linux-btrfs/4170e39bac4a2559ad0535f9bd74a89bc44a3=
6d4.1771488629.git.wqu@suse.com/

Thanks a lot for the clarification and for the example patches.

This is very helpful. I understand the changelog expectations much
better now, especially for crash/KASAN fixes. I'll study the examples
you linked and use them as references for future submissions.

Thanks again for the guidance.

Thanks,
ZhengYuan Huang
