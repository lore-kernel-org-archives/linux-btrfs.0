Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38948 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbbDTLee (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 07:34:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yk9yC-0007oD-6V
	for linux-btrfs@vger.kernel.org; Mon, 20 Apr 2015 13:34:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 13:34:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 13:34:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs-progs: fix typo in btrfs-device.txt
Date: Mon, 20 Apr 2015 11:34:26 +0000 (UTC)
Message-ID: <pan$55b14$27e3e801$add05965$e8bc02fc@cox.net>
References: <1429525889-2843-1-git-send-email-anand.jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Mon, 20 Apr 2015 18:31:29 +0800 as excerpted:

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  Documentation/btrfs-device.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/btrfs-device.txt
> b/Documentation/btrfs-device.txt index 4bb5ea5..0bc1be3 100644 ---
> a/Documentation/btrfs-device.txt +++ b/Documentation/btrfs-device.txt @@
> -53,7 +53,7 @@ run `btrfs-balance`(8) to rebuild the chunks.
>  See `btrfs-balance`(8) for more details.
>  
>  Device add/remove/replace::
> -Device can be added/removed using `btrfs-replace`(8) subcommand and replaced
> +Device can be added/removed using `btrfs-delete`(8) subcommand and replaced
>  using `btrfs-replace`(8).
>  +
>  When device is removed or replaced, btrfs will do the chunk rebuild if needed.

That isn't correct either.  Device can be _added_ using btrfs-delete?  It's
btrfs device add, tho I'm not sure the appropriate notation for that here
in ordered to have the manpage work correctly.

Maybe:

 Device add/remove/replace::
-Device can be added/removed using `btrfs-replace`(8) subcommand and replaced
+Device can be added/removed using add/delete as below and replaced
 using `btrfs-replace`(8).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

