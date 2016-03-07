Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:46256 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbcCGSuQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 13:50:16 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1ad0EQ-0000fy-Hi
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 19:50:14 +0100
Date: Mon, 7 Mar 2016 19:50:06 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-image run time
Message-ID: <20160307185006.GM6939@torres.zugschlus.de>
References: <20160307172717.GJ6939@torres.zugschlus.de>
 <20160307173811.GK6939@torres.zugschlus.de>
 <CAJCQCtRe4NXm5kC4svvO1det4NFN2fxUjDPSe7DFpOvXiL9X6w@mail.gmail.com>
 <CAHRk+qwqgqP3vyE1rSVLRDQrQXRy1sj_NktunR9pMQVSYYNkPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHRk+qwqgqP3vyE1rSVLRDQrQXRy1sj_NktunR9pMQVSYYNkPA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 07:15:24PM +0100, Garmine 42 wrote:
> According to the manpage duplicate -s is valid and the high CPU usage is
> intended. Although a warning could be valid in case of -ss.

Or use a different letter. Anyway, that was my stupidity and no
developer time should be wasted for that. btrfs-image behaves as
documented, everything else was a problem existing between chair and
keyboard. Sorry for the noise.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
