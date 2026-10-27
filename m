Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068886;
	b=oiVzOe2n6BzdhhUV2hQYxwiIHUlUwOUZEiDI2UHyNsYjxyVTMchgVOB3kGG8PcaEvMGq
	 vtsl3mL6FiJvJSdOnFvndhYJ66KouE5WTWRRhaclnsNvGaxn8M4Kh65Ee/qFb/FppjOhm
	 qy/JxMMRB6vQRY5klora01+NxZ3kXxr2ArMcQeyEWMwN6kibKCg/dyYph8Q8BSbmhNfYO
	 S0Af0sNXg/qtr4bBvYjXD96dJnVzr7qbn34cWiOdLCwnxGAVnevx5iZi/EyhLVUtgV4Ty
	 8GHmPPRNJcP81/2lN7zjj/9tQyMqaDdTggno96MEL0r4izagwW4lggU9qO2AIr411+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068886;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
	b=sqDw0ximQTCQnivAwnWdnh6fua81K2fEOvkQs9UceE6QDqiZ26hhKI0i3dXNWAM3tawG
	 3MY1frisK8m7KxD7/a0Z0UuVuuAJPbFosZOE8PvKdhnnhkayDDcemvy2uzxw3E8ncfoYl
	 PVQh9h+ORkYXlz/AIE2a4HPBKszsY8FCvuRmEXHb2TVLoqTsIDMetfo3BF7cvLQlIYfrK
	 6YTFqjcUsroSpA+y0MzXRV9A/z0hFPxt0vz9MfyVR3h/1N42dot2iPzYvPxOTZn3d7PWd
	 XVBmdDY6NFMD/Dl2FRtWUZEHmCgZEqoZPs/j7YXAU9b/gAd2Gi1q0zz8X4ZkIqnFtyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=oc6cZqFa;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA29606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 02:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CA29606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=oc6cZqFa
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-185fd3a4ca3so3125919c88.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 19:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1793068884; x=1793673684; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=oc6cZqFau/HqROtNMBTq8ZP3TLLLzMKPOdbVxFYEww/DOpOMHzAfKhTORNvN4KTBkp
         LUp5Moi9eFCEYu5/4XDZT8WcjpiPsCN+0zUGPUekQp2yZJY0zBe8yl4kYAkKqjEdTrbQ
         qqNSykJeEwW7qBFZEoQS1rQ+7ZwY381+e8TxKyiv+Q5rLJiCFF4PtyVkTxWHTKQMc6vO
         +lb3qFo71UgGSSnv6IseZ7y8wLhEFz6jBXh4HUpywe8jgXN4FoqKQy7CyAzCO9Yfeytz
         HBIYtHcP3MQ7eijYy79F5eSeZqsN4/+XnIDB6Cna6QVY5R0NQaf50jlOwAuklcgL/mVV
         dVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068884; x=1793673684;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=e4US7zo2AGdm0qWCVMjz4fW0SUe5mZ/d8HPs4eXWCPJPfWNgP31RNwCWK6O1WxUp9K
         cTxbbX4TS4VMRNJyQYVK2OcC+lhAjcAqyOQyZMnxok2YaBPGiIvAzofDInlk8fkX/ueM
         gBZCDvU+L8N+Fw/LgZE+jRhfk4bBkDDPDfXREpSe/cu4O8ny9oIqMHGBrdqbl+g/jdhR
         CalAw4q+4vxmPPVU3vyafV82qoygYwqWdfyqTWX4HGXiVtyZhS3t0BdeM8V3XQw8TnLx
         QICrsI2NH+30Lvxr2UU9QY+v4+tyId0gNcd4XMJ8u8hS6rK5Wbq4FZrNICcmKLTVkvVN
         PSWw==
X-Forwarded-Encrypted: i=1; AKwUvBw8r7sDEM6G2dZZH/Y9lnxh4HFLWDO6lqpo5g1oUIVLnEIasNdQMywM/i8waom7xDYKiDZP1jHdfTTHYA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLooNRS29AoGAamiSI7Ib9e6NxHq6jBXm3Z9Z0cnTox66zQfQAZ
	pncG1TftreKnYIRnIYQODifyuRYoZlM8fhnf/eZHweDG+VE0P6JxF9m0eKD/GCTQsHU=
X-Gm-Gg: AYBFou0Kl2YvgRy0ScHlQaQNJCpvQFcFTcstjrBzRIVb++S8rpy3Sh8TqBqp+GYZrtp
	ilaFgE0wczGtnEh1oYOWcaKofUzjxYuveo2mJ98gNrr0Wb/cu/StJWTTvjV/TLFU7h7C3xqyuXP
	lGZS3V+vEYzisBDr9S13hJcndcnVEbpOBt2w9HAgxY78bv1vUO2TxINffW3fZIJwK49qpStnE2K
	eaesxegGKvCkM8gPAxzzCtcgdgCC/dDVfr8sCfmsCXXzqIDMPfeNm6kzHqF4EvFnv3QGPoZm6z3
	7EGnXdAy1LbULe/GeUIBecJ0l2VV/3goK0KOhPPcWa2o0okO670WxqaMlaMwTt+PLSxHgL+PKQo
	qbT73j5q46vKy1UGruSHI4wkoWoKgZpSX53+CTknGL65VWYBVsSjj9GxenVzLm9ItSPdaMsId/U
	2IH3r5B+I6NkDyvU0UQPqCzGwMiWzF08OKI/B4JOxQLggy3e2ps/9I50uXPYobj4rReNYbTAkWe
	J9VmVvOvKEPgplUaq0WCdkc21NRLU+iUQBEAR29CwAb3rCD/kmUmwqpyh4Ji6bytWO/OYzuDB/r
	/t2lQnevWdWMa+/BAuomD31gSB5bvc/hVem3fBg=
X-Received: by 2002:a05:701b:4184:20b0:191:444:425 with SMTP id a92af1059eb24-199290fe40cmr12440066c88.2.1793068884148;
        Mon, 26 Oct 2026 19:41:24 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a1bfaf25sm29293759c88.14.2026.10.26.19.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 19:41:23 -0700 (PDT)
Message-ID: <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
Date: Mon, 26 Oct 2026 20:41:21 -0600
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
 io-uring@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-2-jthoughton@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261026215226.3713941-2-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

