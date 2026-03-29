Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2702230100E
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774813391; cv=pass; b=b0I1zHXzyXghYOD4ayvcwWvHPIYgEO3CNPisfi04IofZ10hI9yF9drMmLOlERzpRiHXlU6T2U6janz4pIQtyW6vQ4jXnzzKFsy/lXZK6j+1Jy28vBHG1QnZbEIVEAZb6V10vaz3PuSDiVzBLKjOTetCSAIF9RVxEKgbwxNoZj0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774813391; c=relaxed/simple;
	bh=ggBvbZDyKPjhx2pT06Qyu/gQSuonR/hy+EMzi+8MaXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vi8eQ8thDVxfD3DSwtKrHMf7I8Dq2wzKgqSAtsfbcUMdYuslLzIottY9blwInZy/bgaiuySdjIhPDJ7sNGXShF5pshoN9f8GeiKaK/KbOzhXY9EEsMfrIbXWfyK3xjs04kt2GFrg3aco5oxZ5mBuVQYWGa9MmSMqaoB/PXp6BUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J9IhwQup; arc=pass smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9IhwQup"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-56cd71a7630so1346993e0c.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 12:43:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774813389; cv=none;
        d=google.com; s=arc-20240605;
        b=je6zgHOsDEyQewoDzrDyw6swHJPM0vWs/TTvE/vZ64oDdvoasub46nJBpdCyKDFYza
         kqds2bzisCyklQaqItb8AbOMpYgxND+RT4HXpAQ4aD4vKs7Jal4y9KcqzH3eBANnHvpe
         eorB8uakPdWQbOtRC9FUijDaB4mdQCIuSz6qz2J40aJhFKGLNE8vAI4Xz8tgH1nEsXqa
         nvOvztFDzmUPAnwB+BzgwilSKbQWGQ0l/OD90O4W91UVWqsqWj/TDnsYKNqW0YaHVYlY
         5BTUywGie32r+pYfKy/4AYoI0NYfCnpZWxQtX6nz8Sxs0TJbgKyovt5qwFeO3DzRj5Vs
         P8rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ggBvbZDyKPjhx2pT06Qyu/gQSuonR/hy+EMzi+8MaXc=;
        fh=9NqtR1+9hOhvKhbhJSA+9Ky90aVRzFTpEln3/dHBVOA=;
        b=NFigOsmCvd+XwrKNvBmr8mr9qxyp/AOUHABTgbKWMq2OQiMj6RgBjT2mCgAFvnGTDW
         ny/0KST/oOHMEDB9Ua5/txEKyaUi3VGV++AEmD3N2XBU5NSv3idhJDDLTawdp66sBAXg
         o11IZgRE57T2XzbBrDBqNQTDx6DGbfcOgn2zlODZEKJVSdfuczYJjoiosKiD3V5LOPbx
         GWN6Y72xGVnx9sW6XVW3k6ZqdauM2xwJiWZ5IoZNsnZXnrYzBcF2Mcf/IdcFBEsy9GA5
         teMwKAJNsOpqIIqKRwIcTfZxQbiWXmVxpg+zxci8tIBX5G2i9ATqQXJ77SO6YULQPgGs
         WdFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774813389; x=1775418189; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggBvbZDyKPjhx2pT06Qyu/gQSuonR/hy+EMzi+8MaXc=;
        b=J9IhwQupqgbEtd9XtFZyzqEdFD/gXR+lecrD8bkBqdHNf8Z3YOnLHfkTQSHWtZOy2t
         WxUNQPQvp9DYJDQzcP/Zgmr378lC5bG3cyPCzKazJZt/Q0TfhmzWHC8grT9dPCrLXLOB
         0K/9IjHoT71iwFFbEyd5IqdkPWmka6BH8/Em7HRonXto4mAddFphwFBy8lodgxcUPooo
         004R5ywkS7zRenaTR8HBCH+DEY5bnY8zsNoz4r8Aumiuk69RHpstYxcknH2GepzdDbXP
         eMLgfK3T8nHSqo2vgGHywl0/asX6K129+mXYZzk38g/RKLvizZ5UO/wbaHA6x1RMUOs0
         JwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774813389; x=1775418189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ggBvbZDyKPjhx2pT06Qyu/gQSuonR/hy+EMzi+8MaXc=;
        b=O1NYWzSIbBdjRPXlWs3XWfBv/rf94BY6EwCjW0nwthhMMj/eSCWafE3SS9tkjVWish
         KFTTv684wBFUbRaeiHJMhEySvbqWSE8qRf6cmsNMGcIjsnyJJnYnh6qV2NUl8cB8Stjy
         OcVV47b2Pn46JjFsQT+IvbsXMBkbRqrA/Zn9oAMnS8NUQpxRiN7MVWMEOKX6JFpDjJS0
         X+8/0YPoDX8DT37PpdSGt0tPBQzu6O1c5mAzZicU3Yhso3ByJjLnSQJUWF14pD2Voy2a
         60BIQIjFcnPotaxHhlYlbmCoD/8ItmnHDKbMXgHj5IVRFK5L/dGVKoQ+tgOhrUrJZc7o
         lP/Q==
