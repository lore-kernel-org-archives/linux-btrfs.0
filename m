Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:39643 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753668AbdKOHLJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 02:11:09 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: Tiered storage?
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-btrfs@vger.kernel.org
References: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net>
Date: Wed, 15 Nov 2017 08:11:04 +0100
MIME-Version: 1.0
In-Reply-To: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As a regular BTRFS user I can tell you that there is no such thing as 
hot data tracking yet. Some people seem to use bcache together with 
btrfs and come asking for help on the mailing list.

Raid5/6 have received a few fixes recently, and it *may* soon me worth 
trying out raid5/6 for data, but keeping metadata in raid1/10 (I would 
rather loose a file or two than the entire filesystem).
I had plans to run some tests on this a while ago, but forgot about it.
As call good citizens, remember to have good backups. Last time I tested 
for Raid5/6 I ran into issues easily. For what it's worth - raid1/10 
seems pretty rock solid as long as you have sufficient disks (hint: you 
need more than two for raid1 if you want to stay safe)

As for dedupe there is (to my knowledge) nothing fully automatic yet. 
You have to run a program to scan your filesystem but all the 
deduplication is done in the kernel.
duperemove works apparently quite well when I tested it, but there may 
be some performance implications.

Roy Sigurd Karlsbakk wrote:
> Hi all
>
> I've been following this project on and off for quite a few years, and I wonder if anyone has looked into tiered storage on it. With tiered storage, I mean hot data lying on fast storage and cold data on slow storage. I'm not talking about cashing (where you just keep a copy of the hot data on the fast storage).
>
> And btw, how far is raid[56] and block-level dedup from something useful in production?
>
> Vennlig hilsen
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> Hið góða skaltu í stein höggva, hið illa í snjó rita.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
