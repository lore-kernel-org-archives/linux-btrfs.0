Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71C637F001
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 21:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788213563; cv=none; b=cCeT6xe1hkTM1beP4CLt50Uz2+nSp71DSuRkNjt3+b7E3ejrb+EaYc/Fwp7IvpFBGFDzpZS/3htTE8q5tqz3oatKEGamuOXDRoer0EtmK6QmwSNGhU2NR+ZH3l7BeNO3u13YhEXSnZYS1SutuZtdXS7hocDexOEDdt2gaGeLpLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788213563; c=relaxed/simple;
	bh=qSM4WGns2Z2dQOYqERfBSXjgWiSz2KIFSM4l1Xpjh2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIHveJeCSgsBPwXLQ88jsoyyPv8fkb9u2c2raO8RauckRBiOQtxSFzKIxqMkbhwlbBV6CG2eJYdzC2rcOfHryS0lJobmyOH3Vx8eaafbUzVS/jS/7IGAFjRJ+Vp0e2+C8nBiyBiET4v/QmE4Z9Bfi6YoVdEOP9xT4ZkFKePb53w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=raqt6I06; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VMhiz59Z; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="raqt6I06";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VMhiz59Z"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1DA8714000E8;
	Mon, 31 Aug 2026 17:59:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 31 Aug 2026 17:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788213561; x=1788299961; bh=i6Z/F84wAO
	0X6qJBrZNH/kQtbAgFevHwYK/0lp5L7PM=; b=raqt6I06V7fHaCM8WEnhM5JOWH
	+j9B6HDQ3HtdrL/W11dNZcuXDJ95rdpQB2S+HMSJlp85ylcmJ9XlzN+/YpmrPg+C
	Ze2u+iXdevjBHMAgA7hEK6sOCTA6jJKRwYdINlNhL9NSOxU9rjKV0VB1yGwW9H+P
	QcEbumVAVPZCFEqz5MJ1+tZyJ5QyQ4JFJ1sN7MdiXrWYQKy4MWF0JV+jS04nkiW1
	kqqIZq0hrbmTac5uXZEaZfsZGQCOZs86R2heiRtY4XgPYJC8eAo3zlYKWK0moVDD
	0PmmOW8qVxH7ci+1jvyO5t66jdDf2hi4RYVuqtaNMCViAowSROErLrnriRRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788213561; x=1788299961; bh=i6Z/F84wAO0X6qJBrZNH/kQtbAgFevHwYK/
	0lp5L7PM=; b=VMhiz59ZIjI4c1AyP/2vtMCzfiz+muTEL2tvtuAGHvNt1D2CEQA
	E3IcNhBk80qQT+MA+Sm3blu/wB190ZBT0uz2TdgSfrHzLbf+qi0mKz3chBw0X6t4
	TqZUvOIfhxdytwYwAJpuwykEKNA9S4n8yHVFV9vrjS81g5SGnmCPC0Acb959G5al
	k0rCtcx8T+qKZun3PD8QRK9zbKphVShFpTgepSPIE3MDblSUGRxXBcDQcs7fl7Am
	037dSU12kns//aoq8WL0S2TeHiOmuWWYSPV6V7Yb1D37UppE/MGeGcUWII6ya2gS
	z9/AkJcFym6S8hw39fSxDbTE8Kn1ECapnug==
X-ME-Sender: <xms:OPmVaond5tPsXy_xv6Uh55kzzmK7GGaYEbJjkwV9xHfTx4A1WA9Klg>
    <xme:OPmVavRgc14levFKKmp2bi53zivncl2qJmtIRP-o2sT_ShDvJ2nyE3nSvhAySQ1Jb
    qW-3PZRHgUWRIazJ_9so7JVzmqU5tXiMJxJIsRtqro_YuZv6bPo8kdV>
