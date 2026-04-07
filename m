Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D2634F24A
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 21:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775597482; cv=none; b=Q3epbzoLQOlbLWtYyAiCFOfzUfRSevFePxpjSGSguNF/aDQ8+cOGNxA/vMsrSxpVgWODlh1L3lrtiBsur2/OrnGtCxT5zGTD+Zd/XOGkrK1AYGurUJTo8Xpubd91PkGG4CfnroB4nj7aFLHu95fmoxRrXz0albo+MIz/fB6VqbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775597482; c=relaxed/simple;
	bh=CauJq0PFsI6cQglf2yTJP7UDOqjqy3wT6tV3E3UDTXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqnoD+CibXMIH/28B+fzYoWaiQTN0hiNE2XU3coFNTnkme38ZqYOA/lc8lONNQ31dHU2EpMn8GRWRjzu29eGlCbdnjLqTpMF4czWYqlihVE1B63uZD4JH1CwnBlB0U6dLz03K/JzEroP6C69wAdeWyopM0Mxc7Qi6TgnS68ep2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=k2oL2614; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MSjCvVVl; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="k2oL2614";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MSjCvVVl"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 25AA9EC0181;
	Tue,  7 Apr 2026 17:31:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 07 Apr 2026 17:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775597480; x=1775683880; bh=ThKghE/M+2
	GqU9+9yWbt5hpAgYV6QyFsT14r0AaI8KE=; b=k2oL261416yYxcJ0FyaQFrNTvG
	tQkl6OTg1Em0GLZkGkfHisD28do/k0CjzZ29saqoGuPiXBI6DiA/mdA/0oFDD1ur
	jwzwZtsqDd1OcNzDFdrzETTRtWlqc53OxuH0XSVkSca5mCmqxDbCrBR6CYECULyG
	0FfsDeHF3+cK9VVL4aSOD2NQ24aLFQe1xcJRExyBHQoxFCEaoQ2uNWhncN6yIIQw
	fPj/uUy8VozQCOEDwY5Q2rNE1oRFSwXZBbWJ9P/Ns2bixmSEFyJ0YhR2Y05X9No4
	SBBSQMqS1AogKoVYJkgLk4fNQTTBkgZ1ePK1lndHY1ne/yEdIEp3dGrTf3pA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775597480; x=1775683880; bh=ThKghE/M+2GqU9+9yWbt5hpAgYV6QyFsT14
	r0AaI8KE=; b=MSjCvVVlIl6ulm11pfsX+ZEAyBGhYYBAu9diKsSklgfWGXrnIIX
	taEB7toplv0GAlKyjS/9otD9yjUSb6hxDJDkOuOmJezNc4i382ovCQD3HEUKnFty
	To7iruKtLw52nrgQZoEH3qg1dJ6/RDg1TRWDBbq9JiPrmqPTSwSN7Ykk/HFT2oqX
	gZZb5FzSiqKv9HEK5gLmOFOKY/3czh5mrZjuIvtELdS/A9m8FBBX9JlcEt/Q176G
	g15sEuZqDzeGsDP7BYYHA49A9yXI/VhxX0U3NZV29lh9x51iGV3kzlQov2xMKY3e
	x+PSOIQRKwv7eq88TF1tQ3boH0ArM/1JD2A==
X-ME-Sender: <xms:p3fVae39i4Yk0qlOFRIaigr0PiHPGnjzwiu832_ftiEhkzejFhfbxw>
    <xme:p3fVaXGrzYTq5yaX13L8zkjYEL_0cUVkC3V06sfRek262v-icg0H_k_OIogNfyFX5
    SUX_dBqTd-Tnobzlr7VB7_JNzxEfyK2KTgppf3Gr-l_3uUvJK_lUx4>
X-ME-Received: <xmr:p3fVaUh7DpLpT5Y2jYxT1MeZpjfuHIoVsRJzEeT1jE6p7SrwZL4fBVTI5QJvK-Qmmqcn5-qU0iVjzmJ2odxzygJn2JU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvudejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephedthf
    evgffhtdevgffhlefhgfeuueegtdevudeiheeiheetleeghedvfeegfeegnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhgrrhhksehhrghrmhhsthhonhgvrd
    gtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdr
    ohhrgh
X-ME-Proxy: <xmx:p3fVaa92J3Gv3Np1O7sxGKjzY2SKhf6ePT4Ljo7oG4MUdKRcHc9XSQ>
    <xmx:p3fVaTpAibcLFSczLBdzM3xfekXRU5JQ42S1sYIHOMx7Fs5nKsuEVw>
    <xmx:p3fVaR9gNJT4_rFKHjNoDEuR1B5_akVl5Kl9ROqncLzlLrRth52cxg>
    <xmx:p3fVafV50YJ4cJwf4AgEOAyAZzfV0lR76SRSkAFn8ruV0A9a8BwB9g>
    <xmx:p3fVaZIF5KS32VuOFirpqzcbtpTw69mln4h0hKsPuhXlU_1nuZ4vkpKE>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 17:31:19 -0400 (EDT)
Date: Tue, 7 Apr 2026 14:31:10 -0700
From: Boris Burkov <boris@bur.io>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: abort transaction in do_remap_reloc_trans() on
 failure
Message-ID: <20260407213110.GC1564178@zen.localdomain>
References: <20260407161703.123545-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407161703.123545-1-mark@harmstone.com>

On Tue, Apr 07, 2026 at 05:16:56PM +0100, Mark Harmstone wrote:
> If one of the calls made by do_remap_reloc_trans() fails, we can leave
> the remap tree in an inconsistent state. Abort the transaction if this
> happens, to prevent the corrupt state from reaching the disk.
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
>  fs/btrfs/relocation.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bddd5..277a0042967665 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5089,6 +5089,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
>  	btrfs_free_reserved_extent(fs_info, new_addr, length, 0);
>  
>  	mutex_unlock(&fs_info->remap_mutex);
> +	btrfs_abort_transaction(trans, ret);

Counterintuitively to the usual pattern of sharing code in fail: labels,
I think it is quite nice to put a separate abort at each failing code
path that requires an abort. That way we get better diagnostic
information on what actually went wrong.

e.g. a recent patch from Filipe unfolding it across a function call:
https://lore.kernel.org/linux-btrfs/99743ac0b4b9a69dcaa8f9adcaf301bd1a0f1a89.1769163248.git.fdmanana@suse.com/

Thanks,
Boris

>  	btrfs_end_transaction(trans);
>  
>  	return ret;
> -- 
> 2.52.0
> 
