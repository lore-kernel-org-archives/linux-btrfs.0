Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34622 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab3AOGsw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 01:48:52 -0500
From: David Brown <btrfs@davidb.org>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can moving data to a subvolume not take as long as a fully copy?
References: <20130114173250.GA23026@merlins.org>
Date: Mon, 14 Jan 2013 22:48:50 -0800
In-Reply-To: <20130114173250.GA23026@merlins.org> (Marc MERLIN's message of
	"Mon, 14 Jan 2013 09:32:50 -0800")
Message-ID: <87libvaqlp.fsf@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc@merlins.org> writes:

> I made a mistake and copied data in the root of a new btrfs filesystem.
> I created a subvolume, and used mv to put everything in there.
> Something like:
> cd /mnt
> btrfs subvolume create dir
> mv * dir
>
> Except it's been running for over a day now (ok, it's 5TB of data)
>
> Looks like mv is really copying all the data as if it were an entirely
> different filesystem.
>
> Is there not a way to short circuit this and only update the metadata?

Why not make a snapshot of the root volume, and then delete the files
you want to move from the original root, and delete the rest of root
from the snapshot?

David
