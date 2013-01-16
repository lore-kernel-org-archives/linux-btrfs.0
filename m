Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:57580 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab3APJV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 04:21:56 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r0G9LsHw013326
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2013 10:21:54 +0100
Message-ID: <50F6712F.3070408@itwm.fraunhofer.de>
Date: Wed, 16 Jan 2013 10:21:51 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Tom Kusmierz <tom.kusmierz@gmail.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E77B.2030901@gmail.com> <20130114145904.GA1387@shiny> <50F422BC.4000901@gmail.com> <20130114155718.GC1387@shiny> <50F43319.9040009@gmail.com> <20130114163433.GD1387@shiny> <50F5E6FA.60803@gmail.com>
In-Reply-To: <50F5E6FA.60803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/16/2013 12:32 AM, Tom Kusmierz wrote:

> p.s. bizzare that when I "fill" ext4 partition with test data everything
> check's up OK (crc over all files), but with Chris tool it gets
> corrupted - for both Adaptec crappy pcie controller and for mother board
> built in one. Also since courses of history proven that my testing
> facilities are crap - any suggestion's on how can I test ram, cpu &
> controller would be appreciated.

Similar issues had been the reason we wrote ql-fstest at q-leap. Maybe 
you could try that? You can easily see the pattern of the corruption 
with that. But maybe Chris' stress.sh also provides it.
Anyway, I yesterday added support to specify min and max file size, as 
it before only used 1MiB to 1GiB sizes... It's a bit cryptic with bits, 
though, I will improve that later.
https://bitbucket.org/aakef/ql-fstest/downloads


Cheers,
Bernd


PS: But see my other thread, using ql-fstest I yesterday entirely broke 
a btrfs test file system resulting in kernel panics.
