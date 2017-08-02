Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:47262 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbdHBJbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 05:31:43 -0400
Date: Wed, 2 Aug 2017 14:31:41 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Thomas Wurfbaum <thomas@wurfbaum.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Crashed filesystem, nothing helps
Message-ID: <20170802143141.71b47fe1@natsu>
In-Reply-To: <3415313.AO7fCVCIcW@nimrod.thomas.wurfbaum.net>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
        <20170802090709.GA7140@carfax.org.uk>
        <3415313.AO7fCVCIcW@nimrod.thomas.wurfbaum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 02 Aug 2017 11:17:04 +0200
Thomas Wurfbaum <thomas@wurfbaum.net> wrote:
 
> A restore does also not help:
> mainframe:~ # btrfs restore /dev/sdb1 /mnt
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> Ignoring transid failure
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> Ignoring transid failure
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> Ignoring transid failure

Did it just abruptly exit there? Or you terminated it?

IIRC these messages (about ignoring) are not a problem for restore, it should
be able to continue. Or if not, it would print a more definitive error
message, e.g. "Couldn't read tree root" or such.

-- 
With respect,
Roman
