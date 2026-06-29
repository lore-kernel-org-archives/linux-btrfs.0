Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC6E308F39;
	Mon, 29 Jun 2026 12:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737345; cv=none; b=LOMFCeGZZo0K4Rpkqwwm3T6e/fegF5CM9Y5piXcVq6rYLGGKhqy63GuqI12YwiiIjAGwa8RWrVw/2eAzALR4lyfhNSCVvBPhQCcKE5h4hlauFy+N9MxL8TCTghk3HQMzRzjiEZo1KMEC/gN+0lukKsw1RKRCTZStkgb2TbP9CUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737345; c=relaxed/simple;
	bh=dOiWI9rAk9m3iKzSvKs1GkOUcNk5qAoM6lL9iglnT8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxfVeVWhVCcZOV6KLWV+0QqbWfllwyJkC/Pq1t/6kZZiaXgQ4nvn7xWLQvV+4qnfOR9EVa7ITSRGxvBp7UHGPp+g15N6zYPPwVE+cMXZfd7tGb5SiV8F5zCqZMsZAJq3DPy1Y7cmJKoHJBoQdCq8MsOf1TJLR6BMDVhgezkDbX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8495D68B05; Mon, 29 Jun 2026 14:48:57 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:48:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
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
Subject: Re: cleanup the RAID6 P/Q library v3
Message-ID: <20260629124856.GA23695@lst.de>
References: <20260518051804.462141-1-hch@lst.de> <20260518141205.c100f76eec5f58e78bbbf7af@linux-foundation.org> <20260519082432.GA14956@lst.de> <7d8efc7c-65e3-49f8-9381-910de7affef2@zytor.com> <20260629122152.GA21344@lst.de> <8684FEC2-AD56-4BDA-874F-1D3D7170F880@zytor.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8684FEC2-AD56-4BDA-874F-1D3D7170F880@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 05:34:41AM -0700, H. Peter Anvin wrote:
> The real issue though is that the benchmarking isn't really helpful, either. 
> 
> It has to do with power across the whole chip, so it perversely enough depends on what *else* is going on...

Yes.  And preferences might matter if this is just a file server or
something running a real workload as well.  But I don't really have a
good answer to that.
