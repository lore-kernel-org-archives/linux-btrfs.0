Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666431E9B3D
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 09:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778578979; cv=pass; b=TpQTocuNVLMwI+H7r/Fv8dUemBHXpNULb8133OrZjqVdQDBNBkVwN0nI7K/a7xzgGim+KAfy4YAHO2JifRofdEbW1jaGKcONLBE5txgN5xGmvIW1qVLbreiCzgIAt18ojpvufDjeynrzDOaxPfwZAMykFEW2wHFnQmkywcCCi1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778578979; c=relaxed/simple;
	bh=s1OOCWLODmyroeZNuSEN4pTGxnWil2MCytCdzrB/lk0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=V0njw0CKQ7iBBSvq9JfTZ7R9Px2HT/dEaut1F28lg24eQfvoSvJ59YzP5BEPmv2433PayjA4VhmIO8IVot8Q1fJ5uvjhgIM/bnqZmr9v9hpvABKq69nEYlIfDMaztovEvKxH/VNjrX9yI4D57/kkshV8Q3h6g/pM+XONrXLbQkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxBGjx8e; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxBGjx8e"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-366070f71adso4745711a91.2
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 02:42:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778578976; cv=none;
        d=google.com; s=arc-20240605;
        b=j3UlMUWybgFdEE/2TgZVyO4SBgvsL6pJjpwzD+CEO22vKaUjTVfBQwAT1G94E5wNLr
         xbD7+Ox1xDx5K9chRA1B4NFJz49SqGykYHWGR1CdysePqu1VArEerMog+NjEc2Y9B1DA
         WsCm5peI0DFdZ4QvNPy6Kt2J5Kz92m3ToD3RGPDekn3pZRR98Ojd6BFuosYuhf8FLNx7
         rLolJ4ybWYfCKvn/xP9utO2CR0SVlaGlirYmuXWTt0PUYsi78g0P1bdypeSjRB+ZwHGW
         oGV5YGvpvW3r5VjaHz+hAm5GzvDVtmonBTbDy+JNi1VkMSi8dVCCWHb+7JAQ/vNizNfl
         VEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=s1OOCWLODmyroeZNuSEN4pTGxnWil2MCytCdzrB/lk0=;
        fh=OdaETlnKP/GO5C+1iQfL2BGeRW80NiHD6FL9P0n4CVs=;
        b=ZQfid80Zwd7KgJYv4A9YkmTxriI5wsIx5D/rooMHxN8JFIF3fRgsCiGe3AhAsSS/P2
         i5bAAEVvl8yW3iq4O3l7OvGJkvp5HD6kSUlQNg69s5aPBSct/WkHpaN8cGPJlgyXxL8k
         /Mic2eUFXXGlJTaip9NrBB2QsERpox+SbZReQesS0cVeBecHKlUtiT8bKrSjBJemz46K
         mNCCVPJSG9JiAWU4RO3xDnaww5VGI5oaenrShJeb9/aYrT03bTzeayOYgHhTOjseQmwA
         J/tPJhDYNGZ/tr4lFEAmQbpwAB8K0snbPgtwDbq6GR9nluYVhGzVbbclgE5odlFbWw7C
         8WiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778578976; x=1779183776; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s1OOCWLODmyroeZNuSEN4pTGxnWil2MCytCdzrB/lk0=;
        b=hxBGjx8eXH/xlesgd90tbK/0Gj5JP/tdt1niCksHtO4MCyAip9n+oxtRVf/F1v/v0J
         R+lUVe6dQokEqeGi14ifZKWYPTGPHik9Yn+1cA6PSOEGjbJ6JzNek3fKquHRN1j7YqIP
         VpGaEAe8y9CTc0I4U11PIdRwB8Fyv+d7N9h5UL/x0jVEDyKO9uHqORgCTgQmpr6t/BfU
         sypaa1XzQYFY1SNO1rwzuqTN1Ebl5RM9jYpRWFt1M13uXG0xNCDPEg7rZaMyfglMpfhD
         Z3elsbyMdGUeE1kD7D9MOJcrLkND2nxXkGMR2XsaTlQUwlBtfvObxMbKdbjGSi4wD8XM
         0thQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778578976; x=1779183776;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s1OOCWLODmyroeZNuSEN4pTGxnWil2MCytCdzrB/lk0=;
        b=Euw2eNjBYvfmRBqdUwMjyhXaToyYTjN2HgKVL9MRq7hq/VtIvKotASKXDwZ73qknF5
         eNQp67CfYQ+TKF4MzqrGZ0rd0PXzzkALqqpP1B2iKIyZ2W5tcCYAs039j48jbgChIfGv
         XXH/y9E9kv/IRY+G0Pz+OPcwMPX8U+BEQt7CgsdWe2cFrHSdhJr6R6Po5rny1y29MwCT
         RTQWNzneOmnRFerU08of+P5JLhdC3WCPgniakLV+1mfUmonPeQAJ18bLPJyVeAyfnojc
         7KBp0+IOeTxQdjIy0u+NmlDLrmVDjTd/WlVZ2VZQGbUGq0QQXmChJztoJVo8eCLl72CW
         ZIAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+n/mJYoOtGZlwqjFIorTZhhduOo1T1lFpzPZb1NHyzghRVY10Q4+sIIKy0A8oPI2Da4HrJmfyt6MMVWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGjQH6zHZDhNVmXmBIgEA90RFgDQXVxb1KurHXhLHnzWxF5cqw
	0GKZPumtUfPwU/1ZJNlAMCWsbm9/JhgX2Tp5bnA+rVfUuJi9LOxWCpViqoQ6jMxjxq9GqB7gw5k
	3CpkTU03MJMPDBMx2UfMXDjlu48hqa0s=
