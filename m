Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC2E41B369;
	Tue, 20 Jan 2026 11:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768906995; cv=none; b=RmB5XdCptTSFCreyHL1eypWH1EPJIB45sGSXYRwKT7ZEOR0Th5ZZ7ho7XCCMsMIlslOdJqBT7QqUurlBrZBziAo1amaJ/8g4Ag2Ud2ZQ/3nBkHB3rTtEVQnLC1bog9/DHo/9I76OySnj6D8PUQzSnWQmj+N0D4HHe1sckWNCb8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768906995; c=relaxed/simple;
	bh=K+MGV+FvRxR4erO66nr74FB/a7WKOC75AyDIluVaPRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quesBaqOdrfVXoTgYr860Fw3xChfeVBalDNip/0lXjO0vVghERtAdGO0t+ZyvmR4TvRUOm0RXbLQZnvR90BJZIM1+drz/8WvE2A9DDVVrjwDybHonw9ET7XuOPO92VD5WVOSqHGsYmKEL6mQ3Gn1ai+8H86SbAsXwskaV5ju/v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRLuOEsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRLuOEsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332AAC4AF09;
	Tue, 20 Jan 2026 11:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768906994;
	bh=K+MGV+FvRxR4erO66nr74FB/a7WKOC75AyDIluVaPRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dRLuOEsNoezCIAOnFcA5yIVBit8pqhIdUZwiWLUxJu3842hyL2g3LGwa8oXZzL4x0
	 CveG1GLLzAzoAZIBxSaXo8arUMliBbhVQh5HTffne2Fu6x0NgKe+m6giQcyo1LL/aq
	 ZnnEMIf8T39bqDUAfOL/N3dKBRpoBZZ1uFKDxEyc=
Date: Tue, 20 Jan 2026 12:03:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Motiejus =?utf-8?Q?Jak=C5=A1tys?= <motiejus@jakstys.lt>
Cc: sashal@kernel.org, clm@fb.com, dsterba@suse.com, fdmanana@suse.com,
	linux-btrfs@vger.kernel.org, patches@lists.linux.dev,
	robbieko@synology.com, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] btrfs: fix deadlock in
 wait_current_trans() due to ignored transaction type
Message-ID: <2026012043-struck-cough-e28e@gregkh>
References: <20260112145840.724774-5-sashal@kernel.org>
 <20260119114626.1877729-1-motiejus@jakstys.lt>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119114626.1877729-1-motiejus@jakstys.lt>

On Mon, Jan 19, 2026 at 01:46:26PM +0200, Motiejus Jakštys wrote:
> Dear stable maintainers,
> 
> I was about to submit to stable@, but found this earlier email autosel.
> However, I don't see it in the queue. What's the right process to get it
> included to stable?

You can submit it now if you wish to see it merged at this point in
time.

thanks,

greg k-h
