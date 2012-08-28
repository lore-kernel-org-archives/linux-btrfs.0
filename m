Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:42582 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2H1LyY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Aug 2012 07:54:24 -0400
Message-ID: <503CB15F.6060605@pocock.com.au>
Date: Tue, 28 Aug 2012 13:54:07 +0200
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Calvin Walton <calvin.walton@kepstin.ca>,
        "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: raw partition or LV for btrfs? (FAQ updated)
References: <5027DDFC.60504@pocock.com.au> <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com> <1344943428.20922.14.camel@ayu> <20120822154208.GV17430@twin.jikos.cz>
In-Reply-To: <20120822154208.GV17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22/08/12 17:42, David Sterba wrote:
> On Tue, Aug 14, 2012 at 07:23:48AM -0400, Calvin Walton wrote:
>> A patch to add support for `btrfs fi defrag -c none <file>` or so would
>> make this easier, and shouldn't be to hard to do :)
> 
> This one is on my list of 'nice to have', it's needed to extend the
> ioctl to understand 'none' as to actually use no compression during the
> defrag, while currently it means 'whatever compression the file has
> set'.
> 

Thanks for all the feedback about this, I've tried to gather the
responses into the FAQ:

https://btrfs.wiki.kernel.org/index.php/FAQ#Interaction_with_partitions.2C_device_managers_and_logical_volumes
