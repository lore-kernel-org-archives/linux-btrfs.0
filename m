Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63971 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbbK0PMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 10:12:15 -0500
Subject: Re: PAX: size overflow detected in function try_merge_map
 fs/btrfs/extent_map.c:238
To: fdmanana@gmail.com,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
References: <565834B3.4020602@gmx.de>
 <CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
 <56583C7C.5080904@gmx.de> <565843B8.1050205@googlemail.com>
 <CAL3q7H6KJ=qbg5eZ8wbAqHyGfsjSNYCCoM-VN6SmfQ_zc=u6Zg@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Message-ID: <565872CB.6050403@gmx.de>
Date: Fri, 27 Nov 2015 16:12:11 +0100
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6KJ=qbg5eZ8wbAqHyGfsjSNYCCoM-VN6SmfQ_zc=u6Zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/27/2015 12:53 PM, Filipe Manana wrote:
> Indeed.
> Try the following instead:  http://paste.opensuse.org/view/raw/58412382

white-space damaged too, but the hint with --ingore- made it.

Will see, if it helps now. But FWIW the mentioned spew happened the first time here AFAICT.

-- 
Toralf, pgp: C4EACDDE 0076E94E
