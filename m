Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751417AbdIGQwM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 12:52:12 -0400
Date: Thu, 7 Sep 2017 18:50:43 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: test: add new test for inspect-internal
 rootid
Message-ID: <20170907165043.GC31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <77cca561-a951-87bf-36f0-4ab7f6de1597@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <77cca561-a951-87bf-36f0-4ab7f6de1597@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 07, 2017 at 10:48:27AM +0900, Misono, Tomohiro wrote:
> This new test checks inspect-internal rootid
>  - handle path to subvolume/directory/file as an argument
>  - get different id for each subvolume
>  - get the expected id for each file/directory (i.e. the same as
> 	 containing subvolume)
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied with minor fixups, thanks.
