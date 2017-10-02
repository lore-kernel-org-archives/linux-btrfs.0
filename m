Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35001 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdJBKQv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 06:16:51 -0400
Subject: Re: Why do full balance and deduplication reduce available free
 space?
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        linux-btrfs@vger.kernel.org
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e5bd0dc3-f7a5-7461-0630-6f755425009f@mendix.com>
Date: Mon, 2 Oct 2017 12:16:47 +0200
MIME-Version: 1.0
In-Reply-To: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2017 12:02 PM, Niccolò Belli wrote:
> [...]
> 
> Since I use lots of snapshots [...] I had to
> create a systemd timer to perform a full balance and deduplication each
> night.

Can you explain what's your reasoning behind this 'because X it needs
Y'? I don't follow.

-- 
Hans van Kranenburg
