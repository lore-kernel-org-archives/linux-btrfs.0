Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44671 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967587Ab3HINSi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 09:18:38 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so1082328bkb.10
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 06:18:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130808234454.GG5284@twin.jikos.cz>
References: <1375874984-31139-1-git-send-email-fdmanana@gmail.com>
	<20130808234454.GG5284@twin.jikos.cz>
Date: Fri, 9 Aug 2013 14:18:36 +0100
Message-ID: <CAL3q7H5y-6Gk8=F7jsQQgAGkuJp67m2MyGY2s7EVX=GQYWwrpw@mail.gmail.com>
Subject: Re: [PATCH RFC] Btrfs: track compression algorithm on inodes
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 9, 2013 at 12:44 AM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Aug 07, 2013 at 12:29:44PM +0100, Filipe David Borba Manana wrote:
>> Currently the compression settings (algorithm and force mode) need
>> to be specified at mount time in order to have newly created files
>> compressed.
> [...]
>
> I think we should take the top-down approach and start with UI how to
> set these attributes, then think where to store the information
> (existing strucutures, xattrs). Tweaking compressin per-file is
> desirable, but with your patch it's required to set it via a mount
> option and that's not very practical (only via remount, root required).

Good point. Not very practical for a user if remount and root
privilege are required.

>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
