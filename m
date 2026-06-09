Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016423D9DB9
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781018771; cv=none; b=O2s7If+CA2ds4uB1FT5FTeZXsMyM8+3zP6ayYJLsHENW4xswEvwEczz58IbeDzCXJS2XAJev60IZhTUteOFDww9AmoaAU/e7fcYR28ShTrS66LZBaLt//7HXbjBJPNO5rAuGjIlcvNbYytlotxVUtXCIjMgR6UuWYQS2s03Qu34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781018771; c=relaxed/simple;
	bh=/p9qGZhZsar3I/4ufOf69CZcO6c6phXxVR+GroQHYtc=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DzdVj548g6ntKdLKzBNLf+Pp4oebz1wfUndrQPP8JItV2G66wQVTj6r+8JySGB31XZNnDVjw/Ele/EbL0PEnPNRGuutINP61PgcCARRjRMWNxGiKquw78+aKHTuI/Y3ZZ7kcEhnO9yYA5r9gI9JGGJLO56FXP0RyedW4NF/04P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com; spf=pass smtp.mailfrom=colorremedies.com; dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b=M9mzFFpz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f2fEGHmV; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b="M9mzFFpz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f2fEGHmV"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 39D021D00065;
	Tue,  9 Jun 2026 11:26:09 -0400 (EDT)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Tue, 09 Jun 2026 11:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to; s=fm1; t=1781018769; x=1781105169; bh=/p9qGZhZsar3I/4ufOf69
	CZcO6c6phXxVR+GroQHYtc=; b=M9mzFFpzUjKzVhkCpA80p1NDaSmcXmvx0S+Tj
	E4JZyvi7MrFq+a/Yjj4qcDt2XCAXgnzv9O+Aht7Kk8zs+tmk0Z2IDXMEtCvfH0Sj
	bX4BIYdbGuRUnbFfzYApDZshtY9si4IFe67n4YPJ8zBkVJdXFJ+CtQedFRs2PZPk
	OomgUy7FWTZ9foXAEsGZ+5GSkOuTdXPSoQhalG4H2L2hZnOwZmRrurzf62LVKwug
	jaZ4SmBtSDcLMCT1mk4QW9p2aH8pbKTwJCORVH94zYD1IGa3IrBXnWwMR9tQhT+0
	VdHI341MWOYpxmnMG1Isy8CRZ83wYGZzunKok4qqZVgsY4AUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1781018769; x=1781105169; bh=/
	p9qGZhZsar3I/4ufOf69CZcO6c6phXxVR+GroQHYtc=; b=f2fEGHmVSFmggsD7e
	3VvQkrrARVi6mjW3QMhYzUvNfP3uHV+zkf5VRexOk9/KvSA/sZ8HabGwe4ZcLTf7
	er+AbyWgNxs2TlnBClaRYaxy3vRkvGXuzGEvY8FbbbY4QMqJlZbCHV4duCkHG5gM
	WptSNLBkXb88Vouqd/YbAGChU/YoqJ2gqbIS1wplxxEQ5oe1xmYCA/NpBlUpJkLq
	1o+NYD8jnabQEJqmUceL5ObdTqqPLgg1+BepwIX0+g9w5ViUn51IQf8UaHL7Utyf
	2UTGcea2qaAZS7wLrL9wXsDd4jXdOMgYWyJUPtE6krAhxaY1DuJNnkvNv1U42xix
	sD1PA==
X-ME-Sender: <xms:kDAoag7tTDdlzL62jk_47sAxa5kEcmOWun2BgTCxUTDuCgCxA8mPnQ>
    <xme:kDAoastWMjEolhzPvj35ote4fUICAFgx_zrWr7XezgLYX7MRdOKmrSEsPvWBiyQ6Y
    lUH2gSQMZ9BZBHM8cK_loBD6-i4kO9SLZKaBvD2SLxbjdcSqZF7N90>
