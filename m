Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33161 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdFPQJA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 12:09:00 -0400
Received: by mail-qt0-f173.google.com with SMTP id u12so69144676qth.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Jun 2017 09:08:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBeBZLu1NBLg1E4VCqT3qQND9bexb26ZLJLUpvE_aqe1MA@mail.gmail.com>
References: <CAN4oSBejGBYnv-8XWzhvupkdwKooC==KaXLUhAwAAxn0Q8iM3Q@mail.gmail.com>
 <CAN4oSBeBZLu1NBLg1E4VCqT3qQND9bexb26ZLJLUpvE_aqe1MA@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Fri, 16 Jun 2017 19:08:58 +0300
Message-ID: <CAN4oSBdTwtNHxDszD5UJVVwiDN6PuJNdhwps8OLNoKFz9NmcNQ@mail.gmail.com>
Subject: Re: No such file or directory error
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for above post, the error is just because of passing the parent
and current snapshots from different physical disks.



2017-06-16 9:29 GMT+03:00 Cerem Cem ASLAN <ceremcem@ceremcem.net>:
> Hello everybody,
>
> I'm facing with a "No such file or directory" issue which only occurs
> if I use a `btrfs send -p myparent mysnap` line in a script and its
> second call. Detailed description and error log is here:
> https://github.com/ceremcem/smith-sync/issues/5
>
> I use `btrfs send` command via a function:
>
> btrfs_send_diff () {
>     local parent=$1
>     local current=$2
>     if [[ -z $current ]]; then
>         echo_yellow "No parent specified, sending whole snapshot"
>         echo_red "parent: $parent, current: $current"
>         return 255
>         current=$1
>         btrfs send $current
>     else
>         echo_green "Sending difference between $parent and $current"
>         btrfs send -p $parent --no-data $current > /dev/null
>         if [[ $? != 0 ]]; then
>             echo_red "WE DETECT AN ERROR in ${FUNCNAME[0]}! parent:
> $parent, curr: $current"
>             exit
>         else
>             btrfs send -p $parent $current
>         fi
>     fi
> }
>
>
>
> Am I using `btrfs send` in a wrong way or is that a known issue with
> `btrfs send`?
