Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652E5C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 08:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 236762081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 08:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AaBW0A4e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 236762081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbeKFRlf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 12:41:35 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:40688 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbeKFRlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 12:41:35 -0500
Received: by mail-lj1-f180.google.com with SMTP id t22-v6so10585967lji.7
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Nov 2018 00:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cbNJUWbfcGhw4VO5FfL2KHnvEJIXHrQ+NkW6+yCCSwc=;
        b=AaBW0A4eXWOtEpcNbaOTCdWe34MZ7Li3BWqKHn2hPs7SfaNdZx3b+YqkziDZVO9tYo
         muEh1+369jFbcohQlbpVhy+xc0gPhtCWdMEiS7FogxyCPsU9qcLBy6TpMsH8F8fMbz/G
         HaFdqmAAmzVxU7CUEUdW0gWMvMxmzPcFJNaFbaxy+/lM9o7WZiloUQdblUDnSZxMEycE
         MeklQ2jv31HmD2YrJMxIwMg1TvJ/0BEwSADGkWpviL4Z9ZFtphZkR5P1f1iMTn4Zf1rE
         4szuCPVGrOAudNXDs01owbRV1W+aKDjvDlMJfBIMirBCmUdivCVxWKB8OXonPbH6H0wm
         VTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cbNJUWbfcGhw4VO5FfL2KHnvEJIXHrQ+NkW6+yCCSwc=;
        b=pFtzAOg+VeCHKxHGYNw/Bk/ra2f/+Oe/q9F1c3z72REi/0I64OMq2J0y+t7grrBIg3
         dRKuff7M2+Az3LyulsTRZsWicAZNp3em1wa2bBSQwrQnLxxms6bJttIZF0FbHjO0P+Ll
         SVZ7y3DQ95MpubD6wwuhy3U3nQNNCGY+X7rpDVk5SL0YUssXPmEgEATVQ+xXKdJRl5gP
         rHqnVSwrItQRInj13GBfqDeSjnl77WpXYyFkv+eo5IqUaZUpi4PMoT640v6MinhkqFjO
         aLHDMbd8QnS/ZMMVnNXogDat/gCm5jatnY0Pp90UY4aQZrVo5leQXQE2uajIqGOUszjJ
         0K8Q==
X-Gm-Message-State: AGRZ1gLee5qJgsGGWyajknMykCWjgSuUKSZo0aqlrIC/cJ/Hwxz7qKko
        NDNbmayhL3G1qIEoXGEGnkC7j81Ok8/q43mZuHsULLW6
X-Google-Smtp-Source: AJdET5cLJ3J1NmbBWVMOwz3Nw3rvPDvz/Ap0QdWqRzJoXov2XeENBLSY0Iw9uYKpErMhhnIIRJYXO/TdC+SAztnHvQc=
X-Received: by 2002:a2e:9b84:: with SMTP id z4-v6mr8318048lji.93.1541492250480;
 Tue, 06 Nov 2018 00:17:30 -0800 (PST)
MIME-Version: 1.0
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com> <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com>
In-Reply-To: <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com>
From:   Attila Vangel <vangel.attila@gmail.com>
Date:   Tue, 6 Nov 2018 09:17:16 +0100
Message-ID: <CAGSQd2-fUDpbBqN-0dAtLg=LBh7mDhHmxg59LGE6tXsRZJ-HAw@mail.gmail.com>
Subject: Re: btrfs partition is broken, cannot restore anything
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

Thanks again for the help.
In my case:

$ sudo btrfs check /dev/nvme0n1p2
Opening filesystem to check...
checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
bad tree block 18811453440, bytenr mismatch, want=3D18811453440, have=3D0
ERROR: cannot open file system

(same with --mode=3Dlowmem).

However "btrfs restore" seems to work! (did not have time for the
actual run yet)

What confused me about "btrds restore" is when I ran a dry run, it
just output about a dozen errors about some files, and I thought
that's it, no files can be restored.
Today I tried it with other options, especially -v shown me that the
majority of the files can be restored. I consider myself an
intermediate GNU plus Linux user, yet given the stressful situation
and being a first time user (btrfs n00b) I missed experimenting with
the -v option.

So I propose that "btrs restore" should always print a summary line at
the end to make it more user friendly (e.g. for the first time users).
Something like this:

x files restored in y directories[, total size of files is z <human
readable unit e.g. GB>]. Use -v command line option for more
information.

The part in square bracket is optional / nice to have, might be useful
e.g. to estimate the required free space in the target filesystem.

Cheers,
Attila

