Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613EF3E1225
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 12:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785500019; cv=none; b=LR8nIRtF5sqGh+CPtV9iop2erdDGZanXpu6qKGe5PetoVmJzqOLZykGZXfyjfxyUb+K6iSpr7nUx8qB093BDJYYy+RHm9yc9mVEwOjvTTeuiDUcJphteV5uW7PNNQ2IQG8rG1DdsC0zvx+8KF8rPOh3TRFE+yecEV5XleJg57/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785500019; c=relaxed/simple;
	bh=poAdgPSDKUQNgOIOvqxkj1X5zNb/vulpuzSTEtW1mIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXRShRxFD/rJIYtJ8pG9ICXSk41ZWiteEWLmQ7xEnxS4pcZaT0N5dSJJYaMMPj0gfiW2u3VO3Oi9+vrk99xK3D3VQ9Tx9aJyTk+ZK79yZfdJycuNqazL7/9BoWhR997NTygUSXLhshplg0gj3q/hku3bFQAXZ7+9TfJpiQjEHII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=jY9GwEhE; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="jY9GwEhE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=QdeG1gs5Qq7tDNg5WIuopujPZrFT43pDvUdOC5M7rbA=; b=jY9GwEhE9rsBtm6gTcdwHRL+q+
	l2U3qnzqj1uDQjY0zKK2H1T4r4Zv4afTodoAqV9GhtNHgYX82WX8qABr6/w20apkhZUaXfGwP6CP+
	AswVbpT09n2pKI4jTpHx3QGpfXB6FuOqej5fPmeIrCT2w1p3TJurXgjRiqGqyauszhWclZebi77hy
	pdWilCxQFerGRtmeYq6cW18H5bphhFYSM9Jg6TsFOGx+ozNexfG62Jb6sLXrvPyFUzq8C51XG6Uju
	+Vj9dENdQgOerlBmCQqqqBZ5v6wyPgY03/5FFeByD1wn9A3zgvdgUNZb88zD7lI62i+vP7kAbPT4z
	3rS9BEJg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpm7F-00A08y-29;
	Fri, 31 Jul 2026 12:13:29 +0000
Date: Fri, 31 Jul 2026 05:13:25 -0700
From: Breno Leitao <leitao@debian.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, David Sterba <dsterba@suse.com>, 
	Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] btrfs: fix memory leak in btrfs_do_encoded_write()
Message-ID: <amyRDM7N4GOHtskk@gmail.com>
References: <20260727115352.12622-1-dmantipov@yandex.ru>
 <CAL3q7H4ZQVwTMUEKyME=Hv0RupZEQ5-EaRm72jmg+Wc3aVgj1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H4ZQVwTMUEKyME=Hv0RupZEQ5-EaRm72jmg+Wc3aVgj1Q@mail.gmail.com>
X-Debian-User: leitao

On Mon, Jul 27, 2026 at 06:01:34PM +0100, Filipe Manana wrote:
> On Mon, Jul 27, 2026 at 12:54 PM Dmitry Antipov <dmantipov@yandex.ru> wrote:
> > Fix this by freeing an extent changeset before returning from
> > 'btrfs_do_encoded_write()'.
> >
> > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> Looks good, thans. I added it to the github for-next branch with the
> addition of:
> 
> Fixes: 7c0c7269f7b5 ("btrfs: add BTRFS_IOC_ENCODED_WRITE")

That looks correct from my investigation as well.

I've spent some time on this one, and this fix looks like correct. Feel
free to add:

Reviewed-by: Breno Leitao <leitao@debian.org>
Tested-by: Breno Leitao <leitao@debian.org>
