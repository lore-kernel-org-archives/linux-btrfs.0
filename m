Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.com ([74.208.4.201]:54555 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbbEGRVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 13:21:52 -0400
Received: from crinkle.gilfillan.org ([68.15.115.197]) by mail.gmx.com
 (mrgmxus002) with ESMTPSA (Nemesis) id 0LuPIX-1ZH2gD22OV-011ihb for
 <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 19:21:50 +0200
Message-ID: <554B9F2B.1090202@linuxmail.org>
Date: Thu, 07 May 2015 12:21:47 -0500
From: Perry Gilfillan <perrye@linuxmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: hard lockup while balance was running killed my raid5
References: <5548F177.1040309@linuxmail.org> <pan.2015.05.05.17.03.19@googlemail.com> <55490697.8020702@linuxmail.org>
In-Reply-To: <55490697.8020702@linuxmail.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been trying to understand where some of these numbers come from.

On 05/05/2015 01:06 PM, Perry Gilfillan wrote:
> btrfs-image throws a different error,
> bytenr mismatch, want=27198603952128, have=13057557201204318535,
> where the 'have' seems to be pointing some where out past Pluto!
>
> [root@lightmyfire btrfs-progs-unstable]# ./btrfs-image /dev/sdf5 
> ~/text.txt
> parent transid verify failed on 27198602870784 wanted 291859 found 291431
> parent transid verify failed on 27198602870784 wanted 291859 found 291431
> checksum verify failed on 27198602870784 found C273E746 wanted 26905AF0
> parent transid verify failed on 27198602870784 wanted 291859 found 291431
> Ignoring transid failure
> parent transid verify failed on 27198603952128 wanted 291431 found 291859
> parent transid verify failed on 27198603952128 wanted 291431 found 291859
> checksum verify failed on 27198603952128 found BC5A7A89 wanted 90B199E8
> checksum verify failed on 27198603952128 found BC5A7A89 wanted 90B199E8
> bytenr mismatch, want=27198603952128, have=13057557201204318535
> Couldn't read chunk tree
> Open ctree failed
> create failed (Success)
>

The generation numbers are easy enough.  If incremented every 30 
seconds, they represent about 100 days of activity.

The other numbers (27198602870784) are leaf nodes in the tree?  When the 
'bytenr mismatch' error shows up, how would I find the cause and try to 
patch it manually?
