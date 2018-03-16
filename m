Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44723 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964989AbeCPPk2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 11:40:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7F2A7AE8B
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 15:40:27 +0000 (UTC)
Date: Fri, 16 Mar 2018 16:38:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Make the code -Wunused clean
Message-ID: <20180316153804.GA16736@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 02:36:21PM +0200, Nikolay Borisov wrote:
> This series eliminates all -Wunused warnings in the code base. 

Thanks, 1-8 applied.