X-Gm-Message-State: AOJu0YyJtMbeXzAjbxlFP7Qlqe1zW4aHH2s1ggmq9uhNYpGC9QcKRx18
	fhJN6LrQ2x6AykOD8lHUdiQ6MijSiNNn9n7RITGYYj468PfoZkqX05j2KQdXrNgb7r9cPkWd0Sv
	g7LLU2ymW/1oT41v76pNHT0tRAPdw1L2VaBLA8YY=
X-Gm-Gg: ATEYQzyClkNOtaKLfWSZ6/aRZXWPUE5c7iKeIYLhVkYJGNKfkujpx8Cn0ZGPbzlyysj
	9Xtg6bqJDtrMLw/0XkD+90SZhZGR6Z78LlSwjFilol2C1iGfCzii3HT+LCKNKXxu7yA9GwwvFDK
	R5AyTohy5wDjylf1si20iGry2bYr24fKW5JCyHTdMrsWUPXzi06wHOdvKId41nurB/4YA8pkPTh
	2EXRhh4siebsgILOXGi2Aus7GlPei3+Ri8JmRWWbGVGPtW5/milH2PIVOU8s6311a3hFRiHnhXd
	I04c2sAB2YgRfAl5
X-Received: by 2002:a05:6122:179b:b0:56c:db8b:504e with SMTP id
 71dfb90a1353d-56d4a68caf0mr3540783e0c.13.1774813389090; Sun, 29 Mar 2026
 12:43:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260322063935.3951728-1-echelonh@gmail.com> <20260323223424.1876676-1-27rabbitlt@gmail.com>
In-Reply-To: <20260323223424.1876676-1-27rabbitlt@gmail.com>
From: Yochai E <echelonh@gmail.com>
Date: Sun, 29 Mar 2026 22:42:57 +0300
X-Gm-Features: AQROBzAVJssVv9JU9nI7Ljl7UUGzbTxWs_nRLn7e3WC5YvA0W6Ot_bvf5pUPG4o
Message-ID: <CACo1jfjEU66mT1Aitw=2F7Sv9Ah0GXm4SOuH42_3=2CVV4s9vg@mail.gmail.com>
Subject: Re: [PATCH] fs: btrfs: fix btrfs_ioctl_space_info() slot_count
To: Teng Liu <27rabbitlt@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 12:34=E2=80=AFAM Teng Liu <27rabbitlt@gmail.com> wr=
ote:
>
> Applied and tested on v7.0-rc4 in a QEMU VM with btrfs as the root
> filesystem.
>
> Verified that BTRFS_IOC_SPACE_INFO (via btrfs fi usage) returns correct
> results under normal operation and while running concurrent filesystem
> activity (file creation/deletion in a loop).
>
> No kernel warnings or errors observed in dmesg.
>
> It's hard to create a race condition between 2 passes so didn't test whet=
her
> before-patch behaviour.
>
> Tested-by: Teng Liu <27rabbitlt@gmail.com>

If it's relevant, I can provide a reproducer.
