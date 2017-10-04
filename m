Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:47135 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdJDEiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Oct 2017 00:38:46 -0400
Received: by mail-oi0-f65.google.com with SMTP id p187so17757379oif.4
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 21:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAESLx0KUZaj68FS-+ndTEEHkih-46_NjPF45DgQeLFvhKAFiRQ@mail.gmail.com>
References: <CAESLx0KUZaj68FS-+ndTEEHkih-46_NjPF45DgQeLFvhKAFiRQ@mail.gmail.com>
From: Timothy White <timwhite88@gmail.com>
Date: Wed, 4 Oct 2017 14:38:44 +1000
Message-ID: <CAESLx0L7+ifAQYo3fcbMfmfb41FzvoifZcR3O7bHP0HFaiKBog@mail.gmail.com>
Subject: Re: Btrfs "failed to repair damaged filesystem" - RAID10 going RO
 when any write attempts are made
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any suggestions on this? Or do I just blow it away and hope the bug is
fixed in a newer version?

Regards

Tim

On Mon, Oct 2, 2017 at 8:44 PM, Timothy White <timwhite88@gmail.com> wrote:
> I have a BTRFS RAID 10 filesystem that was crashing and going into RO
> mode. A did a kernel upgrade, upgraded btrfs tools to the latest. A
> scrub was going ok ish. btrfs check showed a number of messages such
> as:
>
> Backref 16562625503232 root 14628 owner 3609 offset 23793664 num_refs
> 0 not found in extent tree
> Incorrect local backref count on 16562625503232 root 14628 owner 3609
> offset 23793664 found 1 wanted 0 back 0x5639c37689d0
> backpointer mismatch on [16562625503232 2703360]
>
> Root 14628 was a subvolume root ID (for docker), given that I didn't
> need any of that data, I removed all those subvolumes under the docker
> subvolume and the docker subvolume. This still showed errors, so I
> tried a btrfs check with repair, which eventually gave me the
> following.
>
> Backref 16563772112896 root 14628 owner 3608 offset 0 num_refs 0 not
> found in extent tree
> Incorrect local backref count on 16563772112896 root 14628 owner 3608
> offset 0 found 1 wanted 0 back 0x55f3403f40b0
> Backref disk bytenr does not match extent record,
> bytenr=16563772112896, ref bytenr=16563813335040
> Backref bytes do not match extent backref, bytenr=16563772112896, ref
> bytes=134217728, backref bytes=133079040
> Backref 16563772112896 root 14628 owner 3607 offset 0 num_refs 0 not
> found in extent tree
> Incorrect local backref count on 16563772112896 root 14628 owner 3607
> offset 0 found 1 wanted 0 back 0x55f3470cfed0
> Backref bytes do not match extent backref, bytenr=16563772112896, ref
> bytes=134217728, backref bytes=41222144
> backpointer mismatch on [16563772112896 134217728]
> attempting to repair backref discrepency for bytenr 16563772112896
> Ref is past the entry end, please take a btrfs-image of this file
> system and send it to a btrfs developer, ref 16563813335040
> failed to repair damaged filesystem, aborting
>
> I've taken a btrfs-image, however it's 12Gb, not sure if the
> developers want that, but I do have it.
>
> Filesystem still crashes and goes read only if I try and make changes
> (even deletes). The latest dmesg that includes that crash is at
> https://drive.google.com/open?id=0B5bmQmu6UugIRFM0RUxwWFdqOGc. I don't
> have the earlier ones.
>
> https://drive.google.com/open?id=0B5bmQmu6UugIYjZkYnA4ZFFpdlE is the
> output from running btrfs check with repair, followed by a second run
> with repair to see if it got anything different.
>
> At this stage, I expect to just blow away the filesystem and restore
> from backups. However it would be nice to fix whatever the issue is.
> Smartctl shows no underlying errors.
>
> What else do the devs want from me before I blow this away? (Or is it
> fixable with something I've missed, as that would save me many hours
> of restoration.
>
> The 12Gb btrfs-image can be uploaded to Google Drive (or FTP) if needed.
>
> Thanks
>
> Tim
>
> $ lsb_release -a
> No LSB modules are available.
> Distributor ID: Debian
> Description: Debian GNU/Linux 9.1 (stretch)
> Release: 9.1
> Codename: stretch
>
> $ uname -a
> Linux bruce 4.12.0-0.bpo.1-amd64 #1 SMP Debian 4.12.6-1~bpo9+1
> (2017-08-27) x86_64 GNU/Linux
>
> $ btrfs --version
> btrfs-progs v4.9.1
>
> $ btrfs fi show
> Label: 'Butter1'  uuid: b8d081ac-0271-4481-9a58-c113c921bf49
> Total devices 4 FS bytes used 5.19TiB
> devid    1 size 3.64TiB used 2.60TiB path /dev/sde
> devid    2 size 3.64TiB used 2.60TiB path /dev/sdf
> devid    3 size 3.64TiB used 2.60TiB path /dev/sdd
> devid    4 size 3.64TiB used 2.60TiB path /dev/sdc
>
> $ btrfs fi df /mnt/Butter1
> Data, RAID10: total=5.19TiB, used=5.17TiB
> System, RAID10: total=128.00MiB, used=560.00KiB
> Metadata, RAID10: total=12.00GiB, used=10.34GiB
> Metadata, single: total=16.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> $btrfs subvolume list /mnt/Butter1
> ID 258 gen 250368 top level 5 path data1
> ID 259 gen 250516 top level 5 path data2
> ID 3648 gen 250476 top level 5 path Photos
> ID 4597 gen 203041 top level 5 path Snapshots/Photos/20160304
> ID 4608 gen 203041 top level 5 path Snapshots/Photos/20160328
> ID 4628 gen 203041 top level 5 path Snapshots/Photos/20160421
> ID 4654 gen 250368 top level 5 path imap
> ID 4656 gen 203041 top level 5 path Snapshots/Photos/20160523
> ID 4893 gen 203041 top level 5 path Snapshots/Photos/20160702
> ID 4946 gen 203041 top level 5 path Snapshots/Photos/20160731
> ID 4947 gen 203041 top level 5 path Snapshots/Photos/20160813
> ID 4948 gen 203041 top level 5 path Snapshots/Photos/2016081301
> ID 4970 gen 203041 top level 5 path Snapshots/Photos/20160919
> ID 5038 gen 203041 top level 5 path Snapshots/Photos/20161229_0911
> ID 5063 gen 250515 top level 5 path mirror
> ID 13170 gen 250428 top level 5 path BizBackups
> ID 13214 gen 250368 top level 5 path SaraLaptopBackup
> ID 13485 gen 250368 top level 5 path PCOMDisks
> ID 16176 gen 229817 top level 5 path Snapshots/Photos/20170515
