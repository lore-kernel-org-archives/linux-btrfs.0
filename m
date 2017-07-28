Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:39884 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbdG1Rsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 13:48:38 -0400
Date: Fri, 28 Jul 2017 22:48:35 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs + compression = slow performance and high cpu usage
Message-ID: <20170728224835.41c98aea@natsu>
In-Reply-To: <8446582.541.1501260065690.JavaMail.gkos@dynomob>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Jul 2017 17:40:50 +0100 (BST)
"Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com> wrote:

> Hello list, 
> 
> I am stuck with a problem of btrfs slow performance when using compression.
> 
> when the compress-force=lzo mount flag is enabled, the performance drops to 30-40 mb/s and one of the btrfs processes utilises 100% cpu time.
> mount options: btrfs relatime,discard,autodefrag,compress=lzo,compress-force,space_cache=v2,commit=10

It does not work like that, you need to set compress-force=lzo (and remove
compress=).

With your setup I believe you currently use compress-force[=zlib](default),
overriding compress=lzo, since it's later in the options order.

Secondly,

> autodefrag

This sure sounded like a good thing to enable? on paper? right?...

The moment you see anything remotely weird about btrfs, this is the first
thing you have to disable and retest without. Oh wait, the first would be
qgroups, this one is second.

Finally, what is the reasoning behind "commit=10", and did you check with the
default value of 30?

-- 
With respect,
Roman
