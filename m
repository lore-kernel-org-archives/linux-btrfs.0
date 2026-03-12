Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A05A2DF68;
	Thu, 12 Mar 2026 00:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773276888; cv=none; b=B6jxifE9OT/lpJuzjggEKKmz6lh2Yw9GLVdFjbFeAzqW6rOB1LmgZH/jwaUMDtaCpnJ3jBnTreHSnKXtFjg3hcf2n/x9s655WWBOjicwgeu9Srwpyc3HnLg/r3UOpCPP7yZzrcqqGAFCmvCVEinYPLPIJHyE7nrGLEzlJU4jDrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773276888; c=relaxed/simple;
	bh=SuqAhThH82+S6Gh7IKidJqQh0WkKbmHEI0mLdj41Lhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVsycNPGQTb5GFlgnskZ301zgZmiCCdMQoU1cRYsmznIWRQcoqo+PsFqtbxmipfMknp73kAa13yibEX8O8r6q7UdmMNyJvq/9Yoo0RMx5iQcIDQS8OZRGZMqYUQGsWHo1MVngVAkKuDYZULCANthMq+hGiKnp7myUj6pTDTf1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYtQvxRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYtQvxRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1C9C4CEF7;
	Thu, 12 Mar 2026 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773276888;
	bh=SuqAhThH82+S6Gh7IKidJqQh0WkKbmHEI0mLdj41Lhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QYtQvxRUl11pl5l03BQKBUEhgz56QONgnc2kaGayekmZntDuW/DKkgurHrtCHVzzs
	 jpzzJjdAShhodIdN30vG9BPjCGnog9HpZIv3Ee0j42lQ55g9wf0ey8DeyUwaZkDcUo
	 4IvGmBikopdR5eDiCqVY5kEdfVy5EMQqlCxr0Rm08gOIgv6qvhtdqONByqr1wqOCXa
	 ZSAEynUTw1U5vN3Lh/xfYRtxUECIxa4mzvwmHHsLJDVTH87rKEV1Ydpjtj8g8OkqPM
	 cpwxJ3lGXlQMEM5y7yL+b70SoAEJHFaitkwrhg6zFleNIqac+qEk2ZzSAvW9Vp85Y9
	 y03Osm7E2M0kw==
Date: Wed, 11 Mar 2026 17:54:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
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
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 27/27] xor: add a kunit test case
Message-ID: <20260312005444.GA31906@quark>
References: <20260311070416.972667-1-hch@lst.de>
 <20260311070416.972667-28-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311070416.972667-28-hch@lst.de>

On Wed, Mar 11, 2026 at 08:03:59AM +0100, Christoph Hellwig wrote:
> diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
> index 4359971ebd04..97c123806466 100644
> --- a/lib/raid/Kconfig
> +++ b/lib/raid/Kconfig
> @@ -6,3 +6,14 @@ config XOR_BLOCKS
>  # selected by architectures that provide an optimized XOR implementation
>  config XOR_BLOCKS_ARCH
>  	bool
> +
> +config XOR_KUNIT_TEST
> +	tristate "KUnit tests for xor_gen" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	select XOR_BLOCKS
> +	help
> +	  Unit tests for the XOR library functions.
> +
> +	  This is intended to help people writing architecture-specific
> +	  optimized versions.  If unsure, say N.

The convention for KUnit tests is actually to depend on the code they
test, not select it, so that it's easy to enable only the tests that are
relevant to a particular kernel build.  So instead of
"select XOR_BLOCKS", this should use "depends on KUNIT && XOR_BLOCKS".

(Yes, I got this wrong in the crypto and CRC tests.  I recently fixed it
in the crypto tests, and I have pending patches that fix the CRC test.)

There should also be a lib/raid/.kunitconfig file containing something
like:

    CONFIG_KUNIT=y
    CONFIG_BTRFS_FS=y
    CONFIG_XOR_KUNIT_TEST=y

(CONFIG_BTRFS_FS is there because it's one of the visible symbols that
select the hidden symbol XOR_BLOCKS.)

