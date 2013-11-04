Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gremlin.yadt.co.uk ([149.255.108.98]:44602 "EHLO
	gremlin.yadt.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3KDM0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 07:26:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by gremlin.yadt.co.uk (Postfix) with ESMTP id 386F117229
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Nov 2013 12:26:42 +0000 (GMT)
Received: from gremlin.yadt.co.uk ([127.0.0.1])
	by localhost (gremlin.yadt.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kVMrNxAIBque for <linux-btrfs@vger.kernel.org>;
	Mon,  4 Nov 2013 12:26:40 +0000 (GMT)
Date: Mon, 4 Nov 2013 12:26:40 +0000
From: David Taylor <davidt-linux-btrfs@yadt.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS volume crashes after hard reset
Message-ID: <20131104122639.GA16997@yadt.co.uk>
References: <5276D352.2090406@eitelwein.net>
 <52774108.6030808@eitelwein.net>
 <20131104082953.GI14405@carfax.org.uk>
 <14222ffecf8.2766.1948c4e1ae62a18b47d7fde83a97f68b@eitelwein.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <14222ffecf8.2766.1948c4e1ae62a18b47d7fde83a97f68b@eitelwein.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 04 Nov 2013, Michael Eitelwein wrote:
> 
> Am 4. November 2013 09:29:53 schrieb Hugo Mills <hugo@carfax.org.uk>:
>>
>>   You should upgrade your kernel, too. 3.2 has a large number of
>>known bugs -- including the one you've just met here -- which have
>>been fixed in later versions. Some of those bugs are not as benign as
>>this one.
>>
>
> The crash actually happened on kernel 3.8 (Ubuntu 13.04) but I had to
> fall back to a Ubuntu 12.04 LTS with kernel 3.2 to get it fixed.
>
> Hope that Ubuntu back-ports btrfs bug-fixes into their LTS kernel - do they?

Running a LTS kernel and an experimental filesystem seem to be somewhat
incompatible desires.  It seems unlikely they would back-port such fixes.

If you want to run btrfs you are far better off compiling your own kernel
from up-to-date source.

-- 
David Taylor
