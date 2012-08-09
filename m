Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab2HID3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 23:29:43 -0400
Message-ID: <50232E79.1060408@cn.fujitsu.com>
Date: Thu, 09 Aug 2012 11:28:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Seto Hidetoshi <seto.hidetoshi@jp.fujitsu.com>,
        David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V3 2/2] Btrfs: fix the snapshot that should not exist
References: <501A04CE.9090408@cn.fujitsu.com> <20120802114631.GM17430@twin.jikos.cz> <501B2F20.7080903@cn.fujitsu.com> <20120803210301.GK2263@localhost.localdomain> <501CB8D8.2010405@cn.fujitsu.com> <20120808133841.GC5873@ds.suse.cz>
In-Reply-To: <20120808133841.GC5873@ds.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 8 Aug 2012 15:38:41 +0200, David Sterba wrote:
> On Sat, Aug 04, 2012 at 01:53:28PM +0800, Miao Xie wrote:
>> But I'm not sure these two bugs is the same, so I need the test tool
>> of David to look into it.
> 
> Attached. It's a set of scripts and has a few assumptions hardcoded,
> like where the tar srouce is and the name of extracted directory, so
> it'll need a few tweaks. Also the actions are started inside a tmux
> session for convenience.
> 
> The expected stress load is to generate lots of files and directories,
> snapshot create and delete and rm of the untarred directory. The 'rm'
> step is delayed a few minutes so the tar generates enough data. On some
> hosts the rm phase is fast and will clean the untar directory too
> quickly.

Thanks.

I find this bug you reported is not introduced by my patch, it is a old bug.
I have sent a RFC patch, I'll be very appreciated if you can get any comment.

Regards
Miao
