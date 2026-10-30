Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793347299;
	b=tflPDruIVJ/PYp/zrBYbcb/kLnavGS+xwI4kPngHcjRIHezqeyBW8G1h3M8CQN5RIc01
	 7/WTY8reGD13r90+gAd5vbrdp0LC/wwA18o96kLIYAlLdMAIEMMkhByWQHE4hfDZnK1pP
	 SNIOEjVdSjUpYIMmzmbcc3YSMYCznJpR3LMDQhhnQ4cuQL64Fh0TX7hpum+6rFlm9hWJd
	 CcKKnt4SkfkvbZV4Q1pW4URiwU85YtbZk5rmMskgMjz0Nb797m92/7TUkyvf29Z7BFS5X
	 piZUcSiV/bjLPWOzaANsfG48Rn8GIqC6euq07Bd5kBgusOg2oDo9iuOvcc8HY8Saz9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793347299;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Date:Message-ID;
	bh=uP8ou9OSrhsukg4Hi5jjDWDyb900vCyqUrqKeXYl4uw=;
	b=iYb86jCs651Xlg1C84fIu+2I1Aw71aVFBpTeT4LuQUy7Muh9ry8L0L3kD4FHqlu7316x
	 I4LmzJ6Oko7kQsA5ZOPw79qftCI5puMmmf4DOhF4wnPHsfY3MyDxZcavLMINnyAGVZ3lw
	 AwHAGxLXhIadYhb/9DLz1QK1n6cqQpvQGoYgpriD79IYEx7NacTgDuepyvaEKawHZkFjH
	 9W7T6IouzXbnrW2iR4Y7N9GNMfp3xOut45MJuhkQpXKDsYPjNhJJH7SoZdSr8ezkQCRx8
	 i3/1qZpMskOK3lD8fKKpWYiW3KhMpeNmyL8gCzPSkPhYO6w5nKY7uZAjZJ4HCObBWKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qOSfpZbH;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E826A606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:01:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E826A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qOSfpZbH
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-369f3e9e431so341716eec.1
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793347298; x=1793952098; darn=vger.kernel.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uP8ou9OSrhsukg4Hi5jjDWDyb900vCyqUrqKeXYl4uw=;
        b=qOSfpZbH6RKU9AuDFQPj0DC4UuEbfue3MUJYD2VptaDUszoOQuhxWPMnLMzwRgDlRy
         rg1CoeEVPl2ukcKiOYxYI67Ijm8dUgLOmNWDib/c1sZ/o6xxIGqDxifqoPqY5JrNZLt+
         hk3XhDUezxFarHxAQj1fzy26vJinJr7rv4RszQgd1hjmhnJboWrZ5icP2m7ZV2EWXbsR
         Xq7RfvY4FhUmN796j+wB4ilaQbmBWxS1TuquIGXdX4rDVHcES7+Cy2688Zl1PqaFUbhV
         AKdkbla4aThXOBpdZthhBdquHgvvIE6e7cJq9R0OoUEHmeJ1vbfyTu/WaCsJV3Gz8s8Z
         t2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793347298; x=1793952098;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uP8ou9OSrhsukg4Hi5jjDWDyb900vCyqUrqKeXYl4uw=;
        b=USIryOo5z5+LgvV3p/5/DLqpQbANsSdBzA4oqPpdpwnRsYCWHc01tS2ttQMw0bn22k
         4YKW80sWufA5KPiP5HIQcadeL52PvSi1ZR4SjnQzcDNkDpKV4AY1sjttFb7uTyvp4jDD
         hqB0gvLl5xYKv0Xx4f84PfcXVWOpg5fB2fTwe+8Tk0u/WfKu7ns+/htLMKSsPdVDMnZA
         +GkM+mT/h0MsvAomIUTfV5poBr2r51bUvFMlHs5c3NInjhIrzOnq4Z5FbPRv+2oV+358
         uUVlGJAJt+fYSp/A1tPDXbjLKQwr7TmZcRCa0aKguJW1jHTg+ufGvxwX0LiZx5wmexsX
         YJ5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwskdWFWfNv3vtCVRk3HV8nfGAM4MqbY2b3iF1PS0ELjJ7qujYJN8zWACyAAVvCAT4mai1zVJNhyLS2CQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKP3THKIRK/0dg+KX/niztkr1ro01BaaweHy/CrLnCEyxdkCJ8F
	OcIX5G08a9orFy+v5QKQoT1p6FkQrFoR8GFQcM8LgnmFrXXPaTm6lFoTpLyL3/dh
