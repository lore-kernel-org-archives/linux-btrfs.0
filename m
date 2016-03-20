Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33078 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcCTCKL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 22:10:11 -0400
Received: by mail-wm0-f45.google.com with SMTP id l68so113419987wml.0
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 19:10:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRnCVsAnLH9Ty5fT_9gMSPNTprje-qqDbqbEKt_w3CfzQ@mail.gmail.com>
References: <trinity-af54e977-779b-4ee5-82a0-5022c97ad5c5-1458430500649@3capp-gmx-bs56>
	<CAJCQCtRnCVsAnLH9Ty5fT_9gMSPNTprje-qqDbqbEKt_w3CfzQ@mail.gmail.com>
Date: Sat, 19 Mar 2016 22:10:09 -0400
Message-ID: <CAD=QJKjj4qW9SBopvPYhpwov04Mn1cjFvkLiBmrUDXjhOaNshA@mail.gmail.com>
Subject: Re: unable to mount btrfs partition, please help :(
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 March 2016 at 21:34, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Mar 19, 2016 at 5:35 PM, Patrick Tschackert <Killing-Time@gmx.de> wrote:
>>>> $ uname -a
>>>> Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
>>>> (2016-02-29) x86_64 GNU/Linux
>>>This is old. You should upgrade to something newer, ideally 4.5 but
>>>4.4.6 is good also, and then oldest I'd suggest is 4.1.20.
>>
>> Shouldn't I be able to get the newest kernel by executing "apt-get update && apt-get dist-upgrade"?
>> That's what I ran just now, and it doesn't install a newer kernel. Do I really have to manually upgrade to a newer one?
>
> I'm not sure. You might do a list search for debian, as I know debian
> users are using newer kernels that they didn't build themselves.
>
>
>> On top of the sticky situation i'm already in, i'm not sure if I trust myself manually building a new kernel. Should I?

If you enable Debian backports, which I assume you have since you're
running the version of btrfs-progs that was backported without a
warning not to use it with old kernels...well, if backports are
enabled then you can try:

apt-get install -t jessie-backports linux-image-4.3.0-0.bpo.1-amd64

linux-4.3.x was a complete mess for both my laptop (Thinkpad X220,
quite well supported), and I'm not sure if it was driver-related or
btrfs-related.  I actually started tracking linux-4.4 at rc1, it was
so bad.

If you don't want to try building your own kernel, I'd file a bug
report against linux-image-amd64 asking for a backport of linux-4.4,
which is in Stretch/testing; I'm surprised it hasn't been backported
yet...  The only issue I remember is an error message when booting, I
think because the microcode interface changed between 4.3.x and 4.4.x.
Installing microcode-related packages from backports is how think I
worked around this.

Alternatively, if you want to build your own kernel you might be able
to install linux-image from backports, download and untar linux-4.1.x
somewhere, and then copy the config from /boot/config-4.3* to
somedir/linux-4.1.x/.config.

I uploaded two scripts to github that I've been using for ages to
track the upstream LTS kernel branch that Debian didn't choose.  You
can find them here:

https://github.com/sten0/lts-convenience

All those syncs and btrfs sub sync lines are there because I always
seem to run strange issues with adding and removing snapshots.

Cheers,
Nicholas
