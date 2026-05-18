Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCA39A818;
	Mon, 18 May 2026 05:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779083787; cv=none; b=qyt5+tUauqlXvKXgA8qbJzaB6UmFBDBz7o0h/UrcXxVHH+uMbMfF0wfcAxAx2w76frLk9YSAUmayqx2FqUKaqfX2muuQm/XL3JzuDArAEJUWK1dDeCDJoBOy7tAIhPZFZU+D8zSv9yxKbnjuHyKqkHjgG64ARBovqwoHUNoQxS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779083787; c=relaxed/simple;
	bh=lYZe3gr+6niE48PiLVZnHCvb8THtsQT6CpZCu857MiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doZ1Eq/1tSMQifqTrmQ4bvvgpdwd0wzSj4tDaFO1VL3Z/Z1VQErKlZVMEENdgokcp474negEPC+1cG68VzjEv/Ytv+atQR1s12BitlCQzfl6/+vA76zzoonZGq6ImcFMXYm2Sj07AKR2Src3cFIozyj6+WxfkmN1Dt4I0iTx0fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F0D9B68C4E; Mon, 18 May 2026 07:56:17 +0200 (CEST)
Date: Mon, 18 May 2026 07:56:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Collin Funk <collin.funk1@gmail.com>
Cc: bug-gnulib@gnu.org, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: test-fdutimensat failures after 7.0.6-200.fc44.x86_64 kernel
 update
Message-ID: <20260518055617.GB10368@lst.de>
References: <8733zsj5qj.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8733zsj5qj.fsf@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 15, 2026 at 10:14:28PM -0700, Collin Funk wrote:
> Adding some print statements in place of the comment:
> 
>         fprintf (stderr, "%jd\n", (intmax_t) st3.st_atime);
>         fprintf (stderr, "%jd\n", (intmax_t) Y2K);
>         fprintf (stderr, "----------------\n");

Can you share a complete stand-alone C source file for this
reproducer?
