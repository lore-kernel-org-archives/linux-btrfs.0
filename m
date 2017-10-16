Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753097AbdJPO0M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:26:12 -0400
Subject: Re: [PATCH] btrfs: use need_full_stripe() in __btrfs_map_block()
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20171012084300.4740-1-anand.jain@oracle.com>
 <ec5ffd06-6881-d121-3046-9a2e1f79993c@suse.com>
 <20171016141748.GO3521@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc003207-d285-f501-1cc6-37d7b46e56c2@suse.com>
Date: Mon, 16 Oct 2017 17:26:09 +0300
MIME-Version: 1.0
In-Reply-To: <20171016141748.GO3521@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.10.2017 17:17, David Sterba wrote:
> You confused me first by the bitwise operators here, while the patch is
> actually for the logical ones (and correct).

actualy I used ~ as the "not" and ^ as "and" rather than XOR.

Not A AND Not B == NOT(A or B) that's what I wanted to express ...
