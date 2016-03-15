Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39396 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806AbcCONqF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:46:05 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afpIQ-0002Lj-So
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 14:46:02 +0100
Date: Tue, 15 Mar 2016 14:46:02 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue
Message-ID: <20160315134602.GQ2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <56E6B312.30903@googlemail.com>
 <20160314201306.GH2334@torres.zugschlus.de>
 <56E7E96E.6080301@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56E7E96E.6080301@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 11:52:30AM +0100, Holger Hoffstätte wrote:
> On 03/14/16 21:13, Marc Haber wrote:
> > Do I need to wait for clear_cache to finish, like until I see disk
> > usage dropping?
> 
> The cache isn't that big, so you won't see a huge drop. Just use the
> disk normally for a few minutes, after some time the cache will be
> written out again.

Is it necessary to actually cause activity on the file system or is it
ok to just let it sit there for an hour or so?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
