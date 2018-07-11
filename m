Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46579 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389062AbeGKRx4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 13:53:56 -0400
Received: by mail-lj1-f195.google.com with SMTP id 203-v6so8992213ljj.13
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 10:48:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 11 Jul 2018 11:48:28 -0600
Message-ID: <CAJCQCtRxhAcpFxvbmdKfRxu+F5B0Epe9GVKQRdLkc41q8KuuZg@mail.gmail.com>
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
To: Udo Waechter <root@zoide.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 9:37 AM, Udo Waechter <root@zoide.net> wrote:
> Hello everyone,
>
> I have a corrupted filesystem which I can't seem to recover.
>
> The machine is:
> Debian Linux, kernel 4.9 and btrfs-progs v4.13.3
>
> I have a HDD RAID5 with LVM and the volume in question is a LVM volume.
> On top of that I had a RAID1 SSD cache with lvm-cache.
>
> Yesterday both! SSDs died within minutes. This lead to the corruped
> filesystem that I have now.
>
> I hope I followed the procedure correctly.
>
> What I tried so far:
> * "mount -o usebackuproot,ro " and "nospace_cache" "clear_cache" and all
> permutations of these mount options
>
> I'm getting:
>
> [96926.830400] BTRFS info (device dm-2): trying to use backup root at
> mount time
> [96926.830406] BTRFS info (device dm-2): disk space caching is enabled
> [96926.927978] BTRFS error (device dm-2): parent transid verify failed
> on 321269628928 wanted 3276017 found 3275985
> [96926.938619] BTRFS error (device dm-2): parent transid verify failed
> on 321269628928 wanted 3276017 found 3275985
> [96926.940705] BTRFS error (device dm-2): failed to recover balance: -5
> [96926.985801] BTRFS error (device dm-2): open_ctree failed
>
> The weird thing is that I can't really find information about the
> "failed to recover balance: -5" error. - There was no rebalancing
> running when during the crash.
>
> * btrfs-find-root: https://pastebin.com/qkjnSUF7 - It bothers me that I
> don't see any "good generations" as described here:
> https://btrfs.wiki.kernel.org/index.php/Restore
>
> * "btrfs rescue" - it starts, then goes to "looping on XYZ" then stops
>
> * "btrfs rescue super-recover -v" gives:
>
> All Devices:
>         Device: id = 1, name = /dev/vg00/...
> Before Recovering:
>         [All good supers]:
>                 device name = /dev/vg00/...
>                 superblock bytenr = 65536
>
>                 device name = /dev/vg00/...
>                 superblock bytenr = 67108864
>
>                 device name = /dev/vg00/...
>                 superblock bytenr = 274877906944
>
>         [All bad supers]:
>
> All supers are valid, no need to recover
>
>
> * Unfortunatly I did a "btrfs rescue zero-log" at some point :( - As it
> turns out that might have been a bad idea
>
>
> * Also, a "btrfs  check --init-extent-tree" - https://pastebin.com/jATDCFZy
>
> The volume contained qcow2 images for VMs. I need only one of those,
> since one piece of important software decided to not do backups :(
>
> Any help is highly appreciated.

You should ask for help sooner. It's much harder to give advice after
you've modified the file system multiple times since the original
problem happened. But maybe someone has ideas on the way forward,
other than 'btrfs restore' which is the offline scrape tool.
https://btrfs.wiki.kernel.org/index.php/Restore

There's a bunch of fixes since btrfs-progs 4.13 and 4.17 which is now
current. But anyway with lvmcache and the SSDs dying, it sounds like
there are too many transaction commits to Btrfs that are lost in the
failed lvmcache.

Also, gmail considers your email phishing. So something with your mail
is misconfigured for use on lists.

"This message has a from address in zoide.net but has failed
zoide.net's required tests for authentication.  Learn more"

My best guess from the header is that dmarc is set by your email
provider to fail, and while many mail clients ignore this, Google
honors it. And it's the dmarc fail that makes it incompatible with
email lists because lists always rewrite the email posting (they add
footers and rewrite headers).

Authentication-Results: mx.google.com;
       dkim=neutral (body hash did not verify) header.i=@zoide.net
header.s=mx header.b=vATMNdwx;
       spf=pass (google.com: best guess record for domain of
linux-btrfs-owner@vger.kernel.org designates 209.132.180.67 as
permitted sender) smtp.mailfrom=linux-btrfs-owner@vger.kernel.org;
       dmarc=fail (p=REJECT sp=REJECT dis=QUARANTINE) header.from=zoide.net


-- 
Chris Murphy
