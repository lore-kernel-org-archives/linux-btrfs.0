Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750863AbdFTGws (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 02:52:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 742AAAC03
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 06:52:47 +0000 (UTC)
Subject: Re: [PATCH] btrfs: cleanup duplicate return value in
 insert_inline_extent
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170615170951.27944-1-dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3cd0771c-d6e0-f1f3-d31b-74b1ff3ee795@suse.com>
Date: Tue, 20 Jun 2017 09:52:46 +0300
MIME-Version: 1.0
In-Reply-To: <20170615170951.27944-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.06.2017 20:09, David Sterba wrote:
> The pattern when err is used for function exit and ret is used for
> return values of callees is not used here.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
