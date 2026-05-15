Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D576837B3F2;
	Fri, 15 May 2026 20:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778877877; cv=none; b=GIse8AIZxvQ2dIvzBBOlXUhU1i9BP8SRDT7dYWRHv4LQNwaA2wjdygOzcRHe8xs16XFKaXfZNjgNu0pu5GYTo+bijWpQA2fMqBP1UkUceMOIQx6QCDTGcCNKIT/8eudJOJLxsyM8vEdFXi3tE2dIarGteO9Bo5iOebbNSEr36lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778877877; c=relaxed/simple;
	bh=E1+eWqDxv6j99dZMDhlO+NNDH9oYnsJmpH6o+qF/hR0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=eDo4fU69+2vwDwBTZ97muihXaLNI6OKn1n/sVAzdNxrrD6+3fsQcgFkaLbV3wMLPNjrTxRvy0QQG5gCJDjV72qY35hBbXU65eCsmMMyFnXRr3IQJIlv1aa92e17KhGWEi7wyG3XZ8GnXnGMCgSM4/ivpSoEc9POhwS/oyXc90Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=HvwBqnLT; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="HvwBqnLT"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 64FJxdt93762934
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 15 May 2026 12:59:40 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 64FJxdt93762934
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026042601; t=1778875185;
	bh=yOPbK2OFF6IcrfoJraZaWua7RTa6T7n9+bq8VLS6qCY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=HvwBqnLT38+P8wOr09I0oo/MRbA0gltt1BvxpDB/CXoHAI/p9iMtZP4Acni9CBE8i
	 UuQANyZJcLZO9XcaPLGm0i1Xg+soCjS4z5NjIoUETnDDa930DiHBVRAOT/MRlLb9jY
	 QYrQ9QMS7lPYMHGvM8plKfNxe30Gl9az6f+vOCv0hNim3O4/Bdo2qSTnUxGO9V7Nx4
	 F46aEk0Mx5DZE0TAlF3l22P0Yw61+alulS+V4O2YtDdYTlzt2T6qIuwD2KE0nXfR9T
	 jNDuDCJ8yXY/CId0JmSkw1Ar6+GJQTs5O0RqwrWv5l7cMbOBEgdh93GvzIYQG1gbNB
	 I9HJmsdG2PKng==
Date: Fri, 15 May 2026 12:59:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Christoph Hellwig <hch@lst.de>, kreijack@inwind.it
CC: David Sterba <dsterba@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Song Liu <song@kernel.org>,
        Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Li Nan <linan122@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
User-Agent: K-9 Mail for Android
In-Reply-To: <20260515043705.GA3855@lst.de>
References: <20260512052230.2947683-1-hch@lst.de> <20260512052230.2947683-2-hch@lst.de> <20260512114231.GG2558453@suse.cz> <20260513054742.GA1018@lst.de> <0a8d1ff4-f5a2-49e9-aa45-d25dbe4ded40@libero.it> <20260515043705.GA3855@lst.de>
Message-ID: <34C16854-1065-4542-8836-DDED58EC1844@zytor.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 14, 2026 9:37:05 PM PDT, Christoph Hellwig <hch@lst=2Ede> wrote:
>On Thu, May 14, 2026 at 09:51:59PM +0200, Goffredo Baroncelli wrote:
>> I think that the David concern is : "what happens for an already
>> existing btrfs raid6 3 disks filesystem when the user upgrade the kerne=
l ?"
>> (I am thinking when a new BG needs to be allocated)=2E=2E=2E
>
>Then it will cleanly fail to mount instead of constantly corrupting data
>and memory with every write, yes=2E  Which clearly suggest that such
>file systems don't exist in the wild=2E
>
>But if btrfs wants to keep supporting this I'll just add a _unsafe
>version without the check in the core library=2E

I don't think this is a good idea=2E Error out; it is the btrfs maintainer=
s' job to ensure user data isn't lost=2E=20

The RAID-6 code has *never* supported only 3 units, and if it ever worked =
for *any* of the implementations it was purely by accident=2E Speaking as t=
he original author I should know; this was deliberate as in some cases the =
degenerate case (3) would have required extra trays in the code to no user =
benefit=2E=20

I would not be surprised if the kernel crashed or corrupted the page cache=
 in that case=2E
