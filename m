Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:33580 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3EXIfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 04:35:41 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r4O8Zcss010413
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 10:35:39 +0200
Message-ID: <519F2659.3050006@itwm.fraunhofer.de>
Date: Fri, 24 May 2013 10:35:37 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid6: rmw writes all the time?
References: <knl3ke$n7t$1@ger.gmane.org> <20130523131118.4907.45217@localhost.localdomain> <519E1821.5070507@itwm.fraunhofer.de> <20130523133418.4907.21116@localhost.localdomain> <519E6F04.5000900@itwm.fraunhofer.de> <20130523193741.4907.41422@localhost.localdomain> <519E71E0.2060301@itwm.fraunhofer.de> <20130523203337.4907.25234@localhost.localdomain>
In-Reply-To: <20130523203337.4907.25234@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

On 05/23/2013 10:33 PM, Chris Mason wrote:
> But I was using 8 drives.  I'll try with 12.
>>
> My benchmarks were on flash, so the rmw I was seeing may not have had as
> big an impact.


I just further played with it and simply introduced a requeue in 
raid56_rmw_stripe() if the rbio is 'younger' than 50 jiffies. I can 
still see reads, but by a factor 10 lower than before. And this is 
sufficient to bring performance almost to that of direc-io.
This is certainly no upstream code, I hope I find some time over the 
weekend to come up with something better.

Btw, I also noticed the cache logic copies pages from those rmw-threads. 
Well, this a numa system and memory bandwith is terribly bad from the 
remote cpu. These worker threads probably should numa aware and only 
handle rbios from their own cpu.


Cheers,
Bernd
