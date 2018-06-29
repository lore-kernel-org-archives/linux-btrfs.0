Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:58160 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934555AbeF2IKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:10:32 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org> <20180629120954.4bbcd174@natsu>
 <20180629072210.nxvtwbokblol7xcb@merlins.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <f693b8c8-1b3c-4847-b5f5-3990e3b8389a@bouton.name>
Date: Fri, 29 Jun 2018 10:04:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180629072210.nxvtwbokblol7xcb@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 29/06/2018 09:22, Marc MERLIN wrote:
> On Fri, Jun 29, 2018 at 12:09:54PM +0500, Roman Mamedov wrote:
>> On Thu, 28 Jun 2018 23:59:03 -0700
>> Marc MERLIN <marc@merlins.org> wrote:
>>
>>> I don't waste a week recreating the many btrfs send/receive relationships.
>> Consider not using send/receive, and switching to regular rsync instead.
>> Send/receive is very limiting and cumbersome, including because of what you
>> described. And it doesn't gain you much over an incremental rsync. As for
> Err, sorry but I cannot agree with you here, at all :)
>
> btrfs send/receive is pretty much the only reason I use btrfs. 
> rsync takes hours on big filesystems scanning every single inode on both
> sides and then seeing what changed, and only then sends the differences
> It's super inefficient.
> btrfs send knows in seconds what needs to be sent, and works on it right
> away.

I've not yet tried send/receive but I feel the pain of rsyncing millions
of files (I had to use lsyncd to limit the problem to the time the
origin servers reboot which is a relatively rare event) so this thread
picked my attention. Looking at the whole thread I wonder if you could
get a more manageable solution by splitting the filesystem.

If instead of using a single BTRFS filesystem you used LVM volumes
(maybe with Thin provisioning and monitoring of the volume group free
space) for each of your servers to backup with one BTRFS filesystem per
volume you would have less snapshots per filesystem and isolate problems
in case of corruption. If you eventually decide to start from scratch
again this might help a lot in your case.

Lionel
