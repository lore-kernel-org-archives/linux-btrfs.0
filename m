Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9C635C68D;
	Tue, 25 Aug 2026 08:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645441; cv=none; b=FJ17xsb9bXOISZ0qZIRb3mlcrBTRidKW0G/oWf7ExBCqpRv79iQY/4woPaS0LnauBCeFVo507BL2eCAuJHe+/7m0gOdtkb+daQV5Jhh1sJ2ThwdsrgWtLyC3HNRGZ6weqWfjWdO32HKxcoc4UMRr3ak9ka+z+r885sJ8v4rabOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645441; c=relaxed/simple;
	bh=BMH3oDI8ZBlCjrLninZ6A9NZ7CvvsjRbtDfytCR8g4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joiuZTaxYMKdQXrTmyHTGho9EMrFBB5r+rP9zpMzo8GlpHUve75Acv9M2eHKlqY693QeOCtXDunVxUHYP3mc/fFo/Az/SN5jz8LlCvDrjBM0cxwXbzL6smJvKzrb6KemtazwH2mnd/NLASARkOGvQSpejnW82los9hhOvXGl9Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=o7ySm/Gc; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="o7ySm/Gc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gQ6VQIJ6fv3b56/Bk38momabPT+9JuNngA0TTZFLM0o=; b=o7ySm/GcUBHgXpKDvLGxL4hr9I
	ZnhiKUviaxZGDczz/2QG8PJH9+C9xvajb2dgNu5SqrwafvC1ERl/+35nU5BdFV45htRYGvxHBrm1A
	6rBkL+iUJFUYAYRhkVHRAYoo/0jwbyhq5zk/8JwQI7wylQsRfYmS/GqASBE5FvuptcU2ZNf7tmmsZ
	GvOPZniUYzMyw5IbMunLqxDyHV7v8IncXiKb8AcyElACQn0FRQqaySBha2rkqjec9yDHa+bKckl74
	xESNOGezZoyQV7B3n4eMiesCc+1MRzp4hmYVNXHnSn479Bw9fXdkC+z6lTTXJvRzB97/xV7BqkqiJ
	xhwaQuFw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wymEo-00EIe6-2y;
	Tue, 25 Aug 2026 08:10:31 +0000
Date: Tue, 25 Aug 2026 01:10:25 -0700
From: Breno Leitao <leitao@debian.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	fdmanana@suse.com, boris@bur.io, wqu@suse.com, layton@kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] btrfs: skip the extent map tree lock for inodes
 without extent maps
Message-ID: <ao1NIwsVWLkceGoJ@gmail.com>
References: <20260824-b4-btrfs-em-shrinker-v2-1-a6fc80447e70@debian.org>
 <CAL3q7H4OC_UqJCEo-o=uNSwZsCPJPuw8062_Mv+5NPaVqPJfsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4OC_UqJCEo-o=uNSwZsCPJPuw8062_Mv+5NPaVqPJfsQ@mail.gmail.com>
X-Debian-User: leitao

Hello Filipe,

On Mon, Aug 24, 2026 at 09:14:10PM +0100, Filipe Manana wrote:
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks for the review and feedback.

> The current subject:
> 
> "btrfs: skip the extent map tree lock for inodes without extent maps"
> 
> It is a bit too generic, giving no clue that it concerns the shrinker.
> If you agree, I'll change it to:
> 
> "btrfs: skip extent tree lock in the shrinker for inodes without extent maps"

Please do, your suggestion makes more sense than the current one.

Just to be clear, I won't be respinning this patch: you'll update the
subject while merging it.

Thanks,
--breno
