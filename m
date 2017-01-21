Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:38330 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdAUSgw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jan 2017 13:36:52 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
        (envelope-from <mh+linux-btrfs@zugschlus.de>)
        id 1cV0Wv-0000zz-Gm
        for linux-btrfs@vger.kernel.org; Sat, 21 Jan 2017 19:36:49 +0100
Date: Sat, 21 Jan 2017 19:36:49 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "not a btrfs filesystem"
Message-ID: <20170121183649.GV4155@torres.zugschlus.de>
References: <20170121141641.GS4155@torres.zugschlus.de>
 <3609c150-5871-9581-50b2-bf1af8882cb4@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <3609c150-5871-9581-50b2-bf1af8882cb4@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 21, 2017 at 03:52:19PM +0100, Hans van Kranenburg wrote:
> You have to point balance to the mount point of the banana, not to the
> block device. (balance does its work while the file system is mounted)

Idiot me. I always forget that.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
