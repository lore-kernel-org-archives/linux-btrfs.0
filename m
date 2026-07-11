Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A0739FD4
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783729050; cv=none; b=MWP2GP7ANZmALl70Ehufbgh2hud9QS+rFyUq/AEikkMFpJdXFav2v0ETEt3Db+tJOvE5q9mkrs0m7gejKfGy34ob20RYNfThrkHvjIM67vFe3xopIqR4CZ5l6fnImkGO9ZpOXG2XA00FTWzs3CxHoK1IW6HA8JtsAFjttUhyuYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783729050; c=relaxed/simple;
	bh=nk2cHNfZ9/eE5haUhDunf1Pwc3/nweKKN/bcUQ7XCY0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GYu3JwBDG3YPKserTwWxN/DSZuT03qNqoGKxQuLf0ARM5wRHF1n/hZjNDYAtTpGBcgWk1p1sKNjjD6CUDjb7Sc0c9ZQRMPmoDehXaVtecD0OF5gxi9ue2QE9OifPBkqBiNa0LNOEhu9duJpo/8mGDnT11e6hMTLmDfS2TriZLJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=konsulko.com; spf=pass smtp.mailfrom=konsulko.com; dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b=lSFr0QpI; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=konsulko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="lSFr0QpI"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6a168dc590cso1076976eaf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2026 17:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1783729048; x=1784333848; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e/vhfpQf4OV2qMLQtG4Mk/3KvquVjRSLEAPXaxUkjFc=;
        b=lSFr0QpIGx+lRoNyQq2YxmxQYflxTZIyUcchaHQ1U3kSYfXxz6v9k9I2kGLvocNkzn
         KR6UvLWAP8nWHz+aV3rDt4DtdEDjAdAMvv+x0gFTX1hC2bv3tV3GFNNCNjVm1HRQgqpD
         jhU+sYBDO7ist2dJ0a69Mt2PvbJYj3PHNlW+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783729048; x=1784333848;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e/vhfpQf4OV2qMLQtG4Mk/3KvquVjRSLEAPXaxUkjFc=;
        b=ouuiNbEf/h6zAxVZCOaPJqBxyOnunSUnkstTGT/8Dmkgsb84kZoLn63uFCqCMaG3Wj
         310E88ixAwsmH7mtzsqgvgF8h4C+DOKz7YEdhZ/C/yKDtpznTN+g1YxQceakyeHj7sPq
         FJDUnrkfQP5NPDD6nPVJ1UCFo66JlR7VO6ZZtFs810BjM0rEiWYqDCy+B1L+VMBFJpDq
         PSD5mAcvamK8/yPj7jhHxw1XNv/PEsxOn8Qfmx4ikPek5Ywj6XPzM4zg67Gpg58emCD9
         qr6NeSIwTaqYF5H0WMYx4cK3oyBtsDT5wHCSgVcD9AF0vWM3zJWtcV//cBcx6qwE1gGY
         G4UA==
X-Forwarded-Encrypted: i=1; AFNElJ+OSczh6rIQGKW3zV5rUXdGc4btpRhfsnphlVF/7TfuAvnfyp8jdJs3JvN8gVq7CYRyuuy0r80X0XrhnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwArBGG0th4F8+PiJm5TkF557xSEs1zu9S7g5/xAlZSt5UzCAR/
	DzVJB94XueZ//C/ky36w1G+yYxbpvSIvgeePuZRUTdFL9lKUV9DtSQU4+NC94cz/Cd0=
X-Gm-Gg: AfdE7clRN4ZbWAWr2wefZV/ACtM4mVHEDHD0wdGSlsxWvspARDDT4c71TOhXVI83WU1
	oFwPLFJuNLmEowQ6FjXqJvZz12GmzRYnLaT/SR0GAfqG8yLpER9GMNHBmNZObXVb0rvFR3iNzgy
	iDLZFlHSqWWmLvw1rdEeq55omQEh2Ej+RIDlaFrieYJlnzcpYyKgs+9OMOhnWT4Hn6WfiADBisP
	FnlAjboyejE09RX/faKSrHeObJz/dK9vQiCICl7L6xH+CKK3DovpSRmE/Qrals6aUfduYu3F6Qq
	aybm5CJJDLMUJeV4x4lzyXTKalY4bW0FrAIxX3/TpqpCjeC37l17XHPJRpHI5Qad3UpuelG4M7j
	CASi1GMX66Mek2tq1It9Vka3WtxqOj1Qv9QVUDMtHOfNJtFi+YtB7cWa3oG0b66NKmPHx09jel7
	/nnINMYZZ5eqquZnocICwD0R/h6bBJIkZTOm1HkcSKT56o+xQEqOSIddSc3KqIU2ekq/CgrRLXc
	2dAyf4T5twt/LfRjtfCpYUV12cNbmIJ7ojX8CtWEjUDK8Y=
X-Received: by 2002:a4a:e845:0:b0:6a1:77ce:1b09 with SMTP id 006d021491bc7-6a39a56f825mr947347eaf.6.1783729048128;
        Fri, 10 Jul 2026 17:17:28 -0700 (PDT)
Received: from [127.0.1.1] (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a39af0e953sm651312eaf.3.2026.07.10.17.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 17:17:27 -0700 (PDT)
From: Tom Rini <trini@konsulko.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 u-boot@lists.denx.de, Alexey Charkov <alchark@flipper.net>
Cc: =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, 
 Simon Glass <sjg@chromium.org>, 
 =?utf-8?q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
 Yao Zi <me@ziyao.cc>
In-Reply-To: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
References: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
Subject: Re: [PATCH v2 0/2] fs: btrfs: add support for readdir
Message-Id: <178372904690.2905849.8798963092987519032.b4-ty@konsulko.com>
Date: Fri, 10 Jul 2026 18:17:26 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 26 Jun 2026 19:18:20 +0400, Alexey Charkov wrote:

> Btrfs in U-boot currently uses a custom callback for ls and doesn't expose
> the standard opendir/readdir/closedir interface, making it harder to use
> in generic code. One area where this would be useful is in discovering BLS
> type 1 entries [1] on a Btrfs filesystem.
> 
> Add support for the standard interface, and implement ls in terms of it.
> 
> [...]

Applied to u-boot/master, thanks!

[1/2] fs: btrfs: implement opendir(), readdir() and closedir()
      commit: 5f064aef5d766e291982f9cba6dc728dcdb53868
[2/2] fs: btrfs: use fs_ls_generic() and drop custom implementation
      commit: 31cf3f177823362a42bf4630ec85370ea768ddf1
-- 
Tom