On Tue, Nov 6, 2018 at 2:28 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/11/6 =E4=B8=8A=E5=8D=882:01, Attila Vangel wrote:
> > Hi,
> >
> > TL;DR: I want to save data from my unmountable btrfs partition.
> > I saw some commands in another thread "Salvage files from broken btrfs"=
.
> > I use the most recent Manjaro live (kernel: 4.19.0-3-MANJARO,
> > btrfs-progs 4.17.1-1) to execute these commands.
> >
> > $ sudo mount -o ro,nologreplay /dev/nvme0n1p2 /mnt
> > mount: /mnt: wrong fs type, bad option, bad superblock on
> > /dev/nvme0n1p2, missing codepage or helper program, or other error.
> >
> > Corresponding lines from dmesg:
> >
> > [ 1517.772302] BTRFS info (device nvme0n1p2): disabling log replay at m=
ount time
> > [ 1517.772307] BTRFS info (device nvme0n1p2): disk space caching is ena=
bled
> > [ 1517.772310] BTRFS info (device nvme0n1p2): has skinny extents
> > [ 1517.793414] BTRFS error (device nvme0n1p2): bad tree block start,
> > want 18811453440 have 0
> > [ 1517.793430] BTRFS error (device nvme0n1p2): failed to read block gro=
ups: -5
> > [ 1517.808619] BTRFS error (device nvme0n1p2): open_ctree failed
>
> Extent tree corrupted.
>
> If it's the only problem, btrfs-restore should be able to salvage data.
>
> >
> > $ sudo btrfs-find-root /dev/nvme0n1p2
>
> No, that's not what you need.
>
> > Superblock thinks the generation is 220524
> > Superblock thinks the level is 1
> > Found tree root at 25018368 gen 220524 level 1
> > Well block 4243456(gen: 220520 level: 1) seems good, but
> > generation/level doesn't match, want gen: 220524 level: 1
> > Well block 5259264(gen: 220519 level: 1) seems good, but
> > generation/level doesn't match, want gen: 220524 level: 1
> > Well block 4866048(gen: 220518 level: 0) seems good, but
> > generation/level doesn't match, want gen: 220524 level: 1
> >
> > $ sudo btrfs ins dump-super -Ffa /dev/nvme0n1p2
> > superblock: bytenr=3D65536, device=3D/dev/nvme0n1p2
> [snip]
> >
> > If I understood correctly, somehow it is possible to use this data to
> > parametrize btrfs restore to save the files from the partition.
>
> None of the output is really helpful.
>
> In your case, your extent tree is corrupted, thus kernel will refuse to
> mount (even RO).
>
> You should run "btrfs check" on the fs to see if btrfs can check fs tree.
> If not, then go directly to "btrfs restore".
>
> Thanks,
> Qu
>
> > Could you please help how to do it in this case? I am not familiar
> > with these technical terms in the outputs.
> > Thanks in advance!
> >
> > Cheers,
> > Attila
> >
> > On Thu, Nov 1, 2018 at 8:40 PM Attila Vangel <vangel.attila@gmail.com> =
wrote:
> >>
> >> Hi,
> >>
> >> Somehow my btrfs partition got broken. I use Arch, so my kernel is
> >> quite new (4.18.x).
> >> I don't remember exactly the sequence of events. At some point it was
> >> accessible in read-only, but unfortunately I did not take backup
> >> immediately. dmesg log from that time:
> >>
> >> [ 62.602388] BTRFS warning (device nvme0n1p2): block group
> >> 103923318784 has wrong amount of free space
> >> [ 62.602390] BTRFS warning (device nvme0n1p2): failed to load free
> >> space cache for block group 103923318784, rebuilding it now
> >> [ 108.039188] BTRFS error (device nvme0n1p2): bad tree block start 0 1=
8812026880
> >> [ 108.039227] BTRFS: error (device nvme0n1p2) in
> >> __btrfs_free_extent:7010: errno=3D-5 IO failure
> >> [ 108.039241] BTRFS info (device nvme0n1p2): forced readonly
> >> [ 108.039250] BTRFS: error (device nvme0n1p2) in
> >> btrfs_run_delayed_refs:3076: errno=3D-5 IO failure
> >>
> >> At the next reboot it failed to mount. Problem may have been that at
> >> some point I booted to another distro with older kernel (4.15.x,
> >> 4.14.52) and unfortunately attempted some checks/repairs (?) e.g. from
> >> gparted, and at that time I did not know it could be destructive.
> >>
> >> Anyway, currently it fails to mount (even with ro and/or recovery),
> >> btrfs check results in "checksum verify failed" and "bad tree block"
> >> errors, btrfs restore resulted in "We have looped trying to restore
> >> files in" errors for a dozen of paths then exit.
> >>
> >> Is there some hope to save data from the filesystem, and if so, how?
> >>
> >> BTW I checked some diagnostics commands regarding my SSD with the nvme
> >> client and from that it seems there are no hardware problems.
> >>
> >> Your help is highly appreciated.
> >>
> >> Cheers,
> >> Attila
>
