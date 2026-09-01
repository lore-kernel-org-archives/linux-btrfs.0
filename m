Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2EF4CCDCA;
	Tue,  1 Sep 2026 09:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788254315; cv=none; b=D9qwQP1UYARmEK7PN0+l28j0+uAJshv1yAT1uAH7KBgoMxNNggRSUKd/OajX8Xu1GgOPqWafpbiYf26tvNG+LRMlTF0pBZ7VRHc/jbhie3JdWG5B61FOTz8ar5Y+IFpF1wVwVFubizbajQA1tvlbZTRrNFsk4tQaTB34k2ERTMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788254315; c=relaxed/simple;
	bh=Pataque8YQpiB/+2cX+QZyY/JqOzW0iprmedHVeFsKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwajrV0N6deLeh1/xL85fkzAiNkAFbKcFAmTdK5gmSKyVAWmqWwdbPqojm6aJEHLybbpFZBsMcNoGnZ9o75oTgO3rcZ1+rYlpJapl5Gdp+Q2xBPCrKTUghu/jqsT56Pzg34fTBw0rskhp07R9CX66VApYn1En/8/6uDMPJUK4VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kfsXWdMK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kfsXWdMK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6CxCAH8sEzSUs/hYjro/RkojoH/AgXv1l0pZ6N9+14M=; b=kfsXWdMK+/Xf9A+oH9o+ozW6a2
	RX71TxfcGtucXRZtAztu8sxVXCpxasb1oxjOGh2RH32N01qzdtFVHuUgDi2MNoKVNkqK4PjWeajji
	akUI5WEujPU4PdKQ+vGpV+KCi3SXPYhQ1VmRnI0e8Vn/j5TgzJP0lPFwvxeKZJqwmIufCd7zWfRLP
	dYOb1UM3a6DETFk5QlASMIwdIju3obCj2OhY0ovMRrUjXIW6mB2peDDdzv06aN1AtHsUY43nvVCr4
	TpuzlDVuYZjVvwf+HhP7NI42j5on2Yq68sX+yNp0zFXWtNJqkDa35fvFAC/WV4vy5vbPOm2fWv5AH
	eU8E4Jdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1KdU-0000000BOx7-0OBC;
	Tue, 01 Sep 2026 09:18:32 +0000
Date: Tue, 1 Sep 2026 02:18:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <willy@infradead.org>, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Add test of seek in directories
Message-ID: <apaYaEx6hlyRbe4c@infradead.org>
References: <20260827234743.2389778-1-neilb@ownmail.net>
 <20260827234743.2389778-2-neilb@ownmail.net>
 <apEK5uirjyLZUfmA@casper.infradead.org>
 <178791556100.3510150.18132687067056760170@noble.neil.brown.name>
 <apV-omM4s58KtkRz@infradead.org>
 <178822473504.3510150.6373190942920919075@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178822473504.3510150.6373190942920919075@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 01, 2026 at 11:05:35AM +1000, NeilBrown wrote:
> > > I think a strong argument for Linux needing something is that NFS needs
> > > working directory offsets to be able to support READDIR, because there
> > > is no "OPEN" request for directories.
> > 
> > I don't think anyone disputes the need for stable directory offsets,
> > and we should (*knock on wood*) have implementation of native
> > file systems that fail this.
> 
> "should not" ??

Yes.

> > What the test tries to force is a specific behavior for rename onto
> > existing file names, replacing the original file name entry with
> > a new one of the same name.  The test expects that to reuse the
> > previous d_off, which is not required by any real or de facto standard.
> 
> That's debatable.  The documents that I have found don't mention rename.
> Does that mean anything goes, or do that mean it doesn't get an
> exemption from the general rule that all names must be listed?

The Posix definition of rename is very explicit that the old directory
entry shall be removed:

    Otherwise, if the directory entry named by new exists, it shall be
    removed and old renamed to new. In this case, a directory entry named
    new shall remain visible to other threads throughout the renaming
    operation and refer either to the file referred to by new or old
    before the operation began.

So the previous directory entry for "new" shall be removed.  If a
file system reuses the same d_off for the renamed file, it just created
a new entry that happens to instantly reuse the d_off in the same atomic
operation.

> I think a fix to make it work over NFS would be to report the entries in
> reverse order - most recently added to least recently added.  This would
> effectively encode the timestamp (last_index) in the seek cookie instead
> of in btrfs_file_private.
> Changing how the seek-cookie is interpreted could cause a hiccup
> for an NFS client which was in the middle of a READDIR when a server
> we reboot to a new verion of btrfs, but that is likely not significant.
> 
> Note that
>   https://pubs.opengroup.org/onlinepubs/9799919799/functions/posix_getdents.html
> 
> uses the word "incremented" in 
> 
>   the directory entry immediately following the last entry whose
>   information was returned
> 
> but I don't think anyone seems interested in that detail.

I would suggest to ignore posix_getdents or the whole Issue 8 base spec,
as unlike previous versions I did not try to document and norm existing
behavior, but instead comes up with it's own things.  If we need a
justification we should look at historic Linux and Unix behaviors and
older Posix specs that haven't drifted away from the purpose as much
as the current one.

