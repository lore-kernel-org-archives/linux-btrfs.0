Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:52131 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1431620AbdDYON1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 10:13:27 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 27F549B9DD
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Apr 2017 15:13:25 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id F026B5FBB9
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Apr 2017 15:13:24 +0100 (BST)
Subject: Re: backing up a collection of snapshot subvolumes
To: linux-btrfs@vger.kernel.org
References: <58FECA45.1010107@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <c324b8cc-bff0-fe6a-4a24-0aaee3adbca7@cobb.uk.net>
Date: Tue, 25 Apr 2017 15:13:24 +0100
MIME-Version: 1.0
In-Reply-To: <58FECA45.1010107@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/04/17 05:02, J. Hart wrote:
> I have a remote machine with a filesystem for which I periodically take
> incremental snapshots for historical reasons.  These snapshots are
> stored in an archival filesystem tree on a file server.  Older snapshots
> are removed and newer ones added on a rotational basis.  I need to be
> able to backup this archive by syncing it with a set of backup drives.
> Due to the size, I need to back it up incrementally rather than sending
> the entire content each time.  Due to the snapshot rotation, I need to
> be able to update the state of the archive backup filesystem as a whole,
> in much the same manner that rsync handles file trees.

If I have understood your requirement correctly, this seems to be
exactly matched to the capabilities of btrbk. I use btrbk to maintain a
similar backup disk which contains a full copy of my main data disk
along with various snapshots.

> It seems that I cannot use "btrfs send", as the archive directory
> contains the snapshots as subvolumes.

I'm not sure that you mean. If your problem is that btrfs send does not
cross subvolume boundaries then that is true: you would need to
configure btrbk to back up each subvolume. I have a cron job that checks
that all subvolumes (except the snapshots btrbk creates) are listed in
my btrbk configuration file.

Graham

