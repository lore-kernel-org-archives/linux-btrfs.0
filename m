Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B79C288AD;
	Wed, 22 Jul 2026 13:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726351; cv=none; b=kQ/czqUfEI9pu/8cukSI6BN/0PuSrzG4cg2EawwzfIsxePGh2n81jwCgw0j84PQtD5CjnLjQV4/AU2qnLy2UX2WgA2q6xlyPvbkHkRbF7E/QIRAQ7MWlWYuEfPuyJlzvRkwPeEnCYveWQZ4jdXI0RkXffGVV950EKLh1sbBMe0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726351; c=relaxed/simple;
	bh=2jhms3a97sjBCG3gNAMoONl1Ow2P28h2CfyK1fXroMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eI7DERnhJ7KABjAqkz3cUHi+O/Z2DUq2V6+cQ2+d/fBqJKBjGrHrCllfxcoCEQckPhiop5JV1CS/D/1lq7Wx1ZrYonbjZDSJmIt/P8Bal6m4V4ZLy8JOAiUUD2ELPE8FW3b/9Modog4r1cCQAN9YYQ6wwxRdS60GneiY6c5nJlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FG8Vnnr5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FG8Vnnr5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p59Nbp/0h4piYzBzwlGNI1UeD/BfGw1h5BEhep/TnC0=; b=FG8Vnnr5vsMTMQEAvY86l+uFLk
	MFr03IMgedD7PxKczlkMDex/jp2DPkTKFje3UCyjtQZZAkg+SjdPknKc3cowMxn2i6EKmGRSHhKkF
	cJA622u2TDgVKKTu44nTU7Rlb3gfh3GJXCSY6H3Og4K1kpvqIEGvOt+DMqOEiE2rFpXNefa+/Roj8
	43NDfueASEFzxNzaIeGozY4SiAGGrLXtaxHrqBvXh4GMU4yrHaNYH/N6hl03LbudAPHPTQWK0c2Xo
	9JK+ej6shPeaCnznYybCTdecAoTPclBpMXdu3dmrgEqvSxsEAIOsa6LDT+fnLE5vOS4WzoaXz2e67
	4R4wRhaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWVb-0000000Fdb3-3ARC;
	Wed, 22 Jul 2026 12:57:11 +0000
Date: Wed, 22 Jul 2026 13:57:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
Message-ID: <amC-J7yzwk4Z5tHW@casper.infradead.org>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>

On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
>  *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
>  *      Whenever a full clean cycle (clear_page_dirty_for_io(),
>  *      writeback, bits cleared) completes inside thread A's
>  *      submission->completion window, the completion-time
>  *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
>  *      sets only the folio flag and the xarray tag - no btrfs subpage
>  *      dirty bit, no delalloc reservation.  See the 20-year-old comment
>  *      above bio_set_pages_dirty() in block/bio.c describing exactly
>  *      this ("other code (eg, flusher threads) could clean the pages").

There's your problem.  filemap_dirty_folio() documents that btrfs is
doing it wrongly:

 * Filesystems which do not use buffer heads should call this function
 * from their dirty_folio address space operation.  It ignores the
 * contents of folio_get_private(), so if the filesystem marks individual
 * blocks as dirty, the filesystem should handle that itself.

fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,

so btrfs should have its own btrfs_dirty_folio() which does whatever
metadata updates it needs to and then call filemap_dirty_folio() to
take care of the page cache business.  See iomap_dirty_folio() as
an example, but many other filesystems also do this.

