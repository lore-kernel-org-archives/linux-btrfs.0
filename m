Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:40135 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965669AbeE2S4u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 14:56:50 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Steve Leung <sjleung@shaw.ca>,
        linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c0ff94a7-2465-ef57-9aab-09d8adf7c8f1@mendix.com>
Date: Tue, 29 May 2018 20:49:42 +0200
MIME-Version: 1.0
In-Reply-To: <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/21/2018 03:07 AM, Qu Wenruo wrote:
> 
> [...]
> 
> And the problem of wrong "root=" output also makes me pretty curious.
Yeah, there a bunch of error messages in the kernel with always say
root=1, regardless of the actual root the tree block is in.

I think I once tried to find out why, but apparently it wasn't a really
obvious error somewhere.

-- 
Hans van Kranenburg
