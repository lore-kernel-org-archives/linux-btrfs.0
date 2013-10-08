Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab3JHQoa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 12:44:30 -0400
Date: Tue, 8 Oct 2013 09:44:27 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 02/12] btrfs-progs: check fopen failure in cmds-send
Message-ID: <20131008164427.GJ25712@lenny.home.zabbo.net>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
 <1381182185-10896-3-git-send-email-zab@redhat.com>
 <5253C552.7080609@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5253C552.7080609@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> And close(fd) is already called 4 lines above. You didn't run the static
> code analysis again after applying your patch :)

Nice, thanks for catching that.  I certainly didn't run it again, no :).

- z
