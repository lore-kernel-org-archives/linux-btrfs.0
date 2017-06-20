Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750951AbdFTGvs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 02:51:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0DECAC03
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 06:51:47 +0000 (UTC)
Subject: Re: [PATCH] btrfs: move fs_info::fs_frozen to the flags
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170615171003.28004-1-dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b2f9342d-b1e2-9386-95fb-35c116241a3f@suse.com>
Date: Tue, 20 Jun 2017 09:51:45 +0300
MIME-Version: 1.0
In-Reply-To: <20170615171003.28004-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.06.2017 20:10, David Sterba wrote:
> We can keep the state among the other fs_info flags, there's no reason
> why fs_frozen would need to be separate.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
