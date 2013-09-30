Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab3I3WyC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 18:54:02 -0400
Date: Mon, 30 Sep 2013 15:54:00 -0700
From: Zach Brown <zab@redhat.com>
To: =?utf-8?Q?Ond=C5=99ej?= Kunc <kunc88@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: init device stats for new devices
Message-ID: <20130930225400.GC10831@lenny.home.zabbo.net>
References: <CAOEw3RbDhA9_VhkuiewMWCXg5z4jqM9hR_=Uvq61a2A-w0vZxA@mail.gmail.com>
 <20130930215802.GB10831@lenny.home.zabbo.net>
 <CAOEw3Ratb6S_ddzvFwBG4cuk_20chFKwcXqQ9M4RNOdtSbC4Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAOEw3Ratb6S_ddzvFwBG4cuk_20chFKwcXqQ9M4RNOdtSbC4Ng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 01, 2013 at 12:03:05AM +0200, Ondřej Kunc wrote:
> Hi Zach,
> 
> thank you for your answer and clarification. I cannot just unmount and
> mount that filesystem, because it is running busy NFS server now, so I
> will just try it on some testbench server. Can mount -o remount be
> sufficient (to prevent stopping service, umount, mount and starting
> service) ?

Sadly, no, remounting won't initialize the stats.

- z
