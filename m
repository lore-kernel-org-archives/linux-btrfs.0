Received: from mxex2.tik.uni-stuttgart.de (mxex2.tik.uni-stuttgart.de [129.69.192.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A736AB5B
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2026 09:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777108359; cv=none; b=O5/hdCGRQw79EwkBd8NPn9baV36HE4oIHkKYXPB0qo387mLbu9eZcV5c6RPxBs1PKlmtILio1P+YNszI7pjRBWdVbthGPAgHeHyRy22TU+hZY0HHTb7L8H/QK3n4SRPNRVoYkp63fA63XUkLwtQvJf0HRd+FapacRKhOEDtTvbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777108359; c=relaxed/simple;
	bh=vb/ngUiI1LjvH7jH/qJNN1jAaXgCNrEq+wdp6hQ3sDk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhAGqUzS+gM2++OSC0cvQ8gXUh127VhteCfTh8AJETWSKfPENx88CaZqLoc0YIu76WkZLWTpz968OJrWHJj6Vcwk6MIbwD6g+XfRHDw9QC26hXLsuwc2m9eTxG8symkiwW8cPoAGvL6J864ofiNm7pc8gJYp8U5Oyu8yWI9QrHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=a9GT4zBQ; arc=none smtp.client-ip=129.69.192.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="a9GT4zBQ"
Received: from localhost (localhost [127.0.0.1])
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 1572960C08
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2026 11:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:in-reply-to:content-disposition:content-type
	:content-type:mime-version:references:message-id:subject:subject
	:from:from:date:date; s=dkim; i=@rus.uni-stuttgart.de; t=
	1777107992; x=1778846793; bh=vb/ngUiI1LjvH7jH/qJNN1jAaXgCNrEq+wd
	p6hQ3sDk=; b=a9GT4zBQIj8DYFc6Nj8dV9RLT8wy9wa2qfne4J0bbUa84QyvLQn
	AhZQteXWSWTXb0hIuE3SJ94si9x+Y6sYfIX89lRrFKt6OXfbq2aDpCiDbc6yfdPr
	5jdHHhahReMqey3UHMrd7jUUhtzc7UzsiRMAwHBueZ00OX049R7IhxDQzBbo82TV
	8ktnLkHZEzQNBbalAlGi6+5JjjXG9XKQB8VWylj5RWrawCiQvPx/JdHSKYOhkiku
	yuhe49E7tEALcXtUuVRLpPb7DkKus8CPZmLj12gLyE59udqf/4ZTC2QI22eXg4RC
	PNkPIPtsmuzo2hW/UagBrPAblv6BWs/TyJw==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id EBv290mtr3oZ for <linux-btrfs@vger.kernel.org>;
 Sat, 25 Apr 2026 11:06:32 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Sat, 25 Apr 2026 11:06:31 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: snaprotate
Message-ID: <20260425090631.GA538432@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20171202125356.GA1355@rus.uni-stuttgart.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171202125356.GA1355@rus.uni-stuttgart.de>
User-Agent: Mutt/1.5.23 (2014-03-12)


For what and when do you need a backup?
In most cases it is an inadvertently deleted or overwritten file.
Catastrophic failures like a filesystem crash or a burned computer are 
more seldom.
For the first case one wants a QUICK and EASY way to restore the lost
file(s). btrfs snapshots comes to mind :-)

On Sat 2017-12-02 (13:53), Ulli Horlacher wrote:
> Being a Netapp user for a long time, I have always missed btrfs snapshots
> the way Netapp creates them.
> 
> I have now written snaprotate:
> 
> http://fex.belwue.de/snaprotate.html
> 
> snaprotate creates and manages btrfs readonly snapshots similar to Netapp.
> Snapshots have names like hourly, daily, weekly, single and a date_time
> prefix.
> 
> Snapshots are stored in a .snapshot/ directory in the subvolume root. 
> Example: /local/home/.snapshot/2017-09-09_1200.hourly

Some time later...

I have extended snaprotate with the shell function ssd (snapshot directories).

With ssd one can interactivly select a snapshot directory for recovery.
Example: 

  framstag@fex:~/data: ssd
  Snapshots:
   #1) 2026-04-18_1100
   #2) 2026-04-18_1000
   #3) 2026-04-18_0900
   #4) 2026-04-18_0800
   #5) 2026-04-18_0700
   #6) 2026-04-18_0600
   #7) 2026-04-18_0500
   #8) 2026-04-18_0400
   #9) 2026-04-18_0300
  #10) 2026-04-18_0200
  #11) 2026-04-18_0100
  #12) 2026-04-18_0000
  #13) 2026-04-17_2300
  #14) 2026-04-17_0000
  #15) 2026-04-16_0000
  #16) 2026-04-13_0000
  Snapshot #3
  SS0=/home/framstag/data
  framstag@fex:/local/home/.snapshot/2026-04-18_0900.hourly/framstag/data:

The only thing I have had to enter was "3"
Then I am in the snapshot directory from 2026-04-18 09:00
The restore then can be done with any command, example:

  framstag@fex:/local/home/.snapshot/2026-04-18_0900.hourly/framstag/data: cp -av *.txt $SS0/
  framstag@fex:/local/home/.snapshot/2026-04-18_0900.hourly/framstag/data: cd -
  framstag@fex:~/data:


https://fex.belwue.de/linuxtools/snaprotate.html


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<20171202125356.GA1355@rus.uni-stuttgart.de>
