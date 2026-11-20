Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183937;
	b=Kl328E+JpcuQ3pSBWAik7T5i7h8ZjMev4y7t5YJ/1ds6HIrxkvwt6c/jIs4F+6ndTIZJ
	 3OQxmyjppmP0zGa3hIcV5SFi4S+Z9sPmDfBdWuQd4yJ1VyzTxZd93iRFHEOhf3wTdavEd
	 3xr2eaOxfNWTku+zDnG2MiUhWKTDHeLAPwGeRSXDAWjGX2ezT8J3N4uT0cNfdO2WBzrjH
	 S3MpNNE+Q7LKSCJC4zKtMm+hbeN5p74TJ7Y/e3Uyx+YgEUwpEG87cmXSaOZz53xErJ9dY
	 vFri7bd+27yMIvNos//WymxyO/PzqH3Fiq5GfDJkB+nYH/Gk0ykQDvfdOaSKMzlghAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xbe6FEnNEDzgOKNdVMSNVPy6O8NMwRnW9Mm8QaM0+hc=;
	b=FsUw6TOJ2H9QxK6Ss6BO/UaUEz4QLneK5Cmr46vNhvmiqt4V/fiR0fp5L4aJMc3neSxg
	 DoPMt456EYEdWvPaMsTytpA//lUrDhycPbNHa+DSb0ocnQa6Ebm41ijq/Gqj8AJb9CNvn
	 pi+k9bUZjFWTBmiZWVzPbf8+/NcRPcUxTh8qMkk0n3yydbqwXkzYOLDLgMARt6oid5OKp
	 wlrldwVJzYsycUJFcmdei6Tp2iVfjMUZpaCUpLEk413HFFHTBoh6J3zdOCRdbhSzVpQJP
	 Jut77VUt9zHRsxfKgHoAfOBMGlynXwn26sTxDuxT+pTD/phofLPEVYARzM1Es87LTbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x1oBIf8U;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8F3606A320
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 14:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B8F3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x1oBIf8U
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a210470b49so8111775e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 06:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795183936; x=1795788736; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xbe6FEnNEDzgOKNdVMSNVPy6O8NMwRnW9Mm8QaM0+hc=;
        b=x1oBIf8UCCQB9dSubB0VIFuiEhC4yxJ2bx8+aem/zyiJBSiev2PW+qDo9bFGtnMAbr
         JDQxgdBFeyj8zytl1wLzSKbQMdZbtwHM5MExcLCSMLkfKXm+gTbY6uM01I3zT9etSQzD
         kAkISVney4cH+g9uVsITYGRZ4IwFWE3Q4+iduXrtFXEhPqB0h4zWMbgiu/Me0xi0l18N
         5e+zdm7UOnI2RCo+XNLr7PAF52n6geXRtF9UW8XjB4AmbBNLiikbHVsj9V3ifm/NzuE4
         KVGw//mpzWAmMt0DOMe19MrcpwbitUAZE1KZ7QBCDjQQ+LMMfDju/PxADk0YLL1ZzwjF
         emrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183936; x=1795788736;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xbe6FEnNEDzgOKNdVMSNVPy6O8NMwRnW9Mm8QaM0+hc=;
        b=cLYqZj6QQFvKYCCFNZF/GH5/g/VBLQFL3DgQl/D0spPhUzc/KetzLN0V1zhGb/HcVW
         Ol2R6Pc+e31enKNSAnR7tkYDhbS7SIu5pom7WZOo4+ThGDLWD7VVPvzJil2Enr9WMu3d
         TPsKOSs3kep8ZefHR833iK3JeF8twldq+B50aCztdjumx/HLVq1BBNSP93BJjmOUxsUq
         znEXM1CNB4AdDsw8Yoq0FmgfWyH6x6j5lnjhXbQE8cMYqWa+Bp/OviCAi8v9EQB7is14
         QsAJBtO1sCZ5kEt3zq1dNHEXQWSEWA43eBPsCxYoyk15MoasY5gPxyB5aeqygCM5u+2Z
         iqLA==
