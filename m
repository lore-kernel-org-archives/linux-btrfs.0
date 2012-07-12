Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46325 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2GLLi2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 07:38:28 -0400
Received: by pbbrp8 with SMTP id rp8so3609667pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jul 2012 04:38:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2f38b3e1900634e64a186873b3388b1bf85dabc0.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
	<2f38b3e1900634e64a186873b3388b1bf85dabc0.1342083345.git.list.btrfs@jan-o-sch.net>
Date: Thu, 12 Jul 2012 13:38:27 +0200
Message-ID: <CAB9VWqBAdL3-hZ=HGuZm=i6igUfKfwQ5_i1Ejq_SBzGdNQD_XA@mail.gmail.com>
Subject: Re: [PATCH v1 04/15] Btrfs: add helper for tree enumeration
From: Alexander Block <ablock84@googlemail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, sensille@gmx.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2012 at 11:43 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> From: Arne Jansen <sensille@gmx.net>
>
> Often no exact match is wanted but just the next lower or
> higher item. There's a lot of duplicated code throughout
> btrfs to deal with the corner cases. This patch adds a
> helper function that can facilitate searching.
>
> Signed-off-by: Arne Jansen <sensille@gmx.net>
Hmm, I'm very sorry but my btrfs send/receive patchset has created
some conflicts here. I had to fix the find_higher=0 case in this patch
as it was not decrementing the slot at the right time. I changed the
original patch from Arne and hoped that Jan and Arne would take that
fixed version. I should have waited for an ACK from both, but instead
forgot about communicating it properly and posted it. I'm not sure how
to proceed now...asking for advise.

The version of the patch that I posted:
http://article.gmane.org/gmane.comp.file-systems.btrfs/18451
