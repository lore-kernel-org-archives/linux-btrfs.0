Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0471C5F13
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 16:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780331396; cv=none; b=WgZrxoTZbmsqaXVpO+qaLEZnqt5oj2CqU0dONBMMlHfftScV3gn/u3Pr7lcK4jQ61N/AUvTkX9b9uf71nJRDqmfI0B/m4Ytu4SEH8abyi5M5Qy/oQ3XvdHLUSto48GwM9Vm+HJ2vMBtVaj5jevujxVx6CsHNyLw7DHWi25ydZ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780331396; c=relaxed/simple;
	bh=gYfCSgj3xaS2A+YYEac1pAqnPzQSSEZ5MXWL4piM4aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDrx+uAmHDu3u57DCg8Dq55MR/WNjRX9RmvaxXoAkIGEC7saxnPODqY+ggnBX2bKj/ERAj0noZSCwjTgaqfq49jQtXEyiD2AQdzoP9+OCy4quektfADBo0r4eeObuAJI01DTdtCaHpQvqaJyi2hrP8JEs/fbbiKjf0OcVejF7aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USA7JRgg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USA7JRgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780331394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCDOSgEjx1fWi4LkC7ZBCwOBu8wF5UiqKv/5m50uf7w=;
	b=USA7JRggHIs/hxLW8vEsy4PyBd4Ef60oi5F0vo81A6PkvEspbQ1ynMO9av/9ncbJUbIDOX
	fUkxpIqJBJzB3dP8YyLhCBIYX43521tX33ei9MFbF9hKUIAAT3mDED7j/SAkSLw5oHRYjj
	shfHduCGvi/MR4DivcirWx/60UEcbZ4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-nWJ4074FMJq1TUF3XnERQQ-1; Mon,
 01 Jun 2026 12:29:48 -0400
X-MC-Unique: nWJ4074FMJq1TUF3XnERQQ-1
X-Mimecast-MFC-AGG-ID: nWJ4074FMJq1TUF3XnERQQ_1780331386
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6384A195609F;
	Mon,  1 Jun 2026 16:29:45 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.88])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AE5B1800347;
	Mon,  1 Jun 2026 16:29:42 +0000 (UTC)
Date: Mon, 1 Jun 2026 12:29:40 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Qu Wenruo <wqu@suse.com>, Damien Le Moal <dlemoal@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <ah2zdCQ0WA6ol2Gn@bfoster>
References: <ahRocb0Vs_m6RF_O@fedora>
 <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp>
 <ahZGxoI6oHQ_vSrx@fedora>
 <d1b5a737-f0e3-4927-b762-430b37fbb2f9@I-love.SAKURA.ne.jp>
 <ahZeYQ0cLE1i8TGs@fedora>
 <fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp>
 <ab5492b6-a053-4e3b-8c59-2e836ae85bc4@kernel.org>
 <20260528083848.GA7694@lst.de>
 <36571f8a-4df8-4152-b078-d82dbff4ad7e@suse.com>
 <20260601144034.GA4918@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601144034.GA4918@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Jun 01, 2026 at 04:40:34PM +0200, Christoph Hellwig wrote:
> On Thu, May 28, 2026 at 07:46:24PM +0930, Qu Wenruo wrote:
> >> e.g. 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers against
> >> unmount")
> > Considering the xfs fix is pretty old, it's before the fix hint thus no 
> > such mention in fstests.
> >
> > Do you happen to know which test case is for that fix?
> > I'd like to adapt it for btrfs as a reproducer.
> 
> No.  Adding Brian who authored that commit.
> 

I haven't followed through the full thread here... But if you're just
looking for an existing test case associated with the commit above on
XFS, I did some quick digging and xfs/311 is the original reproducer for
that one.

Brian

