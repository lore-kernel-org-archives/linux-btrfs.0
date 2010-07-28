From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Intermittent no space errors
Date: Wed, 28 Jul 2010 08:31:10 +0800
Message-ID: <AANLkTikP_q7zhA2J69Rai964StGtMqCrhf2hGKPA9+J7@mail.gmail.com>
References: <AANLkTik_Dbk7cyS6FR0G9r-MFYq1bCCmbJ-HyHKgpUBr@mail.gmail.com>
	<AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com>
	<AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 28, 2010 at 4:30 AM, Dave Cundiff <syshackmin@gmail.com> wrote:
> Hello,
>
> I installed the git repo kernel and added some debug to the ENOSPC
> returns. Unfortunately its still failing. If it helps any its bombing
> out in btrfs_check_data_free_space() in extent-tree.c. Returning on
> the ENOSPC at line 2959.
>
> Unfortunately that is the extent of my ability to debug a filesystem. :P
>

This is really helpful, thank you very much.

Yan, Zheng
