Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312B83AE71C
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792997; cv=none; b=dAgf73uIMcG1D/LQQ+WsT7ae2RZaQzYliGzGM84xfzYPrhRqPb7FuJVijPHueFxQgpW92TclPQnR/OGB/PWOuV20Vmpm/9nCiZTba4/Sa4R2/pzogpo95QBIJN6ejOPlHVUwBfZpOZASex/Rzy3lvBqtGcDXEl6VVRhAiQcIsHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792997; c=relaxed/simple;
	bh=Z8b72jIIlHZk8tgg2uvKJtYtBVOJCXFwoSVOcoJ/VMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IE/+6GDSuEEHAddlI71epda/I9/EoFszFkgf+vIbvXQW+p75lCrKvPsCeLdxmIo+bWJQMazC+ld5KBYiUyoqRJZQKkc9KvO0SsSAo1J5Vl0zRNFULGujGNYt/4deuS8rjnaxx9xJYEMxG2kRacPIymuL0JJUflrpDnD4hxTAE5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=QLvp0YI8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tM50A6L2; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="QLvp0YI8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tM50A6L2"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 62C657A00D5;
	Wed, 30 Sep 2026 14:29:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 30 Sep 2026 14:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1790792995; x=1790879395; bh=kN0adj54tJ
	l5NZ2XsPsQTqKuOngcKooozOMkD3SMlFo=; b=QLvp0YI8I6nz+ILlsk3TroRvBB
	zKzC2aGIOuYlb4jxjOf+96CBtAbMeTy881y2y9QaOi9TadxI9yy9REH/Pt61PAEi
	72hga0KRVzNIPKcLK9v8O5SaEYOP09KtOk9zesbEz152yF25HT/PMd0vUQ1GaKIn
	abYElaQLn/JvoD9O1QCOqIuJDpLD7liGTD6eB2W+CXv2YTIeN78HwAdU6Pt43h1F
	QcYfeqwv/IzuSg2av4zro4HLbRe0Z+9oysU2gdudxOSZGSlax8CNknPkP2ydD7ug
	rR/k16wz1UQpzVQdXDgbIxrS/D8opZcnYx7NihXQuTGhooNMy3ZXlSJoPFzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790792995; x=1790879395; bh=kN0adj54tJl5NZ2XsPsQTqKuOngcKooozOM
	kD3SMlFo=; b=tM50A6L2e5IKq+qOXWqpt+y/KvQO2qEaTLYcsDUyioxUjiCPuVi
	gW2/h6L30aZJKkAGuWbJmRLuaZjfItdfessxFVA0pKkgAM0LQ9kXcl5Pd4f2iZor
	pK36d87nFLhcPKvpwrRUSPKx7MEu3Cicl6+CL4dY1crjI5sOvV1+m+6OJIjYo88+
	o5wN0NaPOgRUB1Sbl567fzauYo0vVJY4fvlKAAC8cMQMvAZWGk3H7vC9rOPkgmtt
	sSPZTXa/Hhja9phbUUAMMzUC8UxpIj0bTjoIiSreE8m6Up9u18c1bCvZBEvja+z7
	IlPhEbr7f7lBkcw8kWLtvjonA53g5NgBEwQ==
X-ME-Sender: <xms:I1W9aiMbVbfe1_qUgzWXw0QpdQF9Q3eBvKE3dw1E8H5Z4pD4OtnYtA>
    <xme:I1W9am-fdbzDK849PONLQipAnTQCk6hWyN55IctQNS46RADD12MVjjaA1P7OLbigN
    USvhJpl4hdcY_PCFexNHGzE51MtAMQlGB28irb0De3tUOFgOrYgfcQ>