> +static u32 rand32(void)
> +{
> +	return prandom_u32_state(&rng);
> +}
> +
> +static u32 rand32_below(u32 ceil)
> +{
> +	return __limit_random_u32_below(ceil, prandom_u32_state(&rng));
> +}
> +
[...]
> +
> +/* Generate a random length that is a multiple of 512. */
> +static unsigned int generate_random_length(unsigned int max_length)
> +{
> +	return (rand32_below(max_length / 512) + 1) * 512;
> +}
> +
> +/* Generate a random alignment that is a multiple of 32. */
> +static unsigned int generate_random_alignment(unsigned int max_alignment)
> +{
> +	return (rand32_below((max_alignment + 1) / 32)) * 32;
> +}

As per my comment on patch 26, these should just use a simple mod
operations so that the new random.c helper function (which conflates
cryptographic and non-cryptographic random numbers) isn't needed.

Maybe:

        return (rand32() % (max_length + 1)) & ~511;

and

        return (rand32() % (max_alignment + 1)) & ~63;

> +/* Test that xor_gen gives the same result as a reference implementation. */
> +static void xor_test(struct kunit *test)
> +{
> +	void *aligned_buffers[XOR_KUNIT_MAX_BUFFERS];
> +	size_t i;
> +
> +	for (i = 0; i < XOR_KUNIT_NUM_TEST_ITERS; i++) {
> +		unsigned int nr_buffers =
> +			rand32_below(XOR_KUNIT_MAX_BUFFERS) + 1;
> +		unsigned int len = generate_random_length(XOR_KUNIT_MAX_BYTES);
> +		unsigned int max_alignment, align = 0;
> +		void *buffers;
> +
> +		if (rand32() % 8 == 0)
> +			/* Refresh the data occasionally. */
> +			xor_generate_random_data();
> +
> +		/*
> +		 * If we're not using the entire buffer size, inject randomize
> +		 * alignment into the buffer.
> +		 */
> +		max_alignment = XOR_KUNIT_MAX_BYTES - len;
> +		if (max_alignment) {
> +			int j;
> +
> +			align = generate_random_alignment(max_alignment);
> +			for (j = 0; j < nr_buffers; j++)
> +				aligned_buffers[j] = test_buffers[j] +
> +					generate_random_alignment(max_alignment);
> +			buffers = aligned_buffers;
> +		} else {
> +			buffers = test_buffers;
> +		}

This isn't taking advantage of the guard pages properly, since it rarely
selects buffers that go all the way up to the guard page.

If the guard page testing is going to be included (which is a good idea;
the crypto and CRC tests have it and they already caught a bug using
it), then the data should be placed at the very end of the buffers more
often, like what the CRC test does.

> +		/*
> +		 * Compute the XOR, and verify that it equals the XOR computed
> +		 * by a simple byte-at-a-time reference implementation.
> +		 */
> +		xor_ref(test_ref + align, buffers, nr_buffers, len);
> +		xor_gen(test_dest + align, buffers, nr_buffers, len);
> +		KUNIT_EXPECT_MEMEQ_MSG(test, test_ref, test_dest, len,
> +				"Wrong result with buffers=%u, len=%u, align=%s",
> +				nr_buffers, len, str_yes_no(max_alignment));

When align != 0, this does the comparison at the wrong offset.

The message also shows "align=no" if fully aligned buffers were used and
"align=yes" if they were not, which is a bit confusing.  Maybe replace
align=%s with randalign=%s.

> +MODULE_DESCRIPTION("Unit tests and benchmarks for the XOR library functions");

There's no benchmark included (yet), so that should be left out of the
description.

Also, I tried running this test on different architectures, and in
qemu-system-sparc64 it crashes with an alignment fault in xor_vis_5().

It goes away if the minimum tested alignment is increased from 32 bytes
to 64 bytes.  lib/raid/xor/sparc/xor-sparc64.S has a comment that
documents a requirement of "!(((long)dest | (long)sourceN) & (64 - 1))",
i.e. 64-byte alignment.

So, it seems the assumption that 32 bytes is the maximum required
alignment over all architectures is not correct.  The tested alignment
will need to be increased to 64 bytes, and the kerneldoc for xor_gen()
will need to be updated as well.

- Eric
