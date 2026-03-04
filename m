Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46397350299
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Mar 2026 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772639829; cv=none; b=ukhjz/BQZqONMqta8SJmUkAB1HfH2y+pp7rQbHD6MmWxodVJrvHPHow1RsBI63Scr4ocggCxKIFQPU/dYUxYpK2NTbHAp79yU67+aHjQLctjAynPxIjwVjTJwVzD7nV0F5uatfW0GwVPqPdChiJAUOiydr4i55X7/Epr9fJ8TDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772639829; c=relaxed/simple;
	bh=m345xO8A8G7qS6xVDPuUI+Kz5nc3PfV2aenh3nNEeEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWohCFVZRkakFeFeIEq1ur32tI2C0IZ8DrujpuE4kuz5M+TZhP2h3PJPHyTxIKtg4whn1NTGGohrTTM9oHkeQX4B1rQnO+ykL6c/e1WPu/wUlufgRWezifG2NoJx4/gnqm/mzOGvtXrPNgIIy3n2bWsV52qzBkr1FgbB7/WxGmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5iSljlp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQ5wBBXx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5iSljlp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQ5wBBXx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772639827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W+9Ho15xe4D+QBehYcRY7ffWTr98jf1EjFNPRH2Y0fc=;
	b=C5iSljlpL1Mu6N3bSx3ba8qG1RM+8NvDKqB2+fzOiMU9tT5EuueOyqJY8t7XtqaF0YgoWT
	qZTTbx/RO69X2gtjd0982KoZuT+ufeKSSljsWXyX8Ai6MnKsy0+Xh06BV+F8pHYGEr+o8Z
	+4DhvyAmxnp/wBaqeKpzXuBUiROJo/g=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-YroKQohiNA2m7H_J3r8gPg-1; Wed, 04 Mar 2026 10:57:06 -0500
X-MC-Unique: YroKQohiNA2m7H_J3r8gPg-1
X-Mimecast-MFC-AGG-ID: YroKQohiNA2m7H_J3r8gPg_1772639825
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae61939fa5so47801725ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Mar 2026 07:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772639825; x=1773244625; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+9Ho15xe4D+QBehYcRY7ffWTr98jf1EjFNPRH2Y0fc=;
        b=VQ5wBBXxS1GIXJvOQdD2GTJNrZXWHf+xxVFUUMIQNUfmPYKHHusI7Cjq4rIcA9GSOT
         Erh6+GreW1fYUh06GmLAwy8DERd7rNOQSOP1LgO7OLEFbfm45rmUgNK6xBXPaJrRbZbx
         K0sAaOHTKtTdFWXez0WlQzLHZk0cOh58gsoBdIdMvqSUghS7PL0Mb3rTepYfGFC6GQUt
         tw/H7WLCYZ5sVd1Nj591Uayi588Tik+xeY+KI7T1ZXP5hXDTIeKduBjyss4NsHNTNjfw
         5uLE9vBl4t1RngYb0pUy2le8u/d89hy6/23Mjj6bnyGKU98ppyFNOoLpSXrZP2m7hCHP
         KBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772639825; x=1773244625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+9Ho15xe4D+QBehYcRY7ffWTr98jf1EjFNPRH2Y0fc=;
        b=urBTbgFsgJQV6W7ZqSMullzCpTTSIChSy7GIBG4eugXBJTom2hjhSQNFlhkjI+mQFq
         rh97vc8Z3RmHnTLrEiSjohflfXjdFH8wZRocOHdqdC0k0uh0siGkayiZ7qum87sLEThk
         KT7qtfYMIMnKyCQUrVXmltAGCbstZ/TUtMmAqrLjmHMIND73GZ+JLN2JFMV9FAUrRJu/
         iYWMK/F8JYMphX6aSnus45zoy/9RTthMJuNlio4KfUYVRlor16R7AvMV0s7j0WVOz83g
         fHPU6LX6Blq3qk7/bNpacp0vRx3A4B75CEWap7Fcdvn9Mr4opxiSLrhuRwkH6u2IRiHv
         eLDg==
