Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36879 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab2J2NPF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 09:15:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TSpBI-0000ol-PO
	for linux-btrfs@vger.kernel.org; Mon, 29 Oct 2012 14:15:04 +0100
Received: from 81-233-183-238-no86.business.telia.com ([81.233.183.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 14:15:04 +0100
Received: from quazzie by 81-233-183-238-no86.business.telia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 14:15:04 +0100
To: linux-btrfs@vger.kernel.org
From: Tommy Jonsson <quazzie@gmail.com>
Subject: Re: Old (almost 2 years) btrfs failed fs. Parent transid failure. Can it be fixed ?
Date: Mon, 29 Oct 2012 13:10:31 +0000 (UTC)
Message-ID: <loom.20121029T140737-910@post.gmane.org>
References: <CAM4M9rQZbsmiC_xmjAtt+syEmp5_ABMTmSVK0KAoVJwc2yqTwg@mail.gmail.com> <20121029123313.GA19012@mother.jarsat.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Torcz <tomek <at> pipebreaker.pl> writes:

>   I think you need to get branch "dangerdonoteveruse" to get real fsck code.
> 
> > sudo mount -t btrfs /dev/sda /mnt/disk/
> 
>  Could you try with "-o recovery"?
> 

As hugo said i think i got the correct source.

Anyway mount with recovery does not work.

sudo mount -t btrfs -o recovery /dev/sda /mnt/superdisk/
>mount: wrong fs type, bad option, bad superblock on /dev/sda,
>missing codepage or helper program, or other error
>In some cases useful info is found in syslog - try
>dmesg | tail  or so

dmesg
>[2582520.375909] device fsid 7278c712-5d48-4a73-b40d-6708a45a0b9b devid 3 
>transid 39651 /dev/sda
>[2582520.377733] btrfs: enabling auto recoveryparent transid verify failed 
>on 2721514774528 wanted 39651 found 39649
>[2582520.394180] btrfs: failed to read tree root on sda
>[2582520.395848] btrfs: open_ctree failed

Thanks for your intrest!