X-ME-Proxy-Cause: dmFkZTGxOuqf0J4hY2EsysUoHXkK7RUnAN18pRS2gxr5yd/eBPt6k2BUyZqJhXzgRtIH0f
    0OwvdOuSpBXwnqgSNHQW6uKygflc4oJYzoi6svYQBwbAygYClklzv14rFfaxvgX1u8d9W9
    e+61tON8q16LnywIHI7aFIdrEkQW1NNA8sROY43RC7nXdMwhBrZb47j3NHcMAQC9QxHr2I
    3rRgvbXr+Lbz2cArGOmCUQQJypvbIjq8fgw3c069R4qvzc8IV2U16qSAKFpkMD2HeqJhhK
    ScyFus+ZZxG0P/irweZW/kGpQplkkRNTOmjosk3K/tz5I9Jxyo7/DFOinAoTLliHuyDmpH
    hsmB4mMxYrVN4fXJcBp1M9FpmzSYftKAiNt7QKKvBIq1+HkdR8LABfLGcf7nsveBos2FTL
    x2UyHftJhRxYyRqRfNeZJ3an0GTxfJxZ8pjpZea2MJPB11b2v8KbwVPUpCvaUw1emo6GgH
    ZmS73HLg3LJqs/UFVmv7Tf11FvkXWqlGGaH5sBAtg9PircBljgxRCZmI2G9dBw9zMhYKYo
    FUQRBiDTtPlnatCpFhuVXjVuAv/6M0nQ1qdCLaEu131sl7TnuH8Pm/FaOfsbLiBuqnh7iN
    8tl3azDZAWeRXtn+PP9Va8BKhmf7ee6djJ+Qfyt6MXoAvjtjh5Dm9d/mXBmA
X-ME-Proxy: <xmx:kDAoarmzBErXOTn-7g8FuKMeB8BWtXnbRIdr_pLE3W0oaAf86pq_tg>
    <xmx:kDAoaswE3wEi7FTEOCpG__8L93yExkOCulGjN31vTVShnnM9HOAxXg>
    <xmx:kDAoapPQGmg_Jx5rz8tgNglj2LxY3n-w8HtBCkZl5GntimX03RKp2Q>
    <xmx:kDAoagTM6slYX8iKm7SA3LoBDzkgD80l_gzqsalJHIIQbcAAGSD7wA>
    <xmx:kTAoatdiIYqk5BGpM5s0VtgySIhrZEQ0nuB4khNlkOM_ROHs0eFpoYTu>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C4DF118C0068; Tue,  9 Jun 2026 11:26:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0sQEpqRO37s
Date: Tue, 09 Jun 2026 09:25:47 -0600
From: "Chris Murphy" <lists@colorremedies.com>
To: "Alban Browaeys" <alban.browaeys@gmail.com>,
 "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
In-Reply-To: <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
 <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
Subject: Re: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance paused in
 progress"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Try:

mount -o skip_balance,nospace_cache,enospc_debug /dev/sdb3 /var
btrfs balance start -dlimit=1 /var

If the first command works but the second command does not, you could insert a `btrfs device add` command to add a partition. I'm not such a big fan of adding USB sticks or zram devices because if anything goes wrong, the file system ends up broken.

This is a bit of a heavy hammer to fix this problem but it might actually be faster than troubleshooting Btrfs enospc:

It should still be possible to make the troubled Btrfs a read-only seed device using btrfs-tune; then mount it ro; use `btrfs dev add` using a device that's equal to or bigger; remount rw; then `btrfs dev rem` the 1st device, i.e. the ro seed. This will replicate/clone the file system from device 1 to device 2. And it'll take a while. But in the end you'll have a balanced file system on device 2.

It isn't strictly necessary for device 2 to be equal to or bigger. It is possible to add a smaller device, but before you remove the 1st device, you wlil need to delete files. The bigger files you choose to delete, the fewer you will need to delete to get to the underprovisioned 2nd device size. Then remove the 1st device. Now only the files that have not been deleted will have extents replicated to the 2nd device.

At the very least the seed-device is not being modified and shouldn't get any worse than it is.


Chris Murphy
