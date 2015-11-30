Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:37210 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbK3RKW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 12:10:22 -0500
Date: Mon, 30 Nov 2015 18:10:19 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "disk full" on a 5 GB btrfs filesystem, FAQ outdated?
Message-ID: <20151130171019.GM31524@torres.zugschlus.de>
References: <20151129130754.GI31524@torres.zugschlus.de>
 <20151129141806.GG24333@carfax.org.uk>
 <20151129180629.GJ31524@torres.zugschlus.de>
 <pan$98cfe$190ff92c$916c4a80$8c9e9ee4@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$98cfe$190ff92c$916c4a80$8c9e9ee4@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 05:44:23AM +0000, Duncan wrote:
> Yes, you can get dup metadata back, but because data and metadata
> are now combined in the same blockgroups (aka chunks), they must
> both be the same replication type.

Thanks for this explanation, it's perfectly clear to me now.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
