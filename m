Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48337 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHTtJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 15:49:09 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so3213451lbo.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 12:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK=A7Ee84dXpc4DenR7-Sn8UPG-qTiRRS0fdvRCWT+hF1bPaSQ@mail.gmail.com>
References: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com>
 <5072CEB6.6030709@gmx.net> <CAK=A7Ee84dXpc4DenR7-Sn8UPG-qTiRRS0fdvRCWT+hF1bPaSQ@mail.gmail.com>
From: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Date: Mon, 8 Oct 2012 21:48:27 +0200
Message-ID: <CAK=A7EdEYds8i=dpXM9o6y7MnQ4W8Ze+wfvNJD9jAyGpe0Tf8w@mail.gmail.com>
Subject: Re: working quota example?
To: Arne Jansen <sensille@gmx.net>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, Oct 8, 2012 at 3:01 PM, Arne Jansen <sensille@gmx.net> wrote:
>>
>>
>> Please refer here <http://sensille.com/qgroups.pdf> for a discussion of
>> the
>> meaning of those values.

Thanks, I already read your paper a few days ago, but it was a quick
reading in order to try to understand the concepts.


>> Your mistake was to create the group 0/100 yourself. The command qgroup
>> create is only needed to create quota groups of subvolumes.

Yes, for me it wasn't clear if one could create quotas without having
first to play with qgroups explicitly.
Thanks for pointing that out !

>>
>> To limit the subvol:
>>
>> # btrfs qgroup limit 2m /mnt/test/sub1
>> # dd if=/dev/zero of=/mnt/test/sub1/file1 bs=10485760 count=1
>> dd: writing `/mnt/test/sub1/file1': Disk quota exceeded
>> 1+0 records in
>> 0+0 records out
>> 1966080 bytes (2.0 MB) copied, 0.0056283 s, 349 MB/s
>>
>> Hope that helps :)
>
Totally :)

Are there any plan to maybe get a better 'btrfs quota show' output? Maybe
with more details, maybe a simple ' 1 subvolume + all its snapshots'
accounting.
Maybe I missed something, and I admit I didn't read all the btrfs-progs
patches related to qgroups, but there doesn't seem to have an option to show
a subvolume's quota limit (not the referenced/exclusive usage counters). Am
 I right?

 Thanks again Arne for your help!
