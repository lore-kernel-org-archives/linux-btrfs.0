Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:57878 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932233Ab2FHTkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2012 15:40:31 -0400
Message-ID: <4FD2552D.20003@gmx.net>
Date: Fri, 08 Jun 2012 21:40:29 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Matthew Hawn <steamraven@yahoo.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Moving top level to a subvolume
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
In-Reply-To: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2012 09:24 PM, Matthew Hawn wrote:
> I just converted my root filesystem to btrfs with btrfs-convert.  However, since I am running Ubuntu, I would like to have the same subvolume structure as a default install,. How do I move the top-level subvolume (where all my files currently are) to another subvolume?
> 

Just snapshot the root subvol and continue working in the snapshot.


> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