X-Gm-Gg: AYBFou0r2c+PsKwJEHDpQa5rffFI3tcroC7psUTP8O7ILKpBU+pBpmWHJy7+n1Kj9Vx
	Fz5DbNZbh/de0750qYjLr9Px1XuS/bnw4wH/cPVQ16jCwo0KbrSvu3IOwa0iu1yxN4dOh/HfBGD
	Fki9jhqh+Agrap82OE8XdoLklfHCcFmOS3Ds13+Or9plyvJCnjUEkLceqR4Z5oUtl2MHuvG4/S0
	Ybi0nJaqdcKFf736dWt9R0wLZw8d7JWzcqSbayYntOgo2nrm4PFe5tya70yU8kyVtzoWOTVu/4N
	ZZ8ClueliAeW+MEfxrmg4qt82+6xVFOGMCZIIs86jP6+ScoFikesGuuh8gGdCMqJAHI0C1NsWCE
	7U+7RwG9mb8vw9acGMkKAlZTxyGECiPzF01DjCMLfYJakU4Dx0mDd/Nkn4ZvPs5N302YNUTiSoA
	Zgkl48gPzt/n26KErdbRqqWNcHLKt4Tk8G4q+o4dVUSo+E8X7K+BfN0flRVUMYk4A52QpYJZyIf
	N9GRidCRiFydge8pwo5k+BWSBFPuF7K5MUZznWrl1+C0Ex/5Ib3H7rBTZg9S5y0UHpuE4AvY6n+
	jkI/DwmCFbYWyclzFZomZ5VXEmJaXcu0kAodUiXJt7L3+RlrZbvVjLq10Grjd/BtwYgdFkqG4CF
	F
X-Received: by 2002:a05:7301:4683:b0:369:fa21:ba12 with SMTP id 5a478bee46e88-36a30009da6mr6910491eec.7.1793347297804;
        Fri, 30 Oct 2026 01:01:37 -0700 (PDT)
Received: from [127.0.1.1] (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429000f8sm4986017eec.13.2026.10.30.01.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:01:37 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>,
    Chris Mason <mason@kernel.org>,
    linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reject zero num_stripes in the system chunk array
In-Reply-To: <6ad220fa-d6a0-4b4c-a313-a0cc052b8637@suse.com>
References: <179328314071.648427.12527832319954042748@gmail.com>
            <6ad220fa-d6a0-4b4c-a313-a0cc052b8637@suse.com>
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
Date: Fri, 30 Oct 2026 01:01:30 -0700
Message-ID: <179334729054.2353588.12398743988940745859@gmail.com>

Hi Qu,

Removing the ASSERT alone is not sufficient.  btrfs_chunk_item_size()
computes

  sizeof(struct btrfs_chunk) +
  sizeof(struct btrfs_stripe) * (num_stripes - 1)

With num_stripes == 0, the (num_stripes - 1) term underflows in the
unsigned multiplication and the function returns 16 bytes (48 - 32)
instead of a valid item size.  The system chunk array loop would then
advance by the wrong size before btrfs_check_chunk_valid() runs.

So either btrfs_chunk_item_size() has to handle num_stripes == 0 first
(for example, return sizeof(struct btrfs_chunk) and let
btrfs_check_chunk_valid() reject it), or the early check has to stay so
the size calculation is never reached with zero stripes.  I kept the
early check as the minimal fix; if you prefer centralizing the rejection
in the tree-checker, I can change btrfs_chunk_item_size() and drop the
check.

Thanks,
Cheng Yongkang
