Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbbGJNNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 09:13:44 -0400
Date: Fri, 10 Jul 2015 14:55:53 +0200
From: David Sterba <dsterba@suse.cz>
To: james harvey <jamespharvey20@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume tree (btrfs-progs feature request)
Message-ID: <20150710125553.GG726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+X5Wn4nsbiG5=LgLq8zhS0X3SB3dGa28-9taABEpGFxQvX2kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+X5Wn4nsbiG5=LgLq8zhS0X3SB3dGa28-9taABEpGFxQvX2kQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 08, 2015 at 09:21:26PM -0400, james harvey wrote:
> Request for new btrfs subvolume subcommand:
> 
> tree <path>
>    Display a depth indented listing of subvolumes present in the
> filesystem <path>.
> 
> ---or---
> 
> list ... --tree ...
>    ...
>    -tree
>       display subvolumes in a depth indented listing.

Good idea, I like that.

[...]
> "btrfs subvolume list /" can show 10 lines, with "tree -d" on a
> freshly installed system can show over 240,000 lines.
> 
> I think it's more likely for btrfs-progs to be able to implement this,
> than asking tree to make btrfs-specific code.

Agreed.
