Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35829 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbcIIRvq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 13:51:46 -0400
Received: by mail-it0-f46.google.com with SMTP id w189so126320ith.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Sep 2016 10:51:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Sep 2016 11:51:44 -0600
Message-ID: <CAJCQCtS7y0qSsth4JwoRaCDig7nP-nRDs5ShEtudDR8JUNPaNw@mail.gmail.com>
Subject: Re: btrfs kernel oops on mount
To: moparisthebest <admin@moparisthebest.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 9, 2016 at 10:12 AM, moparisthebest
<admin@moparisthebest.com> wrote:
> Hi,
>
> I'm hoping to get some help with mounting my btrfs array which quit
> working yesterday.  My array was in the middle of a balance, about 50%
> remaining, when it hit an error and remounted itself read-only [1].
> btrfs fi show output [2], btrfs df output [3].
>
> I unmounted the array, and when I tried to mount it again, it locked up
> the whole system so even alt+sysrq would not work.  I rebooted, tried to
> mount again, same lockup.  This was all kernel 4.5.7.
>
> I rebooted to kernel 4.4.0, tried to mount, crashed again, this time a
> message appeared on the screen and I took a picture [4].
>
> I rebooted into an arch live system with kernel 4.7.2, tried to mount
> again, got some dmesg output before it crashed [5] and took a picture
> when it crashed [6], says in part 'BUG: unable to handle kernel NULL
> pointer dereference at 00000000000001f0'.
>
> Is there anything I can do to get this in a working state again or
> perhaps even recover some data?
>
> Thanks much for any help
>
> [1]: https://www.moparisthebest.com/btrfs/initial_crash.txt
> [2]: https://www.moparisthebest.com/btrfs/btrfsfishow.txt
> [3]: https://www.moparisthebest.com/btrfs/btrfsdf.txt
> [4]: https://www.moparisthebest.com/btrfsoops.jpg
> [5]: https://www.moparisthebest.com/btrfs/dmsgprecrash.txt
> [6]: https://www.moparisthebest.com/btrfsnulldereference.jpg

Good report. Try on the 4.7.2 kernel system, two consoles, have one
ready with 'echo w > /proc/sysrq-trigger' as root (sudo doesn't work)
but don't issue it, mount in the other console and then switch back
and issue the sysrq. It'll take a while, minutes maybe even to switch
consoles, and then also for the command itself to issue, and then
minutes before the result actually gets committed to systemd journal
or var/log/messages. If it's a systemd system, and if you have to
force reboot to regain control, you can get the sysrq with 'journalctl
-b-1 -k > outputfile.txt'

Also btrfs check output is useful to include also (without --repair
for starters).

The thing that concerns me is this occasional problem that comes up
sometimes with lzo compressed volumes. Duncan knows more about that
one so he may chime in. I would definitely only do default mounts for
the above, don't include the compression option. You could also try -o
ro,recovery and see where that gets you.


-- 
Chris Murphy
