Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752218AbdJ0NIL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 09:08:11 -0400
Date: Fri, 27 Oct 2017 15:06:21 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] btrfs-progs: doc: update btrfs device remove
Message-ID: <20171027130621.GI3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 10:41:42AM +0900, Misono, Tomohiro wrote:
> This updates help/doc of "btrfs device remove".
> 
> First patch adds the explanation that delete is the alias of remove to help message.
> Second patch adds the description of "remove missing", which is currently only
> written in wikipage, and example of device removal.
> 
> v1->v2:
>  split the patch and updates the messages
> v2->v3
>  withdrow "remove missing-all" feature
> v3->v4
>  add more description about missing to man

Thanks, applied.
