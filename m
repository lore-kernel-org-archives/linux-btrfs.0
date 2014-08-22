Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65176 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbaHVOHB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 10:07:01 -0400
Message-ID: <53F74E80.3010303@gmx.at>
Date: Fri, 22 Aug 2014 16:06:56 +0200
From: Klaus Holler <kho@gmx.at>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive problem on ARM kirkwood NAS with kernel 3.16.0
 and btrfs-progs 3.14.2
References: <53F0A3B2.80709@gmx.at> <20140819221055.GI429@lenny.home.zabbo.net> <20140819222241.GD31558@carfax.org.uk> <53F64274.6090008@gmx.at> <20140821212517.GE7116@lenny.home.zabbo.net>
In-Reply-To: <20140821212517.GE7116@lenny.home.zabbo.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Zach!

Am 2014-08-21 um 23:25 schrieb Zach Brown:
> On Thu, Aug 21, 2014 at 09:03:16PM +0200, Klaus Holler wrote:
>> Hello Hugo and Zach!
>>
>> a big thanks to both of you!
>>
>> Both Hugo's userspace workaround and
>> Zach's patch work fine for me - the /boot snapshot can be restored
>> completely as expected :-)
> 
> Cool, glad to hear it.  I sent a proper patch to the list and added your
> reported-by and tested-by, hope that's OK.

yes, sure that's ok.

BTW: The first of the bigger snapshots also did restore fine over night.
Second one still running ...

Kind regards,
Klaus

-- 
Klaus Holler <kho (at) gmx (punkt) at>
