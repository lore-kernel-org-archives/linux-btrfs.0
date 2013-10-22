Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab3JVQAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 12:00:19 -0400
Date: Tue, 22 Oct 2013 18:00:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5
Message-ID: <20131022160017.GX1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com>
 <pan$59a02$8231ca78$f5d54bfb$30812437@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$59a02$8231ca78$f5d54bfb$30812437@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 01:27:44PM +0000, Duncan wrote:
> >     since RAID 5/6 code merged into Btrfs from  2013.2, no update and
> >     bug are found in maillist? is any development plan with btrfs raid5?
> >     such as adjusting stripe width、 reconstruction？
> >   compared to md raid5  what is advantage in btrfs raid5 ?

Thank you for explaining the differences in detail, I copied the last 3
paragraphs verbatim to wiki (modulo formatting).

https://btrfs.wiki.kernel.org/index.php/FAQ#Case_study:_btrfs-raid_5.2F6_versus_MD-RAID_5.2F6

david
