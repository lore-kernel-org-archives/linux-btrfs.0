Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39889 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751881AbeA3OSf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:18:35 -0500
Date: Tue, 30 Jan 2018 15:16:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] fix device orders consistency
Message-ID: <20180130141622.GI19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180122224937.3458-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180122224937.3458-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 22, 2018 at 02:49:35PM -0800, Anand Jain wrote:
>  Could you pls consider this for 4.16 ?

Sorry, the patches are not fixes and I'll probably not add them to 4.16
and they missed the first pull. But I will add them to misc-next so they
still help debugging and any fix that you come up with can be added to
4.16-rc independently.
