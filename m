Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04F11EB5E3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777402697; cv=none; b=TRC2V3L9c/x0/okXZF8zCbFLQ3h81In1XHEi40W962JmtzaOpFlrtuS7++Ji+Wz9eBF0t5dT3MPaUUBiyGxF8p/zIkeNi25qU9OM36j4pW9AJ71llNZz3lNCQ7C5AS69mdGk5YFjKCp6VqnI7LmURrRReOJnqeOmq7619yGs91g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777402697; c=relaxed/simple;
	bh=3koeYlDjSYVlDEiOFWHV38rbU+LqsOd2RKYKJ5B4w/4=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=bQSqSa3eDXFmKYkQGbEBjJ9Oa+LmLUleWC2Zs24KwzjfXDPHHTh8ABDTNh2JcVq9z7nAqtjcu8jb/DbsW+bhvGdfgOmUApQjcnO2JOYCvpjidD1JrJLYTOcxGAx/uIFk1zNs7nRGdxKXRawtOvlXn1ccm8wRUGDKVCytmLbCOKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nycr3NyY; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nycr3NyY"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9d9971d059so1663771666b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 11:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777402694; x=1778007494; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3koeYlDjSYVlDEiOFWHV38rbU+LqsOd2RKYKJ5B4w/4=;
        b=nycr3NyYr6E7PYph7miVul0ZkVDFmz9jFfGSBjEhuGgF+iZZ7nH9ZjTUArI55KXGhA
         qY2VMHf7H8OSYSPWsFaiw//VKJyyi8LZiXvRksRptb193xEpmZkket1IW4p691ncFp1I
         nmjwMuniN2ZsFHLG9F8ZQc4S7ugtQJ9ZTjpcbzMPv9pFATd0eTNzuRwkKxfkoLWzS5CX
         CPN0Y8YH/ajkSFNtCkXkWiUS2P6lZhUwBw9imcdEOZQPvXXouoNsuHKylfVFOQyC9UZW
         R+lXvq44rLfOtTbwwwOg34YRGNWfHdTQHQaaIq2lLo9RkvhUYmOoySacewkWA6vH8EdT
         hC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777402694; x=1778007494;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3koeYlDjSYVlDEiOFWHV38rbU+LqsOd2RKYKJ5B4w/4=;
        b=cvCRlkIZ+Wf81Kluxsjzu9VfBEjLW8yhmYa8LNAYUsljTV9TIg6fHuKKbfJ0kn95ox
         ox4naEXpCKmG72/XlDlbn1vr0up+B8aDQ43OXgAEkjdHDYMAd3YQ1R5M5w2qOrbM2XNW
         tHwHqHGp7CyH4nMtJN4lT3aUiYyvVQBnNAStO+zXAOGlwAAcBaGU2HEaGsQM901+erxB
         ShrKXZfgxbc2wF9Xe0czFVCZl5ukMzw/c4iIxTbYgsjz69uNBc7e2L9s4a4HbjJ7EVb4
         kn+9oAaAFTBWJHn5yHGsWBvY7ssGGd8Pz0ZDlLHBesI9K2l2jtcCGcwViJiOQWZ/XYsb
         o7PQ==
X-Gm-Message-State: AOJu0YxqLuw3MPhQqdv95Jvz174mPNUSPokftFsof4ChKhgF+Ag+ek2n
	GnpP+I8Yg4WgP+ge282IDgsimduuXapyGWHiU9Z1jm9aJOUGMzDrQy7wRkdyj0q40DA=
X-Gm-Gg: AeBDiesRXv7gouVqXbpwAqVuencppC5+BRmig1SWQL8naoyNRio/8SCjDjQVH94znnO
	OvPrasdbHGEcQ2k+WZj9UVZxMp2z6kMfuMk7a4jx+mcgPw1KGJIiSfhk2bufsTvTmjHlpDgYjoR
	6AF0vcie2wcFvDlOd1j/VbRCjYlXw6D0Iaug43Esa5rBp5mP043OqilUGzm8NMK+Z8HgA+/uTNg
	mkZLuWlC4o8cJrd4+V8OBAEfgbegggUgs2cVPVoxH/XTz12bY0pNnChj2nMw+Gnwp46yvqqGgkM
	8PTnX7CyvfZ8qbuLszWawhmVs+3dcgQ/kN9z0xI6ze/+ThaZcYrVz6Q9CXGj4rklcLVHUMmLi2z
	wFxNgf8nrY08G2C91mzSuUhYg93vcuykMGe8u53+X3tNwqlycg/wlgn5r0oGTSPnAi52GiSAHUy
	ozdacqOCc8ZSJ3dHBWYnjP8Tilo5lzDG/Zp1UsPWwA/0GxSv1BDn1+lqUkyuPMk1osdwxCBZFdI
	CzBn96n4fdaTWtcCza4H1dPMqL4s6uBEM3LI56ze5c=
X-Received: by 2002:a17:907:1c98:b0:b9d:6d06:b78a with SMTP id a640c23a62f3a-bb93ce8c877mr37329166b.17.1777402693720;
        Tue, 28 Apr 2026 11:58:13 -0700 (PDT)
Received: from ?IPv6:2001:16a2:c190:af0e:3713:56b7:46d5:afcc? ([2001:16a2:c190:af0e:3713:56b7:46d5:afcc])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb80bd9381esm139146066b.52.2026.04.28.11.58.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 11:58:13 -0700 (PDT)
Message-ID: <4575d1380ada67bcc34b60f0245ad37e316a6ac3.camel@gmail.com>
Subject: Will Btrfs progs get a 7.0 release?
From: AlaEldin Mohamed <aeiedamo@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Tue, 28 Apr 2026 21:58:11 +0300
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

According to the btrfs-progs release cycle, we should expect a 7.0
release by now. Is there any regression preventing this from happening?
