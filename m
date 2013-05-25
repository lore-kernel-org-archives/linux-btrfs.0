Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:60893 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156Ab3EYKOK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 06:14:10 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Leonidas Spyropoulos <artafinde@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recommended settings for SSD
Date: Sat, 25 May 2013 20:14:05 +1000
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com> <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net> <CAAeznTr-sZhaMDMjQP-GFrkoH+JASDEP+ae1fyojxE4=Qoe1Jw@mail.gmail.com>
In-Reply-To: <CAAeznTr-sZhaMDMjQP-GFrkoH+JASDEP+ae1fyojxE4=Qoe1Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201305252014.05791.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 25 May 2013, Leonidas Spyropoulos <artafinde@gmail.com> wrote:
> I decided not to add the discard option and run the daily script from
> cron (fstrim) as I think there's a performance hit with the discard.
> It mainly depends on your hardware I think.

I experienced a massive performance hit from discard and turned it off at the 
recommendation of members of this list.  Since then there has not been a 
reason for me to enable it again.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
