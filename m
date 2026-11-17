Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794891453;
	b=t55jfum1USC2cABIxuVzDNdx4lJVCmVJ2MuZIWbbDhnCR6FXHIbER+CafnAS/LAwI1Fs
	 1Lhtip2siM/FYT3YbH9XVCJZLJbPPEAW9IVlkdTzg0iDelHHzZu7woVfyF/AqN3mQ4mXZ
	 +1EUVDkbly4FWMiexs6ijJX5N4dt3HTvdSE9DHBKK3DFXz588lpRC6h8mjwvKKlWJMcaq
	 +vC7ynLJEG8v47Nofm5fR5R4fdvytvJo24hEB2wueO1OWmWUoHH3ltjmmGV9PmfTB/3c/
	 Zcn8GnSoZKR6UtvNUPoV2Xkzz3gKuma4IK7aaFCTDij+/bRaI78J31ZbuRuuAbG0ATA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794891453;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qHw0tCSObWwSykY7n58JOmO4RZlsqTIrlkDPJXZwajg=;
	b=gJu16FIPd/UqGyBpLwbCnCg/6VBM4agf1xTp+7MqK9adKYS+BM2QyrpDFcpfAotSARaH
	 envdM7Kw6QRI1kIy/UCMslq5P4W5BDd/537aMdr2nSgZrb/fuFl3tPxZCBIjpuBkxHThZ
	 e9ELJdU6BAY85dlHh5wbRRRqEB+AtY1VvbL91ymyS4bfkir6LGZkjtp0iLhHtKb1Q/5u0
	 3YlRdna8rvMHubsBjoLv9mdW3rJXqOdR7mB4PPLvovXkvIR7uVmoK+cRJ3LqvfNuwqU5+
	 LLJOMzYCz2U4biPJVBco5dl9DRGVwwoF6rmEvoHVa3PPFCTCdqNKnJmWic3akOoXt0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="CoNgp/7x";
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977E3606A32A
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 04:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 977E3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CoNgp/7x
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-15ea896ddc8so6622773c88.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794891453; x=1795496253; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qHw0tCSObWwSykY7n58JOmO4RZlsqTIrlkDPJXZwajg=;
        b=CoNgp/7xuB8My566r2d1mJ2RCoEgk/Nd15sY6YVWgTnPAeE8xT8OtulNjEiNrRNoam
         98C8Qw+t+xGIB+cXNqUur7B3lXZYS3QJCzVLaTttv0YgWNmPvhiYM0IhZylUpOZ0WphX
         9bv6zTkPI+bYHJsGteG8dFJsef9gsD7hgKs+5Oec3AVc2p7AaHo/4y1KDrPuB0TRVcXQ
         dX6UiKTXxSHhPhsRwKcf4gNpPx7AC0DpY++pClM62WGnDHMkJPHxlgd4yZgaTvQdhUlu
         jwwf0fQLcqwx9Q7GKiA1PEknlaG0hNCTlh8QqHJbV3Sdpg3BOqRboMrxepU1B/4tS3G5
         K9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794891453; x=1795496253;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qHw0tCSObWwSykY7n58JOmO4RZlsqTIrlkDPJXZwajg=;
        b=R4xpfXPuPjLcItV1sO+LOeZ2O9YWojZH38g6UMIz1zxYKyD6oh4oByjJOto9oGvm7x
         hLtZKrydbrK5LOAGkC8PP3aXXvVhxyfx7loUmyYJfp60qXwq0ENR4hTJRDYTxaSr25Pv
         Z5IIcBlFSLix0nbAJ0xgmp/PcxamlREXenzZNwKUZt5Q6560a+h1Y2hrLDR/8s8i6lDY
         nsLo8O/+GIETKYUX4Cdm2i0MKmWmUDrGOehFo76gAsOwoUZn8xyqSqmx0bSb0M4gBBFb
         lXHnKL3PAkgSfuXGNkTJVGtyBfJqLyBDFv5R5sAJO9BgsS68vXegTT7w2UND9v9v+DEf
         LShA==
