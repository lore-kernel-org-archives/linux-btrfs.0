Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5A13B47DF
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 21:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788213130; cv=none; b=YzmSQHcpNMRx2TYYEI7jGvoJteEhUs9a+lYKLhIKfyYAhY53Tr7TO0m9r20I/rikWqagWtjAidpG2sVZEukKQX5GhUMKYcQie28J1k6TtX51bgEugmxAQZiZnqlIISQO7hqugNB48c/2enAv1Bljy76hHCBBtQrJvXLtTPGlTNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788213130; c=relaxed/simple;
	bh=MAP1J/eWidVRU9wJkJpq5xqx1umb2vM5zj2oSqoOwBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIIym9rWVk4ZXkEesXypKc8UusgAuzP623EN7dlrvXzJLlIDbzJjDlseprEJtQlFqfz/QMLNyuraQJH7WT049NAZZa/l1oQ1pLGKmADYE8DQmgF9ZtWwLY5YZDDIZ09edYXs/IjzsjCPvKbRtKECskJc/Nq4OAlNiVazp/9TPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=su9AWNzf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HJ5iYp4U; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="su9AWNzf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HJ5iYp4U"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id C82EAEC0116;
	Mon, 31 Aug 2026 17:52:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 31 Aug 2026 17:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788213120; x=1788299520; bh=QPYfjCiurA
	Okksguf0gWmk11qL9XuyOjwMA0nplZPo8=; b=su9AWNzfy3FpRCxUMRmIiDGWKX
	0QimBr+Bl7N5w7gPhCVVMLb4zyoAyWaEtQFiiPkAo1TXucn9V5fXGY2MwkIHgJrX
	EMyc5iwfvSSFST2jLp6JeXTC1AhEOJXxEqohKO3z97APzOOW0c5QsqbR8kDcQP5M
	VLfwQVvYf/GHDX+DfgPcmxVLvq4wkoP/WPtUBWYAIdsNWOL1em1YgvyKw7WLiGMK
	V1d33rT3PpIXMr3eBm2+eQAyjSLrDFzKo3ZWwQxebmu5h5cQSiJ1Oxl9/Lr38T1d
	1XFwkqMwpYK/ia4pBof1UJno700pxAjP2wgttevYS+Ud7S7CfT47kYSHqWkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788213120; x=1788299520; bh=QPYfjCiurAOkksguf0gWmk11qL9XuyOjwMA
	0nplZPo8=; b=HJ5iYp4UbEZJQMazeo5QTT7jTldbtueDUpUz642oSus7+BU1sPo
	jhxDS9DTEB3dO8VjZKD4rMVpWzzqgcAhlERU/vjY3hxvGJyshCK2ZIuJ07OqckVi
	/o7yeSwtYX9yMiRhaAjbQgvwjUjPDb3D8wm0F+Q2Lk4rIWbRfFV7jNPCF7E3zFOg
	iOSAGlTYhBS6Rws1qSsdZ9rNpQDOAPjJGYqBpTCiDMMYY1mFRHLx7auBBY1E508g
	rZ/kLFR2PvlDUXv5/fwsb1CfksLdo4q5NaqIR4VLD1x0Tf8xmqIjLlO4Kf+Pc7Tz
	EYBX3nq1xYe58BN2iqLmRH5lMT2h3YJc5Mw==
X-ME-Sender: <xms:gPeVali53F3Ac6shF6jiWQUjp5gqQUEcWvIdxNqUKQ2HZCISWm2f_g>
    <xme:gPeVagCaM0td94v6_Y-CPrLkxRB4qQMjoqJ7yzs2_1NTFHKVAO_Di7JjYokpgLhhs
    VttrXGbwgPrM1nKVAcY3djj6tm_XL-jJeH8Rxk7N2s1HpFpj8bfZ7lS>
X-ME-Received: <xmr:gPeVaiuInY260qKt3Zj1zTzU1LnqW38gZgFdR_lTcgIFZHhyZ7qyPZbKGCMfX1JtegwWB-vfa5-oYoc8xItsD80a7ns>
X-ME-Proxy-Cause: dmFkZTGY2aRhju9KILhs76dSDw98LP9Wb5EnhzJiISrD/HV09CJqIrWC/7QutApiLmFF2B
    oZNAWYztgXTULVGxSv+cF02zqZUJrs0KFpbgQAv8Rp995tTfwNQ52bg3HW9Y5Hc2NRzJVR
    z0gY7D+HHRe5BAY1ygNnM3W2Wm/dQs8fgx0Q8alKlsYsIgbgomqE7pSBuUMTbrDhF+v7as
    Z8lU+e4GRCNW48hjSkvqQ85eW7EhWDlwyI3ZodVLopoPV5F1QSo+e6U3LTpN3bUIQTlVCu
    l2Mesu0p3m99eNO3GDgwo5xdmpqk3Ho/GhAoBv/n7ClBXSiVnN//Sj2tOMOn5vK1bXD1sa
    S1fJLGA685wCNZ2N4SJsNgx3AV82QiCXtW7n3nVNew4QNBl2a7jdotxWgeAEaTv6yv8h3H
    QBR5vY8wluu+lZvKj6e1jJNMlFg5oDQ/+ies5hTa8azTRU1jIQx+G6zOJA1t3a5oF5Ud8F
    Gkkpj2g8nAmqPI5R8jfz1iYO4yiJ+xlBJ7kOBCgm3T0L9zCeivXJVw6SGbzDweZvem47CT
    U8dIkZDNpLrva++W9MoQeXYY9T80fx7rrnrQI1FNU2VtoTPNXucq7BxeULoAFFg26iS0Xx
    gPiYY8JEaPlKDlz+xWK4M6hI3J0tbTezh+PMa7798m9BCv4CAM3633Rfnz0g
