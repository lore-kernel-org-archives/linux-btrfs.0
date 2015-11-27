Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33849 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbbK0IiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 03:38:10 -0500
Received: by lffu14 with SMTP id u14so121559323lff.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:38:08 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use kbasename in btrfsic_mount
References: <201511271640.QHZdu1xB%fengguang.wu@intel.com>
Date: Fri, 27 Nov 2015 09:38:07 +0100
In-Reply-To: <201511271640.QHZdu1xB%fengguang.wu@intel.com> (kbuild test
	robot's message of "Fri, 27 Nov 2015 16:32:49 +0800")
Message-ID: <87zixzbzww.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27 2015, kbuild test robot <lkp@intel.com> wrote:

> Hi Rasmus,
>
> [auto build test WARNING on: v4.4-rc2]
> [also build test WARNING on: next-20151127]
>
> url:    https://github.com/0day-ci/linux/commits/Rasmus-Villemoes/btrfs-use-kbasename-in-btrfsic_mount/20151127-161249
> config: i386-randconfig-s1-201547 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
>
> All warnings (new ones prefixed by >>):
>
>    fs/btrfs/check-integrity.c: In function 'btrfsic_mount':
>>> fs/btrfs/check-integrity.c:3140:5: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>       p = kbasename(ds->name);
>         ^
>

Baah. Ok, that's easy to fix. Sorry for not compile-testing this myself.

Rasmus
