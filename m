Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:34887 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaLPHwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 02:52:54 -0500
Received: by mail-yh0-f43.google.com with SMTP id z6so5895929yhz.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 23:52:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548FC4FA.6030009@jp.fujitsu.com>
References: <CABvhJLhSTfm711Hdp6_=7xEv44ejYmbSRPgqKT6a5jNHvxEWTA@mail.gmail.com>
	<548FC4FA.6030009@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 00:52:53 -0700
Message-ID: <CAJCQCtQ-+gkTVfV+ghVm_1sLRi3aQLpKZpD+eAdU_20p399OfQ@mail.gmail.com>
Subject: Re: "btrfs subvolume list" feature request
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 15, 2014 at 10:36 PM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:

> Is "btrfs property get <subvol>" (and some one liner) insufficient for
> your purpose?

I was not previously aware of btrfs property, thanks for mentioning
this. man btrfs does not list the property command; although man btrfs
property does explain it. So now I'm wondering what other commands
might not be listed in man btrfs.


-- 
Chris Murphy
