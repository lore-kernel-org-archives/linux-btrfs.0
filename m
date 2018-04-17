Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.exactcode.de ([144.76.154.42]:57718 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbeDQKS4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 06:18:56 -0400
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.com>)
        id 1f8Nhy-0000FE-UT
        for linux-btrfs@vger.kernel.org; Tue, 17 Apr 2018 10:19:31 +0000
Received: from [192.168.2.174] (helo=[192.168.2.174])
        by exactco.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.54)
        id 1f8MgV-0001QR-OR
        for linux-btrfs@vger.kernel.org; Tue, 17 Apr 2018 09:14:04 +0000
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Kernel unaligned access at ... btrfs_real_readdir+0x51c/0x718 [btrfs]
From: =?iso-8859-1?Q?Ren=E9_Rebe?= <rene@exactcode.com>
In-Reply-To: <20180416191533.GZ21272@twin.jikos.cz>
Date: Tue, 17 Apr 2018 12:18:45 +0200
Cc: linux-btrfs@vger.kernel.org
Message-Id: <40C44E95-3281-4E2C-83F6-CF6139FC4D19@exactcode.com>
References: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com> <20180416164805.GQ21272@twin.jikos.cz> <83e9ab82-1ee8-11ac-6987-127722aaba69@exactcode.com> <20180416191533.GZ21272@twin.jikos.cz>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 16 Apr 2018, at 21:15, David Sterba <dsterba@suse.cz> wrote:

> On Mon, Apr 16, 2018 at 09:55:45PM +0200, René Rebe wrote:
>> Hi,
>> 
>> On 04/16/2018 06:48 PM, David Sterba wrote:
>>> The warnings are valid, there's unaligned access introduced by patch
>>> 
>>> 23b5ec74943f44378b68c0edd8e210a86318ea5e
>>> btrfs: fix readdir deadlock with pagefault
>>> 
>>> The directory entries (struct dir_entry) are copied to a temporary
>>> buffer as they fit, ie. no alignment, and the members accessed in
>>> several places.
>>> 
>>> The following patch adds the proper unaligned access, only compile-tested.
>>> Please test and let me know, thanks!
>> Would have loved to immediately give it a try, however, sorry,
>> I forgot to mention I'm on the latest stable release -4.16.2-
>> on a first glance this does not look like it does just apply.
>> 
>> I would re-base myself if I would not also have a glibc initialization 
>> bug to hunt and debug, too :-/
>> 
>> If you happen to also rebase it for current -stable, ... ;-)
> 
> Sure, attached a 4.16.2 version.
> <0001-test-readdir-unaligned-access.patch>

Cool, thanks, built and so far it works, the warnings are gone.

	https://www.youtube.com/watch?v=XYsKct4T2xk

Greetings form Berlin,
	René

-- 
 ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin
 http://exactcode.com | http://exactscan.com | http://ocrkit.com | http://t2-project.org | http://rene.rebe.de

