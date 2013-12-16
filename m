Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59108 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab3LPRD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 12:03:26 -0500
Received: by mail-bk0-f44.google.com with SMTP id d7so2417953bkh.31
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 09:03:25 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131216143440.GE6498@twin.jikos.cz>
References: <1386963574-14467-1-git-send-email-fdmanana@gmail.com>
	<20131216143440.GE6498@twin.jikos.cz>
Date: Mon, 16 Dec 2013 17:03:25 +0000
Message-ID: <CAL3q7H5Eu8UQ-6zvsTB8omTMh-iMKAONYV7QEvRKbcMnyJ1U-g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix use of uninitialized err variable
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 2:34 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Dec 13, 2013 at 07:39:34PM +0000, Filipe David Borba Manana wrote:
>> >From the compiler:
>>
>> fs/btrfs/file.c: In function ‘prepare_pages.isra.18’:
>> fs/btrfs/file.c:1265:6: warning: ‘err’ may be used uninitialized in this function [-Wuninitialized]
>
> My gcc 4.8.1 does not see this warning, nor do I while inspecting the
> souces in current next-master.

Here it's gcc 4.6.3.



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