X-ME-Received: <xmr:I1W9am6S71uUYaEglnmUtPWHoBDML-09EzZhhWseML0EgLThkgbSQrw>
X-ME-Proxy-Cause: dmFkZTEEXtr5vhxD4b/mWlNa79PhsBXn2DC/S5/2EOTyFrBvqZwgpYbprotpVkvi1qvgWk
    EtRhlyrqtTck9Plf7y6iGZDglNd8xoRCg3NIBjUKt5a7K5a8Ef7/N4ynMOgntoJgGy3tdl
    EjRMfAtB9vFoRNSdPeW1/sluIsZMhdHHYp2F3ZHProBj9XikH9xusr38cNb+WiFEcTjAt6
    thE0dDHtabtSVRfg1Ra+f1OpOdR/5hx9iTq+pAwRGcCuDBX+BiJS691PdN42gmwzfhd+cZ
    M4yEA1GcAWqVpZZ1RYnUKmrGG3RkBY0GBcAZoMhPgw9Qu2kVItTPMVp1t9LqoH3vuBfiGI
    otP/L79w+1cYvHyLShemQZHn03MBkxT0Rzcgjg7huG/dOt1UAqt0LGkwRRr+w7OCypSZMY
    2qmp68oe0OF6pc53R+BJBrShdEXbkK3DtJC+Wcc5+ePLhfg11n9Bj3NQjc+A+H8ndTyyGc
    J7PiSU3absPgGyN/Zh9hV1X2lAF5zBruQ2cKe7XB1s+iNQ1tYl2aNqEOtjVm7RFrc+jkph
    A6Q2eg4tUQH6wuSSbM27+fAbTFmsVbOMLZpya8ty16rxqX8hGcDM3uRJyGnkWP/ga7ZBEN
    pH2d7qfvNvlu+Xe5lpgtNdXxRRjXlO1IR3PwxaTYDXU3QMtpWgcpjtLcvvHw
X-ME-Proxy: <xmx:I1W9at110usAdR4PDIMSIFrNEy-7nD4cEFJASUFcJbkoVdEzFb_3pA>
    <xmx:I1W9atA6A7bjmMVpfz47sTZ89GQT1XalkCDouYb0EPs3Pr_GnNwGgw>
    <xmx:I1W9av3VjptJ35VdTURYQWVy1BtWhmfgCfLXeSjaQBQYg-ySsmcqMg>
    <xmx:I1W9ansd4xZ8JLax8sQSFr3ztXk_mLcn-7mHMNAfvnv-CV3hFUpHog>
    <xmx:I1W9ah5EPSk-2GWzkCx2U7aGZTz5UK-TxN47Nz7I1MtuDPOhiIgKZxSs>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Sep 2026 14:29:54 -0400 (EDT)
Date: Wed, 30 Sep 2026 11:29:45 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: always use the second newest slot for
 rescue=usebackuproot
Message-ID: <20260930182945.GB3186434@zen.localdomain>
References: <cover.1788678078.git.wqu@suse.com>
 <377dbda4759e0c7bd95551a2f2b34098e4e0cb14.1788678078.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <377dbda4759e0c7bd95551a2f2b34098e4e0cb14.1788678078.git.wqu@suse.com>

On Sun, Sep 06, 2026 at 04:33:37PM +0930, Qu Wenruo wrote:
> [RESCUE FAILURE]
> There is a bug report that "rescue=usebackuproot" failed to properly
> mount the fs, but if using btrfs-mod-sb to use the second newest slot,
> then the fs can even pass the full "btrfs check" and be mounted RW.
> 
> [CAUSE]
> During init_tree_roots(), "rescue=usebackuproot" only makes a difference
> if the tree and chunk roots failed to be load.
> 
> The loading only requires the root node/leaf to be properly loaded:
> 
> - tree root
> - extent tree
> - block group tree
> - device tree
> - data reloc tree
> - quota tree (optional)
> - uuid tree
> - raid stripe tree (for RST feature)
> 
> And it doesn't really check any child tree blocks, thus for a lot of
> cases, "rescue=usebackuproot" won't make a difference.
> 
> [ENHANCEMENT]
> Instead of trying every slot and settling down on the first passing
> backup slot, always use the second newest slot.

IIRC, I was able to refactor this once where it would retry the other
slots after mount failed. It wasn't too crazy, assuming I am not
misremembering it, I even managed it in the pre AI era XD

https://github.com/boryas/linux/commit/9aaf3846f321d5ee1d24e7be6a8727e4560c08c8

Please feel free to use that code / idea if you like it at all.

> 
> The newest slot should always match the root info in the super block,
> and if it worked the end user should not even need to bother to use
> backup root.
> 
> Older backup slots normally have a very low chance to work.
> 
> Link: https://github.com/kdave/btrfs-progs/issues/1162#issuecomment-5475477108
> Signed-off-by: Qu Wenruo <wqu@suse.com>
 
