Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:46604
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbbLWUiM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 15:38:12 -0500
Received: from tux.wizards.de (p4FF58543.dip0.t-ipconnect.de [79.245.133.67])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 762524160914
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:38:10 +0100 (CET)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id E093911C0037
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:38:09 +0100 (CET)
Subject: Re: btrfs und lvm-cache?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <n5du09$9rn$1@ger.gmane.org> <1527885.5NheBqth0k@merkaba>
 <n5e139$r1h$1@ger.gmane.org>
 <CADfjVrhQCxuggAzSKMcv8m6XJFvoCy4DVueSbrCX19KV-oHAPA@mail.gmail.com>
 <567AFF04.1030200@gmx.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <567B0631.2080801@googlemail.com>
Date: Wed, 23 Dec 2015 21:38:09 +0100
MIME-Version: 1.0
In-Reply-To: <567AFF04.1030200@gmx.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/23/15 21:07, Neuer User wrote:
> Understood. However, do SSDs really do automatic deduplication? I might
> be completely wrong here, but that sounds to be a rather complex
> mechanism, requiring lots of RAM to deduplicate 100 GB. I wouldn't have
> thought that typical SSDs include that?

tl;dr: no, because delta encoding/write buffer coalescing is not dedupe.

This is one of those persistent myth that has been kept alive by the
internet rumor machine. It has its roots in a series of blog articles [1]
and turned out to be panic coupled with FUD and fueled by a lack of factual
information.

I suggest everyone read the article(s), ALL the comments and then get back
to drinking. :o)

In SSD arrays dedupe is generally seen as a good thing.

-h

[1] http://storagemojo.com/2011/06/27/de-dup-too-much-of-good-thing/

