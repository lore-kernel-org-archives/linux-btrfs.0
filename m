Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:45612 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932359AbcI1Nov (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 09:44:51 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com> <57EBBBE1.8000309@applied-asynchrony.com>
 <38866575-422f-0d2d-b76c-a1d4b1018cfd@profihost.ag>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57EBC950.6040205@applied-asynchrony.com>
Date: Wed, 28 Sep 2016 15:44:48 +0200
MIME-Version: 1.0
In-Reply-To: <38866575-422f-0d2d-b76c-a1d4b1018cfd@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/16 15:06, Stefan Priebe - Profihost AG wrote:
> 
> Yes this is 4.4.22 and no i don't have qgroups enabled so it can't help.
> 
> # btrfs qgroup show /path/
> ERROR: can't perform the search - No such file or directory
> ERROR: can't list qgroups: No such file or director
> 
> This is the same output on all backup machines.

OK, that is really good to know (your other mails arrived just after I
sent mine). The fact that you see this problem with all kernels - even with
4.8rc - *and* on all machines is good (in a way) because it means I haven't
messed up anything, and we're not chasing ghosts caused by broken backport
patches.

>> would be unfortunate, but you could try to disable compression for a
>> while and see what  happens, assuming the space requirements allow this
>> experiment.
> Good idea but it does not. I hope i can reproduce this with my already
> existing testscript which i've now bumped to use a 37TB partition and
> big files rather than a 15GB part and small files. If i can reproduce it
> i can also check whether disabling compression fixes this.

Great. Remember to undo the compression on existing files, or create
them from scratch.

> No that's not the case. No rsync nor inplace is involved. I'm dumping
> differences directly from ceph and put them on top of a base image but
> only for 7 days. So it's not endless fragmenting the file. After 7 days
> a clean whole image is dumped.

That sounds sane but it's also not at all how you described things to me
previosuly ;) But OK. How do you "dump differences directly from
Ceph"? I'd assume the VM images are RBDs, but it sounds you're somehow
using overlayfs.

> yes and no - this is not idea and even very slow if your customers need
> backups on a daily basis. So you must be able to mount a specific backup
> very fast. And stacking on demand is mostly too slow - but this is far
> away from the topic in this thread.

I understand the desire to mount & immediately access backups - it's what
I do here at home too (every machine can access its own last #n backups
via NFS) and it's very useful.

Anyway..something is off and you successfully cause it while other
people apparently do not. Do you still use those nonstandard mount
options with extremely long transaction flush times?

-h

