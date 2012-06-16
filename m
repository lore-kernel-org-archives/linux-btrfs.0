Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41432 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2FPMBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 08:01:54 -0400
Received: by yhmm54 with SMTP id m54so3086350yhm.19
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 05:01:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120616145704.039809d2@sf.home>
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
 <20120616145704.039809d2@sf.home>
From: rupert THURNER <rupert.thurner@gmail.com>
Date: Sat, 16 Jun 2012 14:01:33 +0200
Message-ID: <CAJs9aZ-9EK2HUuvBDuiPSG2O5J16seO6Hp3=wJLYAJBi9KDL+Q@mail.gmail.com>
Subject: Re: cannot remove files: "rm" gives "no space left on device",
 3.2.0-24, ubuntu
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 16, 2012 at 1:57 PM, Sergei Trofimovich <slyich@gmail.com> wrote:
> On Sat, 16 Jun 2012 13:16:09 +0200
> rupert THURNER <rupert.thurner@gmail.com> wrote:
>
>> how would i be able to delete something off this btrfs partition
>> again? i saw the following messages in the archives which seem to be a
>> little similar ... except a reboot and therfor a remount did not help:
>> * http://article.gmane.org/gmane.linux.kernel/1265666/match=enospc
>>
>> rt@tv:~$ rm -rf /media/388gb-data/.Trash-1000/info/foto.trashinfo
>> rm: cannot remove `/media/388gb-data/.Trash-1000/info/foto.trashinfo':
>> No space left on device
>>
>> rt@tv:~$ btrfs filesystem df /media/388gb-data/
>> Data: total=260.59GB, used=254.56GB
>> System: total=32.00MB, used=24.00KB
>> Metadata: total=128.00GB, used=120.01GB
>
> Looks like there is a bit of space.
> Try to mount with
>    '-onospace_cache,clear_cache,enospc_debug'
> and check if it still reports an ENOSPC error.
still same error.

> Will result in anything reported in 'dmesg' output?
[ 6431.514454] device label 388gb-data devid 1 transid 1086 /dev/sda6
[ 6431.514969] btrfs: disabling disk space caching
[ 6431.514977] btrfs: force clearing of disk cache
