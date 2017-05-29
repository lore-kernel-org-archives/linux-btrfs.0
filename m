Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:15139 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdE2FcO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 01:32:14 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E952EAC00D2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 14:32:07 +0900 (JST)
Subject: Re: btrfs-progs 4.11 broke snap-sync
To: "Wael M. Nasreddine" <wael.nasreddine@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CA+kKtKA_MHaejLnNsR15Hy+WG6=9civcBOoWf0Me4QDcfy7WVQ@mail.gmail.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <a7b03b8f-c414-cbec-c979-7a2df6c3cdfc@jp.fujitsu.com>
Date: Mon, 29 May 2017 14:31:40 +0900
MIME-Version: 1.0
In-Reply-To: <CA+kKtKA_MHaejLnNsR15Hy+WG6=9civcBOoWf0Me4QDcfy7WVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/05/29 12:41, Wael M. Nasreddine wrote:
> Hello,
> 
> I use Arch, the system is entirely on btrfs (on a LUKS partition). I
> use snap-sync[0] to sync snapshots to an external drive. When 4.11
> came out, snap-sync errors out with the message: ERROR: unable to
> resolve -c.
> 
> Reverting back to 4.10 fixed the issue. I'm using kernel 4.9.29-lts
> and the problem has also been confirmed with kernel 4.11 zen.
> 
> Please find the bug filed against snap-sync at [1]
> 
> Should I file a bug for this? Is this even a bug or a breaking change?

I think that this is due to the following patch for updating the option parser.

  btrfs-progs: rework option parser to use getopt for global options
  https://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git/commit/?id=010ceab56e067b87ea282fde6ff792c1ceefd7dc

cf. https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg62226.html

Thanks,
Tsutomu

> 
> Thanks,
> 
> Wael
> 
> [0]: https://github.com/wesbarnett/snap-sync
> [1]: https://github.com/wesbarnett/snap-sync/issues/32
> 
> Exerpt from [1]:
> 
> [arch@arch ~]$ sudo snap-sync -n
> [sudo] password for arch:
> Select a mounted BTRFS device to backup to.
>    1) c91384af-f210-48f5-ba19-d6415a1bb447 (/)
>    2) c91384af-f210-48f5-ba19-d6415a1bb447 (/hackallthethings)
>    3) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/tmp)
>    4) c91384af-f210-48f5-ba19-d6415a1bb447 (/data)
>    5) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/abs)
>    6) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/log)
>    7) c91384af-f210-48f5-ba19-d6415a1bb447 (/var/cache/pacman/pkg)
>    8) c91384af-f210-48f5-ba19-d6415a1bb447 (/home)
>    9) c91384af-f210-48f5-ba19-d6415a1bb447 (/.snapshots)
>   10) c91384af-f210-48f5-ba19-d6415a1bb447 (/srv)
>   11) c91384af-f210-48f5-ba19-d6415a1bb447 (/home/arch/hackallthethings)
>   12) c91384af-f210-48f5-ba19-d6415a1bb447 (/home/arch/.local/share/Steam)
>   13) e5b8a2d6-85a1-4640-a659-acb8d6922bd6
> (/run/media/arch/e5b8a2d6-85a1-4640-a659-acb8d6922bd6)
>    0) Exit
> Enter a number: 13
> 
> You selected the disk with UUID e5b8a2d6-85a1-4640-a659-acb8d6922bd6.
> The disk is mounted at /run/media/arch/e5b8a2d6-85a1-4640-a659-acb8d6922bd6.
> 
> Creating new snapshot for root...
> Will backup //.snapshots/4641/snapshot to
> /run/media/arch/e5b8a2d6-85a1-4640-a659-acb8d6922bd6/backup/E744/root/4641//snapshot
> Sending incremental snapshot for root...
> ERROR: unable to resolve -c
> 
> 
