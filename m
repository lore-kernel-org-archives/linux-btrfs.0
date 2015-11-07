Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34631 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbbKGN6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 08:58:03 -0500
Received: by lffz63 with SMTP id z63so4361648lff.1
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 05:58:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151102151453.GI13624@twin.jikos.cz>
References: <20151102151453.GI13624@twin.jikos.cz>
Date: Sat, 7 Nov 2015 14:58:01 +0100
Message-ID: <CAJCQCtT1XxVqJ70j-NQ_-eLZTHvF66=8-0Xg=uo39=cg4=fwZg@mail.gmail.com>
Subject: Re: Btrfs progs pre-release 4.3-rc1
From: Chris Murphy <lists@colorremedies.com>
To: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 2, 2015 at 4:14 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> the kernel 4.3 was released yesterday, the btrfs-progs will follow at the end
> of this week. I've tagged an rc1 from current devel branch. There are a lots of
> small invisible changes and one change in the defaults:
>
> * mkfs: mixed mode is not forced anymore for devices smaller than 1 GiB

Why?

If it's still recommended to use mixed for small device, why not keep
it the default and just permit the user to manually specify something
else?


-- 
Chris Murphy
