Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.198.36.40.188.clients.your-server.de ([188.40.36.198]:38924
	"EHLO mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbbKJMlX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 07:41:23 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.render-wahnsinn.de (Postfix) with ESMTP id 92F62220DAF
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 13:41:18 +0100 (CET)
Received: from mail.render-wahnsinn.de ([127.0.0.1])
	by localhost (render-wahnsinn.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id LjQdQHWV0dDi for <linux-btrfs@vger.kernel.org>;
	Tue, 10 Nov 2015 13:41:16 +0100 (CET)
Received: from [192.168.192.248] (ip-178-200-54-61.hsi07.unitymediagroup.de [178.200.54.61])
	by mail.render-wahnsinn.de (Postfix) with ESMTPSA id 3C7D92200D7
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 13:41:16 +0100 (CET)
Message-ID: <5641E5EC.6070808@render-wahnsinn.de>
Date: Tue, 10 Nov 2015 13:41:16 +0100
From: Robert Krig <robert.krig@render-wahnsinn.de>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-balance convert from raid1 to single on specific device?
References: <5641C566.7030309@render-wahnsinn.de>
In-Reply-To: <5641C566.7030309@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,
I've been browsing through the mailing list and I came across a patch
that might solve my issue a lot easier.

Specifically "[PATCH 02/15] btrfs: Do per-chunk check for mount time
check" by Qu Wenruo

I'm a bit at a loss as to how to apply that patch. Since I'm not even
sure for which kernel tree or git repo this patch refers to.

I've cloned the btrfs-next git repo from the btrfs wiki page. I've also
searched through the gitweb site for that repo, but I couldn't find that
patch included anywhere.
I'm guessing that it will probably take a while for patches to the
mailing list to be merged into one of the repos.

What would be the easiest way for me to compile that specific patch?
Which kernel version sources do I ideally need?
Is there a git repo that already has that patch included?

Thank you for your help.




On 10.11.2015 11:22, Robert Krig wrote:
> Hi,
>
> I'm running Kernel 4.3 and Btrfs-tools 4.3 on Debian Jessie. I compiled
> the tools and kernel myself.
>
> Recently I added a new disk to my btrfs volume and wanted to proceed to
> convert from single to raid1.
> Unfortunately the new disk seems to be faulty and started throwing a lot
> of errors.
>
> The balance convert operation didn't manage to finish, and now I'm
> trying to get my btrfs volume back to single mode so that I can mount it
> read/write.
>
> If I try to mount it degraded, then it complains that there are too few
> devices to mount writeable. So it will only allow me to mount read-only.
>
> So far, so bad.
>
> I have managed to boot and mount the volume once, with the faulty disk
> and cancel the balance operation.
> Now I would like to convert it all to single again, so that I can
> finally remove that faulty drive.
>
> However, if I simply say
> btrfs fi balance start -dconvert=single -mconvert=single /btrfs-volume
>
> Wouldn't that theoretically move some blocks to the faulty drive? Can I
> somehow specify to rebalance only the working drive?
>
> I was thinking by specifying the device id, which seems possible
> according to the manpage.
> I just wanted to check with you guys first, if that should work as
> expected, or will I run into further trouble?
>
> Also, I understand -dconvert is for data, and -mconvert is for metadata,
> but is -sconvert? Is that data and metadata combined, or are system
> chunks something else entirely?
>
> Thanks for your help.

