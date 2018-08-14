Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:57756 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbeHNXAS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 19:00:18 -0400
Date: Wed, 15 Aug 2018 01:11:28 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: "Scott E. Blomquist" <sb@techsquare.com>, linux-btrfs@vger.kernel.org
Subject: Re: trouble mounting btrfs filesystem....
Message-ID: <20180815011128.344af7c4@natsu>
In-Reply-To: <20180814164111.76653189@job.localdomain>
References: <23408.34902.778845.675960@techsquare.com>
        <23410.52600.89620.15949@techsquare.com>
        <20180814160046.581c1de2@job.localdomain>
        <23410.55756.949586.17718@techsquare.com>
        <20180814164111.76653189@job.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Aug 2018 16:41:11 +0300
Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:

> If usebackuproot doesn't help then filesystem is beyond repair and you
> should try to refresh your backups with "btrfs restore" and restore from them[1].
> 
> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#How_do_I_recover_from_a_.22parent_transid_verify_failed.22_error.3F

This is really the worst unfixed Btrfs issue today. This happens a lot on
unclean shutdowns or reboots, and the only advice is usually to "start over"
-- even if your FS is 40 TB and the discrepancy is just by half a dozen
transids. There needs to be a way in fsck to accept (likely minor!) FS damage
and forcefully fixup transids to what they should be -- or even nuke the
affected portions entirely.

-- 
With respect,
Roman
