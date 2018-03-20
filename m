Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:37267
        "EHLO know-smtprelay-omc-1.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbeCTUNb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 16:13:31 -0400
Subject: Re: Kernel warning - not sure if this is important
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <398a50db-8ae0-b933-7268-4231e08d615d@petezilla.co.uk>
 <bcd412c7-b7c1-a581-ea4b-e00bec6cd909@suse.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <05125de4-460c-4f90-35a2-c7f5ed3e61f3@petezilla.co.uk>
Date: Tue, 20 Mar 2018 20:13:28 +0000
MIME-Version: 1.0
In-Reply-To: <bcd412c7-b7c1-a581-ea4b-e00bec6cd909@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/19/2018 08:34 AM, Nikolay Borisov wrote:

> You are hitting a warning that was removed in : c8195a7b1ad5 ("btrfs:
> remove spurious WARN_ON(ref->count < 0) in find_parent_nodes")
> 
> 
> In short - you can disregard it. However, it's likely you will continue
> seeing it in the future unless you update to 4.16 (the commit is not
> tagged for stable ))
> 

Thank you, much appreciated.  I think I can manage to wait for 4.16!

Pete
