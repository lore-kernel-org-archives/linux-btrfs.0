Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58932 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2JOUO6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 16:14:58 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so3284793wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 13:14:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507C6CC8.9060100@profihost.ag>
References: <50771F22.3070501@profihost.ag>
	<20121011194335.GE4405@twin.jikos.cz>
	<50772408.9040303@profihost.ag>
	<507BE264.1060500@cn.fujitsu.com>
	<507C6239.1030208@profihost.ag>
	<CAOcd+r2sZYxxNRQS2h-LY9Fpd791JRKiVq2gT-xBpkPY8=FsQQ@mail.gmail.com>
	<507C6CC8.9060100@profihost.ag>
Date: Mon, 15 Oct 2012 22:14:57 +0200
Message-ID: <CAOcd+r226xqjvsF3H_B3=zxfQ3fkY3YP7FMeXP3b-fnO0Bqobw@mail.gmail.com>
Subject: Re: problems with btrfs send / restore
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: miaox@cn.fujitsu.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan,
the second issue you're seeing was discussed here:
http://www.spinics.net/lists/linux-btrfs/msg19672.html

You can apply the patch I sent there meanwhile, but as Miao pointed
out, I will need to make a better patch (hope will do it soon,
together with this one).

Thanks,
Alex.


On Mon, Oct 15, 2012 at 10:06 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> Am 15.10.2012 21:42, schrieb Alex Lyakas:
>
>> Is /btrfs/target/\@snapshot/ a subvolume or a directory?
>
> A simple directory.
>
>
>> can you pls try the patch that I posted here:
>> http://www.spinics.net/lists/linux-btrfs/msg19583.html
>>
>> I feel that you're hitting a similar issue here. Before you apply the
>> patch, please verify that you have /etc/mtab on your system (I will
>> make a more formal patch later).
>
>
> With your patch it works FINE!! Great!
>
> Another problem i'm seeing is:
>
> # btrfs send -i /btrfs/src/\@snapshot/1 /btrfs/src/\@snapshot/2 | btrfs
> receive /btrfs/target/\@snapshot/
> At subvol /btrfs/src/@snapshot/2
> ERROR: Failed to lookup path for root 0 - No such file or directory
> ERROR: unable to resolve path for root 350
>
> Then i have to wait some seconds and the same command works fine. I see the
> same with btrfs subvolume list PATH
>
> and it is unrelated to your patch.
>
> Stefan