X-Forwarded-Encrypted: i=1; AJvYcCWypG/+OdHt7nOSnBOmBh6q/g4/RzbpFl10s6MDEmKTK+qR49AU5xHJNerybbxEUQvwvS1hoU3MS3Ws4A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHvvfQKRXcKovQ/Pt2uNqd0USXIQXUzzo6GuN6O7gdIe95oMEN
	ceALm2Q3Ntjk5YUD1vgQ9W0fA9S9IbNM1Tu2d0q7r5T98BMfiQz+rknHcYcrXzbUB/gQyJSY1kh
	SZHnTt7g/owEsgVYFnbiWoaRelVlJB47Ep3MWoSq1eicmhteO799kR6EOPyzENJ8H
X-Gm-Gg: ATEYQzw8bV00jNTJ8iqov5kUAGyhjo9PN5YNLAKPmpCcTfZUhIkekWzMC9vwUO3nvQJ
	L/7o42Gz4+rdltyVC7i1EX+qEj7N+ATOts7/NhvlzIHPYuGmEOIhtCQxmR6gaECayc9J0SjqwN/
	PWj5BjAwfqeuH1exLAn5+38h6xAQufmmrPvLmckrtN9Xk8diKgoiQXcBiGIcSU+XuWY13w4e7mG
	ZtJLCUg1Tz8z2V72QBthAzRwFcBTcXog0ugEYPOnn4PMIbeG37XUn5ZQ+V0zkaPSZ2NcexKNQyI
	oxqxgfoiwKfIRfp80WZE3moCkSIKhHv0n0t7ghkM7m6mG2lSY43G21A1lci9orOmlwtz3a/HCsa
	NpebBIPHGz44pHLcuiQDVkcHm8dfZYTDaNlsl6kCR0EBFRX7yp3b+Ge2Tql+4kA==
X-Received: by 2002:a17:903:15c3:b0:2ae:5a21:f7ee with SMTP id d9443c01a7336-2ae6a8bfe34mr26660885ad.0.1772639825020;
        Wed, 04 Mar 2026 07:57:05 -0800 (PST)
X-Received: by 2002:a17:903:15c3:b0:2ae:5a21:f7ee with SMTP id d9443c01a7336-2ae6a8bfe34mr26660755ad.0.1772639824597;
        Wed, 04 Mar 2026 07:57:04 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae5e169997sm55199505ad.11.2026.03.04.07.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 07:57:04 -0800 (PST)
Date: Wed, 4 Mar 2026 23:56:59 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: fdmanana@kernel.org, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] btrfs: test a directory fsync scenaro after replacing
 a subdir with a file
Message-ID: <20260304155659.cb373wswpogy4rsn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <8e3c1626b6e49678976db67a861cb5dcfdb532c0.1772558357.git.fdmanana@suse.com>
 <7997e07a4f530bc52edd1b93e662907c4cd07377.1772561118.git.fdmanana@suse.com>
 <aaguMUK6TgYfwtZk@infradead.org>
 <20260304151800.6qkmxjsufen7sbq4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aahO7rnnaYg2MQ1o@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aahO7rnnaYg2MQ1o@infradead.org>

On Wed, Mar 04, 2026 at 07:25:34AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 11:18:00PM +0800, Zorro Lang wrote:
> > On Wed, Mar 04, 2026 at 05:05:53AM -0800, Christoph Hellwig wrote:
> > > The subject is wrong, this is actually a generic test.
> > 
> > Yeah, thanks Christoph, I'll change it to "generic" when I merge it.
> 
> Assuming you also pick up Johanne's per fs fixed by cleanups, it
> would be good to switch the new test over to that scheme.

Sure, thanks for the reminder. I'm doing that. It has more conflicts with
latest for-next branch, I'm resolving those as well, and will push to
patches-in-queue branch shortly.

> 
> 

