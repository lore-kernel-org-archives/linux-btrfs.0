Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbeBVX7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 18:59:24 -0500
Date: Fri, 23 Feb 2018 00:57:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: [Bug 1547319] 4.16.0-0.rc1.git4.1.fc28.x86_64 #1 Not
 tainted: possible recursive locking detected
Message-ID: <20180222235704.GK1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bug-1547319-399363@bugzilla.redhat.com>
 <bug-1547319-399363-GV0megqgjZ@bugzilla.redhat.com>
 <CABB28CwoGbEGNiYdY_SmBJV+REWMWNxL7f8kjM5+S4t--w5-LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABB28CwoGbEGNiYdY_SmBJV+REWMWNxL7f8kjM5+S4t--w5-LQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 04:33:24AM +0000, Tomasz Kłoczko wrote:
> ---------- Forwarded message ----------
> From:  <bugzilla@redhat.com>
> Date: 21 February 2018 at 16:22
> Subject: [Bug 1547319] 4.16.0-0.rc1.git4.1.fc28.x86_64 #1 Not tainted:
>   possible recursive locking detected
> To: kloczko.tomasz@gmail.com
> 
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1547319
> 
> Laura Abbott <labbott@redhat.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |labbott@redhat.com
> 
> --- Comment #1 from Laura Abbott <labbott@redhat.com> ---
> This is btrfs which is pretty far down on our priority list. This is best
> reported to the upstream btrfs devs.

Quick and wrong conclusions, it's not a btrfs bug.

The fix:

https://patchwork.kernel.org/patch/10207013/

but I don't see it merged in master branch.
