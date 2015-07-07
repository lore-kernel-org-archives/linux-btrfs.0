Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from server1.design-company.com.au ([103.18.108.111]:58494 "EHLO
	server1.design-company.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753615AbbGGHXK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jul 2015 03:23:10 -0400
Received: from ful1143003.lnk.telstra.net ([110.143.62.99]:63947 helo=hostd49a20ff8a0a.local)
	by server1.design-company.com.au with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.85)
	(envelope-from <hub@spotprint.com.au>)
	id 1ZCMMI-0008HO-3Y
	for linux-btrfs@vger.kernel.org; Tue, 07 Jul 2015 16:27:58 +1000
Message-ID: <559B7158.6050404@spotprint.com.au>
Date: Tue, 07 Jul 2015 16:27:36 +1000
From: Ryan Bourne <hub@spotprint.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: running duperemove but no free space gain
References: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com> <20150706223404.GF7507@wotan.suse.de> <CA+xOVSNrX4yT=+0Xre8qpRrsA=+Nu0w5+fUa0oAbvXf0CFr35w@mail.gmail.com> <20150706230725.GG7507@wotan.suse.de>
In-Reply-To: <20150706230725.GG7507@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/07/15 9:07 AM, Mark Fasheh wrote:
>
> Yes I forgot about that but in your case almost everything will be reported
> shared. Btw, I have to leave my office now but will get to the rest of your e-mail
> later.
>
> --
> Mark Fasheh
> --

To clarify, if I did the following:

# btrfs subvolume create a
# dd bs=1M count=10 if=/dev/urandom of=a/1
# dd if=a/1 of=a/2
# btrfs subvolume snapshot a b

then I have four files containing the same data. a/1, b/1 share extents 
and a/2, b/2 share extents.

If I then deduplicate a/1 and a/2 will all four files be sharing 
extents, or only three? (Assuming I have the patches for 4.2)

