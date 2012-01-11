From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH v2 1/3] Btrfs: add the Probabilistic Skiplist
Date: Wed, 11 Jan 2012 02:36:31 +0100
Message-ID: <20120111013631.GU7322@twin.jikos.cz>
References: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com> <1326180696-3614-2-git-send-email-liubo2009@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com, dave@jikos.cz
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326180696-3614-2-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2012 at 03:31:34PM +0800, Liu Bo wrote:
> +static inline int generate_node_level(u64 randseed)
> +{
> +	int level = 0;
> +
> +	while (randseed && !(randseed & 3)) {
> +		randseed >>= 2;
> +		level++;
> +	}
> +
> +	return (level > MAXLEVEL ? MAXLEVEL : level);
> +}

This is counting number of trailing zeros * 2 (except when randseed ==
0), there's a gcc builtin for it __builtin_ctzll and you can turn it in
a loopless inlinable function:

static inline int generate_node_level(u64 randseed)
{
	return randseed == 0 ? 0 : __builtin_ctzll(randseed) >> 1
}

the builtin should be safe on all arches without the need of libgcc
support, there seem to be handcoded asm statements for each arch.

microbenchmarkg of builtin vs while-counter showed 2.3x speedup:

builtin: 1.866529 ns/loop
while:   4.265664 ns/loop
(1<<32 loops, on a generic intel x86_64 box)


and if MAXLEVEL is <= 16, then you can generate just 4 random bytes and
compute the level in the same way without any loss.


david
