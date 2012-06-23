Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41479 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab2FWKsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 06:48:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SiNt3-0007h2-Kd
	for linux-btrfs@vger.kernel.org; Sat, 23 Jun 2012 12:48:17 +0200
Received: from nordcom-adsl-9-46.zfn.uni-bremen.de ([134.102.9.46])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 12:48:17 +0200
Received: from hurikhan77+btrfs by nordcom-adsl-9-46.zfn.uni-bremen.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 12:48:17 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Tool to calc. 4k / 16k utilization / overhead
Date: Sat, 23 Jun 2012 12:43:20 +0200
Message-ID: <87jgb9-ie3.ln1@hurikhan.ath.cx>
References: <CAELiMBOxo+R+A-wcHmxJsVpOaf+DRS4AG91ENnYTiNBQJKvXXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Why don't you just use "du -B 4096 -sh /path/to/fs" vs.
"du -B 16384 -sh ..."?

Subtracting both results is the overhead of the one vs. the other.

But to answer your request for the formula, its:

blocks = (long)((file_size + block_size - 1) / block_size)
occupied_size = blocks * block_size

But this does not tell you the real on-disk occupation because it takes the 
logical file size of the files into account. But files may be sparse or 
compressed which sheds a complete different light on the problem.

I'd go with "du" command because it takes this into account.

Regards,
Kai

Sandra Schlichting <littlesandra88@gmail.com> schrieb:

> Hi all,
> 
> When having a non-btrfs fs and want to migrate to btrfs, it is hard to
> know which sector size to choose in terms of disk utilization and
> speed.
> 
> So I would like to make a script that scans the non-btrfs fs's
> directory structure to find all file sizes and calculate how much
> space these would take on btrfs 4k and 16k sector size.
> 
> Can anyone help me with a formulae to calculate this for a file?
> 
> It doesn't have to be exact, just enough to make a decision between 4k and
> 16k.
> 
> Best regards,
> Sandra
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