X-Forwarded-Encrypted: i=1; AL+hErG23GGFcP2iQW2ZFO3tqeJrz22lBF2D6B3BHRRg/JIjaV8bYvdpTbJy4Dp9XtVS1NghDKqJ1aUnMtnZtQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/WX27M6vugZ93UW6hYbtLQTfBJRyqdzYi3yTOU/i9ZdVnhKu7/
	Hx98d7fjpUNL5mEJ50aorOl3+TRUKZOwcCAF3wQKR67b6K0kC2/Z+D3ZmBolxxju
X-Gm-Gg: AZFdTZeO5eGokwTN6hMEdMZKDugCsMqGm5Efwmfm9Efx4VvScG5dxtrjrsXr4CAb9HY
	o6csuBNpdDylMrnrDDxxWBaLuaafKXGzXi+C5eRM6mVk1e8GlhJB4WMC4IWcDDlmlKlrD7qZPek
	5XPGvD5/HCbebTpkjAEflgghLm7/WHTmUvaCbvlo0irwgyiwi27kZSmPqaAVM+KYPwHyW3F/K8l
	D/QtQDap0YUACXLGzdTT3hPLYhSw/BsSCi6qRCawcSiKjrjXt1mxmPX/124sP6QcedEIoPPkNcs
	pM0YO6TdflMeknNEcV6tP+JcO6WqJu6ECIY5/e95unDlUwtjwK91ZZRtSllm5IR2Il0GtNTkboF
	72GLt8ZQuDaEmZq+evtIGh4eyan6G3DDovLmUyR8JzzhwdROTeelArS7Biqjw1o3QmG2ml83vxb
	LFy+8tMO35BwMbB5y72Y1FM0qR+vIAiL0MrQeQpc1zRpBth+/hp/KBJNQYuFwptJJbHd/OBp5tH
	+Sar1pmLtsjzXcuwNYq7hMQtHOvwCrwTMIZRsciYclmt4Q5GELvXga1SGtIrE9j6ZGSxX46wYl3
	lebwbzr6uzb9LytJB/xraqDHyOBfygBhROPerU1UiXeGAdxvVgjyY87WxZ1N/29WbXs7
X-Received: by 2002:a05:7300:5609:b0:379:4197:5eef with SMTP id 5a478bee46e88-3796676be4amr12497087eec.8.1794891452613;
        Mon, 16 Nov 2026 20:57:32 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379563e6b6dsm71582962eec.21.2026.11.16.20.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:57:32 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: tree-checker: reject file extents with oversized disk_num_bytes
Date: Mon, 16 Nov 2026 20:57:24 -0800
Message-Id: <20261117045725.606165-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <35bcaa47-55c5-4b2f-962a-c3168bdf52a5@suse.com>
References: <20261117023841.467366-1-teel4res@gmail.com> <35bcaa47-55c5-4b2f-962a-c3168bdf52a5@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/11/17 15:01, Qu Wenruo wrote:
> I don't know which agent you're using, but I have seen several ones (not
> only from you) doing this linking-to-older-versions behavior.
>
> It doesn't make much sense.
[...]
> And the full changelog would make more sense, other than letting the
> reviewer to jump to your previous version for history.

The links came from Documentation/process/submitting-patches.rst, which
recommends adding lore links to previous versions after the "---" line.
Its example also lists the changes of every version, though, and I only
listed the v3 changes. That was my mistake.

I'll follow the btrfs style from now on: the full changelog of all
versions, without links to the older ones.

> I think the ram bytes check should apply to both compressed and
> uncompressed extents.
>
> For compressed, it's MAX_UNCOMPRESSED, and for uncompressed it's U32_MAX.

Will do in v4, with max_ram_bytes picked the same way as
max_disk_num_bytes.

Thanks,
Cheng Yongkang
