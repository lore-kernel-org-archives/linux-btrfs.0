Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96664963D1;
	Thu, 23 Jul 2026 12:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810249; cv=none; b=sPgbNcOCEpfVWczuevyjSevSb+pHE7MoU9WCiNmE68yF8N1F2sqbGRkdSCFK1NaPKFhUgIMWJN5wuKQpnnMQYkUAjZspOlbYeta9AsG50Wz3mKX8J2852orpYxXey07dN88AjrpQeFpfWibc4qtrVyd3MEimMAD8SiT+8dHgFEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810249; c=relaxed/simple;
	bh=MVS59PV2eVqFszwaqz6dpPPmItvy1ar65XIEQe2xmII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KU51ftHGEVmtgjRhYli8YDKNfeKMrNQ7xBqxOaf1fjHRv0wS8WeBFKS1vIo5r/Ps42AuQAfrm8mkKUpEb4B0cnDLn1XCvJULiEltddMF+1mUp3KbIyItIzTG25L0ag6YA+MVzxg+nknLagSdIrAV63rQSEYflrKtb1yAymEFnB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y+CpZNsJ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y+CpZNsJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+3UKcAvC4cdqD6Ve05WpKpxH1iBS6zCA9CHEPJKcFSk=; b=Y+CpZNsJZHsnt/KMCgiVInCek2
	Yq65XH+peUgp84wQqDIlJZ4TPQHVpNtqvX1haRdokLkB+97OTQyYHKMb6wF7iRPt+uWqNtOCU8pbQ
	HieFMqFvlAzzO2kd1crbVJx4dyKjgX2P/8rOZNwauVjcgXF8M3XtSPbkqjWFmmqDLOJlNuQ7mDWO3
	7AU9O26L/SW273UiUeOvxjFhYeHpQMOjMQSQn8YDfWxEDsGNWcDOMYULJ5C2pbcOzgTLsoCTD5Dae
	3ihvRpYwTM/kWyt9kKQbyJ1qh4D+wx0706RQj2icepwmgh4U7L1FhQl0XDvOKgQRiebopFbcqCqrt
	kfk9uvBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmsfz-00000000WFK-1HwQ;
	Thu, 23 Jul 2026 12:37:23 +0000
Date: Thu, 23 Jul 2026 13:37:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-btrfs@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Help needed to address the dirty folio without fs notification
 delimma (Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty
 folios without fs knowing)
Message-ID: <amILA5-iY_er7ESL@casper.infradead.org>
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
 <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
 <4beadb76-8500-452c-b84e-206c50456b8a@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4beadb76-8500-452c-b84e-206c50456b8a@suse.com>

On Thu, Jul 23, 2026 at 07:15:40PM +0930, Qu Wenruo wrote:
> With that feature even if the folio is marked dirty without notifying the
> fs, we can detect and later re-dirty them and do the proper space
> reservation in a workqueue.

Oh good, you started another thread for the same problem.  I alreaday
told you what the problem is; you're not listening to the ->dirty_folio()
call; you're just passing it straight through to the VFS.
