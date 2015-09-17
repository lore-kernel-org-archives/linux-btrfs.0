Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:63602 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbIQVdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 17:33:01 -0400
Subject: Re: BTRFS as image store for KVM?
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
 <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
From: Gert Menke <gert@menke.ac>
Cc: linux-btrfs@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Message-ID: <55FB3188.2060909@menke.ac>
Date: Thu, 17 Sep 2015 23:32:56 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17.09.2015 at 20:35, Chris Murphy wrote:
> You can use Btrfs in the guest to get at least notification of SDC.
Yes, but I'd rather not depend on all potential guest OSes having btrfs 
or something similar.

> Another way is to put a conventional fs image on e.g. GlusterFS with
> checksumming enabled (and at least distributed+replicated filtering).
This sounds interesting! I'll have a look at this.

> If you do this directly on Btrfs, maybe you can mitigate some of the
> fragmentation issues with bcache or dmcache;
Thanks, I did not know about these. bcache seems to be more or less what 
"zpool add foo cache /dev/ssd" does. Definitely worth a look.

 > and for persistent snapshotting, use qcow2 to do it instead of Btrfs. 
You'd use Btrfs
> snapshots to create a subvolume for doing backups of the images, and
> then get rid of the Btrfs snapshot.
Good idea.

Thanks!
