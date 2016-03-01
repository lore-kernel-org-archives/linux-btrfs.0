Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32966 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbcCANoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 08:44:22 -0500
MIME-Version: 1.0
In-Reply-To: <56D45C27.2080102@suse.cz>
References: <56CF5490.7040102@suse.cz>
	<56D04630.1020809@gmail.com>
	<56D0743F.9040102@suse.cz>
	<56D07FAF.3080605@gmail.com>
	<20160226175311.GC17997@ZenIV.linux.org.uk>
	<56D0A38B.3050701@suse.cz>
	<56D0B007.2050106@gmail.com>
	<20160226203010.GD17997@ZenIV.linux.org.uk>
	<56D0BCFC.5020302@suse.cz>
	<52677.1456524057@turing-police.cc.vt.edu>
	<56D45C27.2080102@suse.cz>
Date: Tue, 1 Mar 2016 21:44:21 +0800
Message-ID: <CACVXFVO2O2aV9aAeg6ubU6SFy-R+TSOxWjUUEV3gHbMPK_gngQ@mail.gmail.com>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs sub-volumes
From: Ming Lei <tom.leiming@gmail.com>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: Valdis.Kletnieks@vt.edu, Al Viro <viro@zeniv.linux.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 29, 2016 at 10:56 PM, Stanislav Brabec <sbrabec@suse.cz> wrote:
> On Feb 26, 2016 at 23:00 Valdis.Kletnieks@vt.edu wrote:
>>
>> On Fri, 26 Feb 2016 22:00:44 +0100, Stanislav Brabec said:
>>
>>> Well, it seems to be safe, even if the loop device was not allocated by
>>> mount(8) itself, as
>>> ioctl(fd, LOOP_CLR_FD)
>>> never returns EBUSY:
>>
>>
>> The fact you don't get an EBUSY doesn't mean it's actually safe....
>>
> Then, what should mount do, when -oloop is used and loop for the file
> is already set?
>
> 1) Verify that the loop device is a plain loop without encryption, and
> recycle it.
>
> 2) Allocate new loop device? (Known to cause issues, and corrupts
> structures on a current kernel.)
>
> 3) Trace loop devices allocated by mount itself and report error, if it
> was not allocated by mount. (But there can still be legitimate uses,
> e. g. two filesystems in one file, each at different offset, one of
> them is encrypted.)
>
> 3) Report error and recommend direct use of /dev/loop*. (See 3 plus
> setup of a system with /dev/loop* in fstab needs a non-standard
> actions.)
>
> 4) Other ideas?

One idea is to just take the loop which has been set for the file, and
it should work well no matter if the orignal loop is mounted or not.

Thanks,

>
>
> --
> Best Regards / S pozdravem,
>
> Stanislav Brabec
> software developer
> ---------------------------------------------------------------------
> SUSE LINUX, s. r. o.                         e-mail: sbrabec@suse.com
> Lihovarská 1060/12                            tel: +49 911 7405384547
> 190 00 Praha 9                                 fax:  +420 284 084 001
> Czech Republic                                    http://www.suse.cz/
> PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76



-- 
Ming Lei
