Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36172 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753226AbcIITVD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 15:21:03 -0400
Received: by mail-it0-f54.google.com with SMTP id i184so28360284itf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Sep 2016 12:21:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51221d34-b417-045d-46f6-6965883574bd@moparisthebest.com>
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <CAJCQCtS7y0qSsth4JwoRaCDig7nP-nRDs5ShEtudDR8JUNPaNw@mail.gmail.com> <51221d34-b417-045d-46f6-6965883574bd@moparisthebest.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Sep 2016 13:21:00 -0600
Message-ID: <CAJCQCtQw17cibOc6tnMvfOws=8PHuuwUvX35sY4WuRCAm=Ojyw@mail.gmail.com>
Subject: Re: btrfs kernel oops on mount
To: moparisthebest <admin@moparisthebest.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 9, 2016 at 12:32 PM, moparisthebest
<admin@moparisthebest.com> wrote:

> This is indeed an lzo compressed system, it's always been mounted with
> that option anyhow.
>
> btrfs check has been running for ~6 hours so far, I'll follow up with
> output on that when it finishes.
>
> Hmm, the problem with the 4.7.2/systemd system is it's a live usb system
> so the log/journal wouldn't be saved anywhere except tmpfs, I'll see
> what I can rig up unless someone has any amazing ideas?  I'm still brand
> new to systemd...

Pick the easier of:
1.
ssh with a remote computer; the blocked tasks will slow down sshd and
the responsiveness of everything; but it shouldn't totally inhibit it
and may be more reliable than a local VT if the command is pretyped
and ready to go before you initiate the mount. Use journalctl -fk to
follow, and save out the output as  text file from that remote
computer.
2.
netconsole might be more reliable than sshd in this case, again just
connect with a remote computer, and in its Terminal you can do:
journalctl -fk
3.
Create a file system on a USB stick partition, copy live's /var to the
stick, then mount the stick over the live's /var, and now it's read
writeable. And then:
           mkdir -p /var/log/journal
           systemd-tmpfiles --create --prefix /var/log/journal

I think that will cause systemd-journald to flush to /var now, you can do:
journalctl -b | grep journald

And see if you have lines like this:
Sep 09 09:11:05 f24m systemd-journald[238]: Journal stopped
Sep 09 09:11:06 f24m systemd-journald[549]: Runtime journal
(/run/log/journal/) is 8.0M, max 393.2M, 385.2M free.
Sep 09 09:11:06 f24m systemd-journald[549]: System journal
(/var/log/journal/) is 999.7M, max 1.0G, 24.2M free.
Sep 09 09:11:07 f24m systemd-journald[549]: Time spent on flushing to
/var is 1.040757s for 1490 entries.
Sep 09 09:11:07 f24m systemd-journald[238]: Received SIGTERM from PID
1 (systemd).

So what happens when you force reboot? Mount this stick, and use
'journalctl -D /mnt/log/journal/machineid/ > outputfile.txt' which
will point to the journal binary file and write it out to a text file.
You could try -k to filter out just kernel messages but since that
implies -b and you have a different boot than what's in this journal I
have no idea off hand if that will work;  you could also filter by |
grep kernel > outputfile.txt but maybe not every line will have kernel
in it? I just tried it  with sysrq t and everything relevant seems to
have "kernel" in each line.


They're probably in order of ease; but not sure which is more reliable
when things are being blocked. Network may be more or less blocked
*shrug* I'd use XFS for the stick file system for /var.


Chris Murphy
