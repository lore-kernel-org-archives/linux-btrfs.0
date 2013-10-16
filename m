Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51008 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3JPOGu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 10:06:50 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so294760bkb.29
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 07:06:48 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131015215819.GQ5787@twin.jikos.cz>
References: <1381859040-11211-1-git-send-email-fdmanana@gmail.com>
	<20131015180017.GC14323@localhost.localdomain>
	<CAL3q7H4GfCHX0hOuR6Som4N8KZqQ0p4Z0M9PTCw_8guSV=2r+g@mail.gmail.com>
	<20131015215819.GQ5787@twin.jikos.cz>
Date: Wed, 16 Oct 2013 15:06:48 +0100
Message-ID: <CAL3q7H7n35feUMRGS=5VW+kzzjJWT5vu-1NHcAOZmQ8sx2YOQw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix incorrect inode acl reset
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 10:58 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Oct 15, 2013 at 07:02:47PM +0100, Filipe David Manana wrote:
>> > Can you put this into an xfstest please?  Thanks,
>>
>> A new one or just add it to an existing one (and which)?
>
> There's xfstests/shared/051 that tests ACLs, but is run only against xfs
> and udf. I haven't verified it wrt btrfs, but maybe this test catches
> the bug. If not, please add a new test into the 'generic' category.

I adapted shared/051 to make it work with btrfs too.
However the test as it is, doesn't trigger the default ACL inheritance
issue, so I added the steps from the commit message to the test.

Thanks David.

>
> thanks,
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
