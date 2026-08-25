Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204353CE4B6
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640502; cv=none; b=OEy26CojSHbht8N9U907/qdCJsELZw+SYFEljdhoebf5Pg4atV8CEY0bRnwkjniaHg39kN/Kut42P+olVzwuAI0lyoqKsaGHgcEZoyKeM434LnZ3pDnOOcJcX9H3A7uNLM03ds9h+ZYMfpADJpSD2Y2VymsjPkC8jF+W1BUUhh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640502; c=relaxed/simple;
	bh=DtQbSHzS7JPmqJG7bTBF3FYae2QcvwPJDcRr181NI28=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=FQjUPpjtIc7q5pqUahwZ5ssBJ3aSSC4nTdmG+g+wvEhymX0EPIzOOygW1544IB50aq7zkO5MSDodBbg80U/iyMQnwLmpknpVp+PgXrrOQpgWyLoGcNkD5PGu2VD/c98kFFyrXg+dm6i1CdV1MNfYe+EFIMy9Iz0B/GnyqPCPPAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U7wKlNQr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7wKlNQr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787640500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0Xx0vQw/77MZPCbZ84SfEciUQ3saYs6QehQ1wJS0yo=;
	b=U7wKlNQrT8jnhQU3bMSYaeMu4363xTgBnqACv0aeG2Dk3tmoMtqsWVqMmiTaKJHGP7bjPi
	Ns3kvmxlPU3dCqsY2ZaP9pVys49T069OqVh+nINWd9lz4EoeAESOQinD+L5OTYYgyCjHeE
	u9AakTUh2JS+3i3Okoiw8KCl1i8B6lM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-n-XQKI-_OzStJgHibaIy3Q-1; Tue,
 25 Aug 2026 02:48:16 -0400
X-MC-Unique: n-XQKI-_OzStJgHibaIy3Q-1
X-Mimecast-MFC-AGG-ID: n-XQKI-_OzStJgHibaIy3Q_1787640494
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A69E1954128;
	Tue, 25 Aug 2026 06:48:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.15])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 27BEB3000239;
	Tue, 25 Aug 2026 06:48:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: dhowells@redhat.com, Pedro Falcato <pfalcato@suse.de>,
    Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
    John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
    Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
    "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
    linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <798621.1787640486.1@warthog.procyon.org.uk>
Date: Tue, 25 Aug 2026 07:48:06 +0100
Message-ID: <798622.1787640486@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Matthew Wilcox <willy@infradead.org> wrote:

> I'm probably missing some stuff here.  Let me know.

mmap()?  That usually tosses a spanner in somewhere.

David

