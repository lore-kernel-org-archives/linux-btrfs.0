Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:33520 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaJ0SVW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 14:21:22 -0400
Date: Mon, 27 Oct 2014 11:21:13 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: David Sterba <dsterba@suse.cz>
cc: Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: suspicious number of devices: 72057594037927936
In-Reply-To: <20141027153532.GF22943@twin.jikos.cz>
Message-ID: <alpine.DEB.2.19.4.1410271117030.9302@trent.utfs.org>
References: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org> <CAL3q7H4MbLCVXxLzT5d4vim1pp8ffZRsLX2GwDqgXNK3p5+sLg@mail.gmail.com> <20141027153532.GF22943@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Oct 2014 at 16:35, David Sterba wrote:
> Yeah sorry, I sent the v2 too late, here's an incremental that applies
> on top of current 3.18-rc
> 
> https://patchwork.kernel.org/patch/5160651/

Yup, that fixes it. Thank you! If it's needed:

  Tested-by: Christian Kujau <lists@nerdbynature.de>

@Filipe: and thanks for warning me about 3.17 - I used 3.17.0 since it 
came out and compiled kernels on the btrfs partition and haven't had any 
issues. But it wasn't used very often, so whatever the serious issues 
were, I haven't experienced any.

Christian.
-- 
BOFH excuse #98:

The vendor put the bug there.
