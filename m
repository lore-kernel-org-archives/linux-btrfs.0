Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:39380 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932625AbaLAXYi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 18:24:38 -0500
Message-ID: <547CF8B1.4000303@pobox.com>
Date: Mon, 01 Dec 2014 15:24:33 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>	<547CA4E7.8060209@pobox.com> <CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
In-Reply-To: <CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2014 02:10 PM, MegaBrutal wrote:
> Since having duplicate UUIDs on devices is not a problem for me since
> I can tell them apart by LVM names, the discussion is of little
> relevance to my use case. Of course it's interesting and I like to
> read it along, it is not about the actual problem at hand.
>

Which is why you use the device= mount option, which would take LVM 
names and which was repeatedly discussed as solving this very problem.

Once you decide to duplicate the UUIDs with LVM snapshots you take up 
the burden of disambiguating your storage.

Which is part of why re-reading was suggested as this was covered in 
some depth and _is_ _exactly_ about the problem at hand.