X-ME-Proxy: <xmx:gPeValbl580M-A5muVI3DP7YbW2SZp9q0PHUUXXwoSiyK5DITt7ceQ>
    <xmx:gPeValVn1uyQ0uRc6ubtWWiZbqrq3Y1863IKNYmA0D3yGRJrEDvf_g>
    <xmx:gPeVap5IFA4Bjr3dCK5WppWgpVKPoBhi20RHzMaCxDc7ixsO_oyqKw>
    <xmx:gPeVagiSHQnp8nOlE5NFVBLyDShmP_aw7nFOJbO1Ji6HzhKMjruAWw>
    <xmx:gPeVarslZCF3v7f_MoDb0pBItuOQBmCXaBWlqeRXljtuhUIRdYPrWAZe>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 17:52:00 -0400 (EDT)
Date: Mon, 31 Aug 2026 14:51:20 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: tree-checker: add qgroup status item check
Message-ID: <20260831215120.GB325502@zen.localdomain>
References: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>

On Wed, Aug 26, 2026 at 07:23:15PM +0930, Qu Wenruo wrote:
> This adds the following checks:
> 
> - Key check
> 
> - Item size check
>   Here we do not require completely matching the older or newer qgroup
>   status item size, this is to allow future structure expansion.
> 
> - Version check
>   Again it's not a strict requirement for the version to match the
>   support one, but to catch obvious bitflip.
> 
>   And the kernel will already reject unknown version by disabling qgroup.
> 
>   So we allow any version that is no larger than U8_MAX, which I believe
>   we won't reach in the next few decades.
> 
> - Flags check
>   Mostly to catch any unexpected RUNTIME flags.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Loosen the version check
> - Loosen the item size check
>   To allow older kernels to mount future newer qgroup expansions,
>   other than completely rejecting the qgroup tree and failing the mount.
> ---
>  fs/btrfs/tree-checker.c | 64 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 0ce91396b517..ff268ebb22d7 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2313,6 +2313,67 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
>  	return 0;
>  }
>  
> +static int check_qgroup_status_item(const struct extent_buffer *leaf,
> +				    const struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_qgroup_status_item *qsi;
> +	const u32 item_size = btrfs_item_size(leaf, slot);
> +	/*
> +	 * Since the introduction of simple mode, the size of qsi has been
> +	 * enlarged. We need to handle both the old and new sizes.
> +	 */
> +	const unsigned int old_qsi_size =
> +		offsetof(struct btrfs_qgroup_status_item, enable_gen);
> +	u64 flags;
> +
> +	if (unlikely(key->objectid != 0 || key->offset != 0)) {
> +		const struct btrfs_key expected = { .type = BTRFS_QGROUP_STATUS_KEY };
> +
> +		generic_err(leaf, slot,
> +	"invalid qgroup status item key, has " BTRFS_KEY_FMT " expect " BTRFS_KEY_FMT,
> +			    BTRFS_KEY_FMT_VALUE(key),
> +			    BTRFS_KEY_FMT_VALUE(&expected));
> +		return -EUCLEAN;
> +	}
> +
> +	if (unlikely(item_size < old_qsi_size)) {
> +		generic_err(leaf, slot,
> +			    "invalid qgroup status item size, has %u expect at least %u",
> +			    item_size, old_qsi_size);
> +		return -EUCLEAN;
> +	}
> +
> +	qsi = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
> +
> +	/*
> +	 * The version (1) hasn't changed for a long time, but even if we
> +	 * are going to support a newer version, it won't suddenly jump
> +	 * over 255 in the foreseeable future.
> +	 */
> +	if (unlikely(btrfs_qgroup_status_version(leaf, qsi) > U8_MAX)) {
> +		generic_err(leaf, slot,
> +			    "suspicious qgroup status version, has %llu expect %u",
> +			    btrfs_qgroup_status_version(leaf, qsi),
> +			    BTRFS_QGROUP_STATUS_VERSION);
> +		return -EUCLEAN;
> +	}
> +	flags = btrfs_qgroup_status_flags(leaf, qsi);
> +	if (unlikely(flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK)) {
> +		generic_err(leaf, slot,
> +			    "unknown qgroup status flags, has 0x%llx unknown flags 0x%llx",
> +			    flags, flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK);
> +		return -EUCLEAN;
> +	}
> +	if (unlikely(flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE &&
> +		     item_size < sizeof(*qsi))) {

I assume this SIMPLE check is because enable_gen is new after the simple
quotas change and that old qgroup status items will be smaller still? I
don't think that checking the flags of the given item makes sense,
though? If we happen to not use squota the flag won't be set right? but
if the size is tiny we pass this check anyway? Or is the idea to look
for specifically squota status items missing enable_gen? Why not look
for normal ones missing rescan or flags or whatever?

> +		generic_err(leaf, slot,
> +			    "invalid qgroup status item size, has %u expect at least %zu",
> +			    item_size, sizeof(*qsi));
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -2394,6 +2455,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>  	case BTRFS_REMAP_BACKREF_KEY:
>  		ret = check_remap_key(leaf, key, slot);
>  		break;
> +	case BTRFS_QGROUP_STATUS_KEY:
> +		ret = check_qgroup_status_item(leaf, key, slot);
> +		break;
>  	}
>  
>  	if (unlikely(ret))
> -- 
> 2.55.0
> 
