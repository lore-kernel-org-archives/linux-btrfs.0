Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42457 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621Ab2HVPmT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 11:42:19 -0400
Date: Wed, 22 Aug 2012 17:42:08 +0200
From: David Sterba <dave@jikos.cz>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: "Fajar A. Nugraha" <list@fajar.net>, Daniel Pocock <daniel@pocock.com.au>,
        linux-btrfs@vger.kernel.org
Subject: Re: raw partition or LV for btrfs?
Message-ID: <20120822154208.GV17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5027DDFC.60504@pocock.com.au>
 <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
 <1344943428.20922.14.camel@ayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1344943428.20922.14.camel@ayu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 07:23:48AM -0400, Calvin Walton wrote:
> A patch to add support for `btrfs fi defrag -c none <file>` or so would
> make this easier, and shouldn't be to hard to do :)

This one is on my list of 'nice to have', it's needed to extend the
ioctl to understand 'none' as to actually use no compression during the
defrag, while currently it means 'whatever compression the file has
set'.


david