X-Gm-Gg: Acq92OE9AGwcbbdhVt2p2g5IKitXmT58ydX1ygO38D94E7mO//bCQrPDASPj48UBY+C
	+kQwiZyWXbknVZFacWp0ot8S2gvhuROC/8NYZAT9h7CXyCucFC1wJQ84nGZJkeydJrGPI+PZ+X7
	5imUXsRO/qxkq8CH/gNqgnNzippPwwmmy8gTsI/Uzr5M+YVfkLmKivCKLc5Ojihz1xfBwT3HVj1
	SoFDRQJ/+WMtxGSiFtAyy9xCa0RsTUTTQY8v8Y3m3gw1xOGwBQAKRrds1Gf4bOuFTkMSK/SJwmE
	S8WMJTe1mVwkGT1L/2dNsn+Cb9hAjf9+223/OzWq
X-Received: by 2002:a17:90b:2f4e:b0:359:1130:1047 with SMTP id
 98e67ed59e1d1-365abe8c511mr28287381a91.17.1778578975903; Tue, 12 May 2026
 02:42:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Arun Rao <arun.rao.bl@gmail.com>
Date: Tue, 12 May 2026 15:12:44 +0530
X-Gm-Features: AVHnY4LClgZTeSogklM5klzYgIGBPPxQMCEVETX2llXKICl6FhLrQ79-z4quLNo
Message-ID: <CA+2hknjQ1wLjXdhZWezW=9BwcUhoXhXR1Yi=N8bhce-Qe7+RFw@mail.gmail.com>
Subject: Re: [PATCH] docs/power: note Btrfs limitation with FIBMAP for swap
 file offset
To: hch@infradead.org
Cc: Arun <arunraobalappa@gmail.com>, lenb@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, pavel@kernel.org, rafael@kernel.org
Content-Type: text/plain; charset="UTF-8"

Understood. My intent was mainly to document the current behaviour
observed by users on Btrfs systems where filefrag/FIBMAP-based
guidance fails, and to point users toward the existing btrfs-progs
tooling.

That said, I understand the concern about encouraging users to rely on
resume_offset-based workflows in general given the underlying
fragility of file block mappings on moving or CoW filesystems.
