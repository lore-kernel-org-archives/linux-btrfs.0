Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37890 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbcAXAIM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 19:08:12 -0500
Received: by mail-ig0-f172.google.com with SMTP id mw1so12571580igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 16:08:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160123235536.GZ422@carfax.org.uk>
References: <CAJCQCtRyyu3rdyyykEjf8neLh3R+12to_gcCpU2ss51dU-_7PA@mail.gmail.com>
	<20160123235536.GZ422@carfax.org.uk>
Date: Sat, 23 Jan 2016 17:08:11 -0700
Message-ID: <CAJCQCtSfgXtj-vjCfj31mp0nuWcdmYOe+DhcmT0VQsaXBEGaFg@mail.gmail.com>
Subject: Re: [bug] btrfs send -e option always fails ERROR: unexpected EOF in stream.
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 23, 2016 at 4:55 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Jan 23, 2016 at 04:48:26PM -0700, Chris Murphy wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=111221
>>
>> 4.4.0-1.fc24.x86_64
>> btrfs-progs-4.3.1-1.fc23.x86_64
>>
>>
>>
>> [...snip...]
>> BTRFS_IOC_SEND returned 0
>> joining genl thread
>> At subvol testsub.1
>> ERROR: parent determination failed for 0
>
>    This looks to me like a known and somewhat awkward bug/misfeature
> where the mountpoint containing either the subvol being sent or the
> target location for the receive is not a top-level mount, which causes
> this error. i.e., this will (I think) fail:
>
> # mount -o subvol=@foo /dev/sda1 /mnt
> # btrfs send /mnt/@whatever | ...
>
>    Can you try again from within a subvolid=0 mount?

No change in behavior.

/dev/mapper/luks on /brick1 type btrfs
(rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)
/dev/sda1 on /mnt type btrfs
(rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)


[root@f23s ~]# btrfs send -e /mnt/root23s/root/testsub.* | btrfs
receive /brick1/
At subvol /mnt/root23s/root/testsub.0
At subvol testsub.0
At subvol /mnt/root23s/root/testsub.1
ERROR: parent determination failed for 0
ERROR: unexpected EOF in stream.



[root@f23s ~]# btrfs send -e /mnt/root23s/root/testsub.0
/mnt/root23s/root/testsub.1 /mnt/root23s/root/testsub.2
/mnt/root23s/root/testsub.3 /mnt/root23s/root/testsub.4 | btrfs
receive /brick1/
At subvol /mnt/root23s/root/testsub.0
At subvol testsub.0
At subvol /mnt/root23s/root/testsub.1
ERROR: parent determination failed for 0
ERROR: unexpected EOF in stream.



Chris Murphy




-- 
Chris Murphy
