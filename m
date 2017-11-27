Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:45146 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbdK0KGy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 05:06:54 -0500
Date: Mon, 27 Nov 2017 13:06:30 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Daniel Pocock <daniel@pocock.pro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FAQ / encryption / error handling?
Message-ID: <20171127130608.20356674@job>
In-Reply-To: <fda951f3-0617-1ad9-8a23-0733628f0215@pocock.pro>
References: <fda951f3-0617-1ad9-8a23-0733628f0215@pocock.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Nov 2017 09:06:12 +0100
Daniel Pocock <daniel@pocock.pro> wrote:

> Hi all,
> 
> The FAQ has a couple of sections on encryption (general and dm-crypt)
> 
> One thing that isn't explained there: if you create multiple encrypted
> volumes (e.g. using dm-crypt) and use Btrfs to combine them into
> RAID1, how does error recovery work when a read operation returns
> corrupted data?
> 
> Without encryption, reading from one disk would give a checksum
> mismatch and Btrfs would read from the other disk to (hopefully) get
> a good copy of the data.
> 
> With this encryption scenario, the failure would potentially be
> detected in the decryption layer code and instead of returning bad
> data to Btrfs, it would return some error code. In that case, will
> Btrfs attempt to read from the other volume and allow the application
> to proceed as if nothing was wrong?
> 
> Regards,
> 
> Daniel

Default (aes-xts-plain64) dm-crypt setup can't verify integrity
of encrypted block and in case of silent corruption will decrypt it to
garbage which btrfs will catch. In case of AEAD encryption
(dm-crypt plus dm-integrity) it can verify integrity itself but I'm not
sure right now which exact error it returns to upper layer as I didn't
used it yet.

I use btrfs raid1 on top of LVM on top of dm-crypt devices and
it handled bad blocks on physical devices normally (there was a burst of
about 900 reallocates on one device which btrfs caught and fixed).
