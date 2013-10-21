Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:52794 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3JUX1W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 19:27:22 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so1011065bkb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 16:27:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131021232107.GS1032@suse.cz>
References: <1381092807-21422-1-git-send-email-fdmanana@gmail.com>
	<1381094553-2190-1-git-send-email-fdmanana@gmail.com>
	<20131011114229.GE5787@twin.jikos.cz>
	<CAL3q7H6o3auNremGh8X0oFF_OcVuwpSxsOrAKDBmtx+d4eLxAQ@mail.gmail.com>
	<20131021232107.GS1032@suse.cz>
Date: Tue, 22 Oct 2013 00:27:21 +0100
Message-ID: <CAL3q7H4MYgGUoDHOcBDv9H7cBFC+1VqM2395qTQN=DSoTv6ZXA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: improve inode hash function/inode lookup
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 12:21 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Oct 11, 2013 at 06:20:16PM +0100, Filipe David Manana wrote:
>> Good point David. However it would be a rather radical behaviour change imho.
>
> A radical step to prevent this practictly impossible but nasty bug to
> happen :)
>
>> I think it should be a separate change if there are no objections
>> against such change.
>
> It is a separate change that makes your patch obsolete.

Except the part of making the hash value depend on both object id and
root id, no?

>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
