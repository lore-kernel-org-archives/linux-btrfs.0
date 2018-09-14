Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727730AbeINQje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 12:39:34 -0400
Date: Fri, 14 Sep 2018 13:25:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan K <shadow_7@gmx.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem show takes a long time
Message-ID: <20180914112530.GV2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3275334.7C4KuSQybz@t460-skr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3275334.7C4KuSQybz@t460-skr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for the report, I've forwarded it to the issue tracker
https://github.com/kdave/btrfs-progs/issues/148

The show command uses the information provided by blkid, that presumably
caches that. The default behaviour of 'fi show' is to skip mount checks,
so the delays are likely caused by blkid, but that's not the only
possible reason.

You may try to run the show command under strace to see where it blocks.
