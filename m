Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47021 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaD2TOb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 15:14:31 -0400
Received: by mail-vc0-f180.google.com with SMTP id hq16so859373vcb.25
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 12:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Date: Tue, 29 Apr 2014 20:14:30 +0100
Message-ID: <CAMU1PDhc1xp3C2fDfs1mnxofn7wA3HxAjU14yw+1pT1_TUC1YQ@mail.gmail.com>
Subject: Re: [PATCH 00/14] Enhanced df - followup
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 April 2014 16:56, David Sterba <dsterba@suse.cz> wrote:
> Changes:
> * btrfs filesystem disk_usage - renamed to usage
>   * added a section of overall filesystem usage, that used to be in the
>     'fi df' output
> * btrfs device disk_usage - renamed to usage
>   * the device size prints both blockdevie size and the size that's occupied
>     by the filesystem
>   * device ID is printed

>  cmds-fi-disk_usage.c | 631 +++++++++++++++++++--------------------------------
>  cmds-fi-disk_usage.h |  35 ++-

After renaming the commands btrfs ... disk_usage to btrfs ... usage
should the source files also be renamed to cmds-fi-usage.[ch]?

Thanks,
Mike
