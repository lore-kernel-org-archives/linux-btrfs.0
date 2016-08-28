Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:56290 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750857AbcH1Snc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 14:43:32 -0400
Subject: Re: btrfstune settings
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
References: <20160828193559.09534344@jupiter.sol.kaishome.de>
 <18fb1730-2820-81b1-781e-02ee9435d308@googlemail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <3e3acee3-7265-5c26-aca5-47a8e7b6d6e1@bouton.name>
Date: Sun, 28 Aug 2016 20:34:53 +0200
MIME-Version: 1.0
In-Reply-To: <18fb1730-2820-81b1-781e-02ee9435d308@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

happy borgbackup user here. This is probably off-topic for most but as
many users probably are evaluating send/receive versus other backup
solutions, I'll keep linux-btrfs in the loop.

On 28/08/2016 20:10, Oliver Freyermuth wrote:
>> Try borgbackup, I'm using it very successfully. It is very fast,
>> supports very impressive deduplication and compression, retention
>> policies, and remote backups - and it is available as a single binary
>> version so you can more easily use it for disaster recovery. One
>> downside: while it seems to restore nocow attributes, it seems to do it
>> in a silly way (it first creates the file, then sets the attributes,
>> which of course won't work for nocow). I have not checked that
>> extensively, only had to restore once yet.
> Wow - this looks like the holy grail I've been waiting for, not sure how
> I have missed that up to now. 
> Especially the deduplication across several backupped systems on the backup target
> is interesting, I originally planned to do that using duperemove on the backup target
> to dedupe across the readonly snapshots.

Note that only one backup can happen at a given time on a single repository.
You'll probably have to both schedule the backups to avoid collisions
and use "--lock-wait" with a large enough parameter to avoid backup
failures.

There's another twist : borgbackup maintains a local index of the
repositories' content, when it detects that it is out of sync (if
several systems use the same repository it will) it has to update its
index from remote.
I'm not sure how heavy this update can be (it seems it uses some form of
delta). I have a ~user/.cache/borg of ~2GB for a user with ~9TB of data
to backup in ~8M files but I don't share repositories so I'm not
affected by this).

Best regards,

Lionel