X-Forwarded-Encrypted: i=1; AL+hErE5KhE1dw9sDKtylQq80LGzGB+ve5aW26a9oNtFVWeblDfWUxaDmKzsnb7XiyEWdjSjiRg4rOiZwCjdyg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9TNalj1uMTjC+lyzBG8/uygYUc3rQsBZlI6YIbQbkYW9dM/yhQ
	hl/A6csPK1ibrkEod1QE6iS1YHuqKq0d/nNmTQ5qlNLgPbySuQ8l6Ngj
X-Gm-Gg: AYBFou1z+ArEd/72g477xx2h8na0zfKwcKAGTVa5MWlKFDy1v0eQLjAXivqAA82V9q2
	WmCs+wfN8hy22VSXbm8wzdX1YtAZ4CXyLXDJq/04CBGFy2lh34bvfcGCTiNYOqg1RJlIUOWEVNC
	qZyV5KEnIixqzcgOoLnrjU24KpeWxffs7koOEu6bw1kan6m0os5dmDz6otBDudgViIOjxyPknuX
	ua9mU/8p03WnE7ovkspaM7SXZUN6UYeyV3MB5Jm2lK1iN6sRn0kzreuCbT/iZwFeSx3VlIeF5NY
	v9B/xB4p9Fe9Jw3NHDQLoLSvadwo1hhQWHXQ+3iWMIpwgf1Ns63KA9rdJYjmtTsVqhN+kHM3HOO
	XuOorko8Qoiz2gJgaH0Qva1e9QyD3FSQ0d0cp1xQ/+aBaZhMx5KeUKfMAkWjlIPVBQCNEPu45SM
	H8DYfKqegtrLbNtptmzC7LQAbl+dhC0SIXCY145Qw7bG/C5Tgt9pz2g7aawkNUxXPU/CnGfMFu3
	z7hFyJ5GIlOFHfMs2upYZyblb3mlyh1DZiz3+neE2kEhwV8srQSlOcdYrAMyRFQbBjIIQqZxR0G
	tZ6WuI/3yAMwaVicZt66S7BPqIti0bRIrSU7169FBjIhgIGs7rwIRub1AR75LuC36X6+HoUtqzW
	WsTHzWXd0gvA=
X-Received: by 2002:a05:600c:5249:b0:4bb:665c:a078 with SMTP id 5b1f17b1804b1-4bb8893a89bmr70511015e9.28.1795183935808;
        Fri, 20 Nov 2026 06:12:15 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865a2sm92007655e9.3.2026.11.20.06.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:12:15 -0800 (PST)
Date: Fri, 20 Nov 2026 14:12:14 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, ardb@kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/6] lib/crc: x86: convert the CRC assembly to C
 intrinsics
Message-ID: <20261120141214.327eb0f2@pumpkin>
In-Reply-To: <20261120084158.GM2668564@noisy.programming.kicks-ass.net>
References: <cover.1795137348.git.wqu@suse.com>
	<20261120034220.GA11532@sol>
	<20261120084158.GM2668564@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Nov 2026 09:41:58 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Nov 19, 2026 at 07:42:20PM -0800, Eric Biggers wrote:
> 
> > So if we're going to proceed, I'd at least like to see a version that
> > compares a bit more favorably to the original.  But also I think before
> > diving into this approach I'd like wider agreement in the Linux
> > community (x86 maintainers, crypto, etc.) that the x86 intrinsics are
> > the way to go, and for there to be a path forward for DOITM as well, and
> > hopefully some interest in improving the compilers too.  
> 
> My 2cents go towards keeping the asm. There is no point in fighting
> compilers over this. The very same is true for atomics.
> 

Indeed.

IIRC the code loop had to go asm block because the compiler pretty much
refused to generate the loop that matched the source, instead it
generated one that added extra clock(s) to the loop making it slower.

I've also use some of the 'intrinsics' to write a short C function.
I basically worked out the asm instructions I wanted then tried to find
the correct intrinsic.
The whole thing would have been just as readable in asm
(possibly with some #defines to give the registers names).

David
