From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: btrfs-cache processes
Date: Sun, 9 Aug 2009 12:00:15 +0800
Message-ID: <3d0408630908082100s395dd7d2s7174c63c16120c69@mail.gmail.com>
References: <20090809001723.223a0962.adrian@blinkenlights.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Adrian Ulrich <adrian@blinkenlights.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090809001723.223a0962.adrian@blinkenlights.ch>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/9 Adrian Ulrich <adrian@blinkenlights.ch>:
> Hi,
>
> I've upgraded my system to 2.6.31-rc5 some days ago. Yesterday i've discovered that
> this kernel produces some berserk btrfs-cache processes:
>
> There are about 4 of them and they use ~95% sys-cputime.
> About 20 seconds after they started 'freaking out' all writes to BTRFS will
> block and umounting also doesn't work anymore. Reading the volume
> still works (mostly) and there appers to be no disk activity (iostat/top
> reports nothing unusual).
>
> This isn't normal, isn't it? ;-)
>
> Everything appears to work fine on Linux 2.6.31-rc3
>

This has been fixed in the unstable tree. The fix will be in 2.6.31-rc6
soon.

Yan, Zheng
