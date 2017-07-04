Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55121 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752279AbdGDQcT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Jul 2017 12:32:19 -0400
Date: Tue, 4 Jul 2017 18:31:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: check options during subsequent mount
Message-ID: <20170704163106.GE2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170428091409.19621-1-anand.jain@oracle.com>
 <980ec218-167c-3326-1964-2ff086d278c9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <980ec218-167c-3326-1964-2ff086d278c9@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 24, 2017 at 05:13:24PM +0800, Anand Jain wrote:
>   Can I ping you on this patch ? Wonder if there is any concern.

Well, there's my feeling that touching mount code always leads to some
surprise. The specific options apply to the whole filesystem, this is a
known limitation. Your patch seems to change the behaviour, when there
are extra mount options found, this could break existing setups. The
patch could be right after all, but I don't have time to look closely
riht now.