X-ME-Received: <xmr:OPmVakCIqQ0JPOyTFaPotGjfaf-RaA-_S5NR_Dd5pBSFITUSUuZhGJxqBPEjkEyChbQPeLJrAiiE_EByqSAuuICUF14>
X-ME-Proxy-Cause: dmFkZTEXVG33A4gXwpikdRAsYaq9QTbL4MXjxgongF7orcLQ/7sdus+f5xFUCNIZxs7wAb
    HfKNAV07l6vvtUK8jtjIrFwBpjGosTsYG+4mvgsIEGZIzvE8Wj1fd01UimBNa4T5c3kfnD
    2V3UvJ9fm4q64EKs8uunDRgm9UhUNuh213Pacx0eTLixRYsqV8jgXTBR754Zcgk/RgFd+L
    vJUjFjVqR4qghl8d/ZjhvKtdS1GrldzsHJL+L0tMwe1TfNc4gWElI0nzdq3/cr+X+a8avP
    QUurG4/zr+aTvxbXZGusgUQDNCKh1Da/8YiPs9y7WPDspEWTlIPLq1Aa6Y7ySSyo2GBBjU
    bVLM6bIAnzs1zTT1JNc4bipTlWDQU/QYwgjAyKcS8QXpKPNNTGd6O5LYlAo+GFnD60/szj
    /IDqot4y+xL1E7ryTGTcGWen5n4L86HA3AcaEGgB4ea6c9G3pCvGTce22Iiole7OPlbbAa
    fw0qiuK8g4UR19D79CctHfim6RiyHmQp1cH9YlOp7QJNsXVQ+Iu2jkWfCQ0qoXGWFgzd6S
    ziX9gNWunEayI2iQ26ofl1xh3eSR2CE8O1WlJzBzHwOD1PLwz3K6Oz9Jis9p0l/a6Xj5DP
    uPlRS/NLNchQwu7DKGQMoX5tHHjWK6B+8D6qBRUk4trV6Za8wGAzVGKEmb8w
X-ME-Proxy: <xmx:OPmVauQGYyXkv_c4qMyRZK-zr8eFQ_0g5fDG0d681sovhB6rTMyexg>
    <xmx:OfmVaqpC7F_iD2nuXK980LCfGJBCGJQiudxto2hmxCoHR2ZpYIvLxw>
    <xmx:OfmVaoyfxgaJtNIyuQP2qctFD3o4xA40HXdMZPyRVb7LjLO-8m2nuA>
    <xmx:OfmVanLAzEDcK8FQsxkP4v42oNubwnhHQc6aiHnhVirk3mORvMAU8A>
    <xmx:OfmVasp2urw2lDL31VsTvSX5wl8qfsRqog5F09kf2WQuWaNXMCgf3z2E>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 17:59:20 -0400 (EDT)
Date: Mon, 31 Aug 2026 14:58:41 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH] btrfs: zoned: handle RAID profiles in
 btrfs_can_activate_zone()
Message-ID: <20260831215841.GE325502@zen.localdomain>
References: <20260824161910.2009296-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824161910.2009296-1-johannes.thumshirn@wdc.com>

On Mon, Aug 24, 2026 at 06:19:10PM +0200, Johannes Thumshirn wrote:
> btrfs_can_activate_zone() only accounts for the single and DUP profiles.
> For a RAID0, RAID1, RAID1C3, RAID1C4 or RAID10 block group the profile
> switch matches no case, so 'ret' stays false and the function reports
> that no zone can be activated, even when the devices have plenty of
> active zones left.
> 
> As a side effect BTRFS_FS_NEED_ZONE_FINISH gets set and, since
> btrfs_can_activate_zone() bails out early once that bit is set, data
> allocations will fail permanently: writers loop on -EAGAIN and hang in
> btrfs_new_extent_direct() waiting for the bit to clear.
> 
> Each of these profiles needs one active zone per device, just like
> single, so handle them the same way.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/zoned.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 9d448cdd60c4..107833fcf2be 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2689,6 +2689,11 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
>  
>  		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
>  		case 0: /* single */
> +		case BTRFS_BLOCK_GROUP_RAID0:
> +		case BTRFS_BLOCK_GROUP_RAID1:
> +		case BTRFS_BLOCK_GROUP_RAID1C3:
> +		case BTRFS_BLOCK_GROUP_RAID1C4:
> +		case BTRFS_BLOCK_GROUP_RAID10:
>  			ret = (atomic_read(&zinfo->active_zones_left) >= (1 + reserved));
>  			break;
>  		case BTRFS_BLOCK_GROUP_DUP:
> -- 
> 2.55.0
> 
