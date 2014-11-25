Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3575 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751176AbaKYFfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 00:35:38 -0500
Message-ID: <1416893611.2576.7.camel@localhost.localdomain>
Subject: Re: File test operator for subvols; possible bug in 'btrfs show
 <directory>'
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: boris <6401e46d@opayq.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Tue, 25 Nov 2014 13:33:31 +0800
In-Reply-To: <loom.20141125T024507-20@post.gmane.org>
References: <loom.20141125T024507-20@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-11-25 at 02:11 +0000, boris wrote:
> Hi all,
> 
> I was looking for a quick method of testing whether a working directory is a 
> subvolume.
> 
> Couldn't see an obvious one, so tried 'btrfs show <somesubvol≥'. It printed 
> a fail message as expected but returned 0 exit status. Bug?

Hi boris,

I take a quick look at the code branch and I think it is a Bug indeed.
THe code just forgot to set the proper return value before leave out.

To test whether a dir is a subvolume, what about
	# btrfs sub list | grep <dirname>
as 'btrfs sub list will list all subvolumes under <mntpoint>.
The dirname should be relative path under <mntpoint> is as I could
remember.

Thanks,
Gui

> Can I put in a feature request for a shell file test operator for subvols, 
> please (or something of the kind)? http://tldp.org/LDP/abs/html/fto.html . 
> The letter v (for volume, both upper and lower case forms; one for subvol, 
> other for snapshots) is unused afaict. 
> 
> Have I missed the obvious? Or scored a false positive?
> 
> TIA.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


