Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61051 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab2J3SOh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 14:14:37 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so320798bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 11:14:36 -0700 (PDT)
Message-ID: <50901937.80002@gmail.com>
Date: Tue, 30 Oct 2012 19:15:19 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>
CC: kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        cwillu <cwillu@cwillu.com>, Martin Steigerwald <Martin@lichtvoll.de>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC][V2] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <508F015F.5090507@gmail.com> <20121030094253.GA20662@yeono.kjorling.se>
In-Reply-To: <20121030094253.GA20662@yeono.kjorling.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-30 10:42, Michael Kjörling wrote:
> On 29 Oct 2012 23:21 +0100, from kreijack@gmail.com (Goffredo Baroncelli):
>> Hi all,

[...]
> One thing, though; what is the difference between "unused" and
> "unallocated"? If there is no difference, I feel the same word should
> be used throughout.

I had to use "Unused" instead of "Unallocated" because the first one is
shorter. In the tabular output of the command "btrfs fi disk-usage" I
have 10 columns available for every fields. 1 columns is used by the
space character, so I have only 9 characters available for the
description. "Unused" is 6 chars, "Unallocated" is 11 chars....
The only options is to use "Unalloc." (8 chars)...




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
