Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35489 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbbEYFEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 01:04:38 -0400
Received: by obbgf1 with SMTP id gf1so6381591obb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 22:04:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO_qRRXnY+Qwfw83-d6HmrZ3b4cdgCVOX+Vg1EHSKBK=4g@mail.gmail.com>
References: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com>
 <036B4518-F7BF-4C9A-8906-38550D7F125F@plack.net> <CA+WRLO_5mG7t+2x-B+AV052i2=pkPmAr88txeQ4ZkxL7jvOAig@mail.gmail.com>
 <CA+WRLO_qRRXnY+Qwfw83-d6HmrZ3b4cdgCVOX+Vg1EHSKBK=4g@mail.gmail.com>
From: Peter Marheine <peter@taricorp.net>
Date: Sun, 24 May 2015 23:04:17 -0600
Message-ID: <CACvadSVdBSkCy=6Hm=yQ-XeWd=EmqYJjbfMJf-hfqnGRc8n0iA@mail.gmail.com>
Subject: Re: Did convert do anything?
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Anthony Plack <tmy@plack.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a known regression in 4.0. See [1], I don't think Chris's fix has
landed yet.

[1] https://patchwork.kernel.org/patch/6238111/

-- 
Peter Marheine
Don't Panic
