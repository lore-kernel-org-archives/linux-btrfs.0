Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18440 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaIOQnn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 12:43:43 -0400
Message-ID: <54171711.8010107@oracle.com>
Date: Tue, 16 Sep 2014 00:42:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Sam Thursfield <sam.thursfield@codethink.co.uk>,
        linux-btrfs@vger.kernel.org
CC: baserock-dev@baserock.org, johannes.hirte@datenkhaos.de,
        xavier.gnata@gmail.com, 1i5t5.duncan@cox.net
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk>
In-Reply-To: <5417022A.5000101@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Logs from Sam, tells the problem clearly.  mount is using
  /dev/sda, but mount error message and kernel is using /dev/vda.

----------------------
$ mount /dev/sda /home -t btrfs -o subvol=/state/home,defaults,rw,noatime
mount: /dev/vda is already mounted or /home busy
        /dev/vda is already mounted on /

$ btrfs fi show
Label: 'baserock'  uuid: 9a1b9724-d64c-4709-9ce0-b7ad98054385
	Total devices 1 FS bytes used 1.45GB
	devid    1 size 4.00GB used 2.06GB path /dev/vda
----------------------

  any idea what provided kernel the path /dev/vda ?
  Do we still have /dev/vda at the time of above mount cmd. ?

  Further if you use /dev/vda instead of /dev/sda for the mount,
  it should work. Provided vda is still there.

Thanks, Anand




On 15/09/2014 23:13, Sam Thursfield wrote:
> Hi!
>
> I'm having an issue with the 3.17rc5 kernel which prevents having
> multiple subvolumes of the same disk mounted.
>
> I'm not sure exactly the cause. I thought it might be because in my
> system the root file system is itself a subvolume of the disk I'm trying
> to mount. But if I create a second disk image with two subvolumes, the
> same thing occurs -- I can only mount one of them at a time.
>
> I've attached the output of a few commands, please let me know if you
> want more info (I'm not subscribed to the list, please keep me in To:).
>
> We've bisected and found that the exact commit that changed the
> behaviour is this one:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b96de000bc8bc9688b3a2abea4332bd57648a49f
>
>
> I'm afraid I'm not familiar with the Btrfs code base and so I don't
> understand the exact meaning of the comments in that commit.
>
> Thanks
> Sam
>
