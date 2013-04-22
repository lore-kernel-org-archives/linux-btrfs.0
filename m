Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:45309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab3DVNpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:45:16 -0400
Message-ID: <51753EF6.6040905@sgi.com>
Date: Mon, 22 Apr 2013 08:45:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: [PATCH V3] xfstests: fix common filter include in filter.btrfs
References: <517386CC.8010406@redhat.com> <51746D07.5090300@sandeen.net> <51746D8A.60707@sandeen.net>
In-Reply-To: <51746D8A.60707@sandeen.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/21/2013 05:51 PM, Eric Sandeen wrote:
> Not sure how this happened, but filter.btrfs including
> itself leads to immense sadness for any file that includes it.
> (I got a segfault when I tried to run 307)
>
> It should be including ./common/filter not ./common/filter.btrfs
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> cripes, I'm sorry that took 3 times to get right :/
>

Third time is the charm ;) Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

