Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263103EF64E
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054610; cv=none; b=BQhvNWgyIQcje5gSbLrB50qqDS9cDpU3P+KYo1w/7KsScGvO2zLs1klyVpG/IU0NkD0pi0vWC7MXArYvDhJ2D04bwC+/R5M1Rds/JAv5yOeX4KD7/vEPUjTzJHoAJifmuBdVFDOsAS0xgaYFt9c4Ab/n+Zqj7ZyhNPCefOUTSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054610; c=relaxed/simple;
	bh=2O6QP4Rn1YuHclxsNeTXqfcj2iReIdY8L0Xxo2tdNfc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFd1smXhmojD8On1y2yBMTutUI8YOiMu8HDP3VcoV0UI0OG5egXBfS8hEitgNHZR4kp7NxASuYjNey/K0n2ag/tITuuT+8bvKvcGJ+nWV8RUrFzzJ/prUgpC7xfhEnlkrAl3nx6dJdyc2zL1HKV607Qs54TOptgg3E1bzYX4YrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 4746840A84;
	Fri, 24 Apr 2026 18:16:45 +0000 (UTC)
Date: Fri, 24 Apr 2026 23:16:44 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
 linux-btrfs@vger.kernel.org
Subject: Re: How to corrupt a btrfs fs [was Re: Fixing a corrupted file
 system]
Message-ID: <20260424231644.2691eee8@nvm>
In-Reply-To: <87jytwtek6.fsf@digitalmercury.freeddns.org>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
	<fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
	<571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
	<87d1aca.ae41f579.19d4f977d95@tnonline.net>
	<20260424082300.GA361238@tik.uni-stuttgart.de>
	<20260424174904.385e875f@nvm>
	<87jytwtek6.fsf@digitalmercury.freeddns.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Apr 2026 14:10:17 -0400
Nicholas D Steeves <nsteeves@gmail.com> wrote:

> > See https://btrfs.readthedocs.io/en/latest/Balance.html
> >
> >   btrfs balance start -mprofiles=single -mconvert=dup /home
> 
> FYI, I just tried this with linux-6.12.57, btrfs-progs_6.17.1 and it
> corrupted my filesystem.  Luckily I only lose this morning's and
> afternoon's work...
> 
> I am happy to provide post-mortem debugging info.

This is the correct command and I've used it successfully in the past.

Perhaps there's a new bug in your kernel or progs version. In that case it
would be helpful for developers to see a dmesg of what happened, along with
all the other stuff, such as "filesystem check" (no --repair for now).

-- 
With respect,
Roman
