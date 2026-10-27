Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068958;
	b=eScFA5Zu76VljYeZK9YzDWPjopdlZWCUlBCiPVeOzMMsAm84VlDrumDVjKWJYN+MljCv
	 zQ/N8hJ6b5cKylGhMqcZ7lRmtwrjjOza8R53fQG882BKDLg7bchwrgBY4ccRx6ZeUlUTS
	 gCibAcH9Nya6Ynze9qqN6YGHdr0Paqo6SnQMqK0TZ1fDKt38+nB4/aI4IoRF0jiAWmC1e
	 6mHaUt+zLh/FlSqIPVwSYMfQ1tNxJHBFRKdTcxQqUL/+dW+uFYccd74HlOS/WozSeb2G6
	 xuzqI9IpG9NG95nI6gEEXocLrXSj07YJc/CAdFqIrnSxHt515kdt5hpT3xw0GYSGzeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068958;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
	b=Ra4z3DFCffTFxvqAP8iB8KzXWL/+nLjtbbt2PgDUTNlWivFFuvelwEJNqaIOQ916RlR9
	 KqstK+aGSIOSiR2h5C8k0p0OFKFM8hTcXLjzb6xFNOWJ8BFWpAhAtlKW0iY7peUlU04BP
	 MqnYgJZx766f4gaR37EXMxGPAy+KFXeRzzPxRqyjzXadMzCFW3DKq15al+/fC0pIAIBsG
	 YOIWeeAvfFDHJpaZk7Riir+/8B9fMDHB00PxixA+5gSOP9Wt92cXEpkjLB47rhaDLlxGo
	 9M0jD+5D59nXRuby2sdp1odDB7Cfa/8F87mHXaOBSpAaHTv51TbviKXWNBzd/UXDcEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=nAMLJ4po;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE5D606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 02:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FE5D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=nAMLJ4po
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-14fc585291cso1850450c88.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 19:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1793068957; x=1793673757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=nAMLJ4pov/UKnTCLgH305UyFiee1Kbb1n3tCzOl712VaepOkFQaBHOfe8TqG3p1lZU
         FcmqVqrrqUreTloBdzXh9C3S8RzvKdqK0Wdm3ymTtA2e7F8hg+g3tAXi0qMz5tjjKhfg
         XZsmI+gaR0xwl7nmIQiVOSWVXQuFdQ0nDSV/JTrdP8vh+zCmGEp4ByKhGzO7Q9EFAqG7
         Z9UxSRbzl1SyjYddPBfqeotnjUxiWUf5QMQHMI+2cHXwFS8e7Vcd6faApvoLAEI8hyVq
         H9p+0vB8HKXlTDO8gBcIdyEeUOqojMCpKudjjewsxrlbiMp0bSMq+X14CJGfZa/XuOHM
         djkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068957; x=1793673757;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=pw2+2iSrZJgVAnN6J4ii9PV5fFIZFqPQFM6ahVMZlqGVYeT6/pxgTfSr536R2bJBJs
         Vnn3dqNDBQZQ2l7WNmCrpysbOOF6tHG/ZGDv7TcFJ7ci5EMn0zF0wCVY3+iau4ZCHTqv
         nmAffwxV4GFqEbUoY9eY3RVKQoEm4E/iOIIdxqvjKj2AGG2WCcHtdt3SBDBTer9hdNQE
         C215DAXf4/TU2p+89TJfrj3XVzFQ7fRATqMkLlqHTjo40vTj0MBWCJUzj7HcV4aJm6Is
         DBEMw2g0/u6v2dsVS+Y4PmiAk9LYtBKeoutWBk30RrFg5ZZhgd/im6MJGYmNJ5nYL/h9
         T0Qw==
X-Forwarded-Encrypted: i=1; AKwUvByxql5/u/hp88MwFYsQW2t6Cvc1ZLSgMO/6togh2YrqvGj3TSVZCYK3fOoSgeJOgiQYGlPmgvT0F0DWwg==@vger.kernel.org
X-Gm-Message-State: AFq9FYI3C7TjkcSYJPnpnPthJ6bWkznA88kg2a5fxwVzQIpVmhLB4PNI
	fhZW7bRFzEezgwgJLihquwzxIuAu4MxXB9ABmxuqGqajQWhkczwgQyxmAEs8Lz8P+CM=
X-Gm-Gg: AYBFou3wSxmM7H49FNhAPvg9ooH5ImzAtFN8oyFoJX6JCNYeNnVSc+DGR7f73g7DnzW
	EiY23Vve9Q0kGOZk4s0Lgx0+7EKYV+izzD2cCYTc3SlVG/HaI0FbpXtUMn3dzWxMblb6NIsnt4T
	DCYR9OiotttBuDQVegXTEZGR3DN1B4gL94Do0EBb02FtlWoKVmNG+EBTXcQMVPX3B78uhau3cuU
	wygSZLULOuqkDlWC/frZ+XvSsnmrCK/kw7ufmgBzZwfhmkPHditxyu1RXiWzPNUwsxQFAqk0opc
	DIGDPEualy4C67E+FrCaIYtdoAaAaz6pQt7sS4jmW7lWnSY/cs7WWGWZsDPvu14xvHHhVfFH8r4
	TvWP6NdxZP7rOfW4QkIX4oULVT76+pTxwrysvCljcy/T6m+t2SDCO4lJ1+0YlpUzFRMcNqXyo54
	0dnjOHWXzY7EK7TrMfe/QSV1NJRFaWEqCeT8Sh//QnYSIOhQLPtqMj6n/xFvkX0o/rDHJgYDk4Q
	XXzD2BGZ2eFzD7HACXt7ucekPuJj0+AAEkzc2Db6yvtZum+ke7kPqGlpedxUi8xqZauMLkIhjIO
	1O4tbw+C/Ldo+oB7xTPFzPFBp9vP/eIB2ZpsQPw=
X-Received: by 2002:a05:701a:ca07:b0:144:fd7c:84fe with SMTP id a92af1059eb24-19937307669mr13761314c88.35.1793068957501;
        Mon, 26 Oct 2026 19:42:37 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a249c331sm59514670c88.17.2026.10.26.19.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 19:42:36 -0700 (PDT)
Message-ID: <30b1cf28-61e6-4f28-8e28-79815bd87617@kernel.dk>
Date: Mon, 26 Oct 2026 20:42:35 -0600
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
Subject: Re: [RFC PATCH 02/10] btrfs: Don't copy encoded read data to user
 memory when canceled
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
 <20261026215226.3713941-3-jthoughton@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261026215226.3713941-3-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

