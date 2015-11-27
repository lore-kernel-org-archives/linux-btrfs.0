Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36752 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbK0JhP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 04:37:15 -0500
MIME-Version: 1.0
In-Reply-To: <1448611892-26144-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1448611892-26144-1-git-send-email-linux@rasmusvillemoes.dk>
Date: Fri, 27 Nov 2015 11:37:14 +0200
Message-ID: <CAHp75VcV_BTb45xRiZKEtNeNaP93zzNr=Zr+Q-PgkGM6pF1=og@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use kbasename in btrfsic_mount
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 10:11 AM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> This is more readable.

Actually, Rasmus, a bit of offtopic here, but I would like to have
your opinion for that clean up:
http://www.spinics.net/lists/kernel/msg1411600.html



-- 
With Best Regards,
Andy Shevchenko
