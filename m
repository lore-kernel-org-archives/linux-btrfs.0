Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E7DC04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 10:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 620622084E
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 10:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBeOn9hI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 620622084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbeLJKph (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 05:45:37 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:45252 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLJKpg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 05:45:36 -0500
Received: by mail-vk1-f193.google.com with SMTP id n126so2383435vke.12
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 02:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=3SzrCm3oHlPNfjIvXfqE3Ip+rN/qqEVsBrSoQcqZQrA=;
        b=sBeOn9hI2Hh6tqSw+0bPT09bqZwae7nkYaQzthqjY+88IIK+8Fohmb7DPVfhswlt6Q
         TMo/fq5m74DOEiI017ApwHuJViqyitPwvhGi476WqMlf1a/z0dPig5gm1oIUW05aXPBK
         EJ8A6zsA6fpjOeybgbzPsmuOY22EjUQC7fN8Ptpm98k8dPF1pAcuNJpfQbCfa8CMNKQt
         j6VLynXNY9VRkfA/fDu6zwhnP5PwXAibuUuCjfEOfUYuB2+JynJL61cJfI5MqdNJUVQB
         EuXXDAZYZKQp/SIoy2DtDHNoZBcPt9ocT59CXs4NDmN9ROqg1Swox85lCyobOfDZs4py
         tpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=3SzrCm3oHlPNfjIvXfqE3Ip+rN/qqEVsBrSoQcqZQrA=;
        b=UuVwunJ5jjk+rsbXuUnFFGGlvK2KQjYtBPJGAwDMsV/WmG8tUybPmYqtJMI3/+rpip
         HTubPbApfSpBhVXLOBt3f6+qVo2n/Py/sSeAAYvcslmhNJMozc0I1JTBAsWYs1/rWYRL
         BG/XRR7GbGefhwD0ZsZHYiyxjwK8knh2LaAEPvW1zUYt6eY6r9QDeFMipuZ1Hrlk6/6W
         TLxHy63TbFpJRmWgyseDNCsbW5e4gfvrQ7wGHUw0VWSkeq+jFH0G4xENIjkork9vkB8W
         q41MkFzjVBJyZ5Og8LfYkjuiaYygVhkbSSHEaayrFhcA1iUCSaEEkzs/FP+Aji72RuTR
         eysQ==
X-Gm-Message-State: AA+aEWZmhn0tLA7y/oa82aoBws2/UYVIZqhrbvcYQmUvvMhy/ru7kRoE
        7ZMlaEvnwBMa2sKwaUULmJD5uOX6SbQB2EYHilE=
X-Google-Smtp-Source: AFSGD/V860MeIqvC1xoLlHHRb7DI9EKJpAFkP97qJR2Wrz1MW32w8Pi1KIbSfWninQIT3SS1dqKms87OP4dopE83aaM=
X-Received: by 2002:a1f:4982:: with SMTP id w124mr4811792vka.4.1544438735151;
 Mon, 10 Dec 2018 02:45:35 -0800 (PST)
MIME-Version: 1.0
References: <20181108054919.18253-1-wqu@suse.com> <20181112213332.GS24115@twin.jikos.cz>
 <20181206193511.GF23615@twin.jikos.cz> <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
 <20181208004737.GH23615@twin.jikos.cz> <4cea2079-cef5-6833-884d-a3c8edc4c14a@suse.de>
In-Reply-To: <4cea2079-cef5-6833-884d-a3c8edc4c14a@suse.de>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 10 Dec 2018 10:45:23 +0000
Message-ID: <CAL3q7H61QEEHAK4PSfmx8PzO_cWRDPJeHEKizJjS=tdUzT2KSQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Dec 8, 2018 at 12:51 AM Qu Wenruo <wqu@suse.de> wrote:
>
>
>
> On 2018/12/8 =E4=B8=8A=E5=8D=888:47, David Sterba wrote:
> > On Fri, Dec 07, 2018 at 06:51:21AM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2018/12/7 =E4=B8=8A=E5=8D=883:35, David Sterba wrote:
> >>> On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
> >>>> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
> >>>>> This patchset can be fetched from github:
> >>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_reb=
ased
> >>>>>
> >>>>> Which is based on v4.20-rc1.
> >>>>
> >>>> Thanks, I'll add it to for-next soon.
> >>>
> >>> The branch was there for some time but not for at least a week (my
> >>> mistake I did not notice in time). I've rebased it on top of recent
> >>> misc-next, but without the delayed refs patchset from Josef.
> >>>
> >>> At the moment I'm considering it for merge to 4.21, there's still som=
e
> >>> time to pull it out in case it shows up to be too problematic. I'm
> >>> mostly worried about the unknown interactions with the enospc updates=
 or
> >>
> >> For that part, I don't think it would have some obvious problem for
> >> enospc updates.
> >>
> >> As the user-noticeable effect is the delay of reloc tree deletion.
> >>
> >> Despite that, it's mostly transparent to extent allocation.
> >>
> >>> generally because of lack of qgroup and reloc code reviews.
> >>
> >> That's the biggest problem.
> >>
> >> However most of the current qgroup + balance optimization is done insi=
de
> >> qgroup code (to skip certain qgroup record), if we're going to hit som=
e
> >> problem then this patchset would have the highest possibility to hit
> >> problem.
> >>
> >> Later patches will just keep tweaking qgroup to without affecting any
> >> other parts mostly.
> >>
> >> So I'm fine if you decide to pull it out for now.
> >
> > I've adapted a stress tests that unpacks a large tarball, snaphosts
> > every 20 seconds, deletes a random snapshot every 50 seconds, deletes
> > file from the original subvolume, now enhanced with qgroups just for th=
e
> > new snapshots inherigin the toplevel subvolume. Lockup.
> >
> > It gets stuck in a snapshot call with the follwin stacktrace
> >
> > [<0>] btrfs_tree_read_lock+0xf3/0x150 [btrfs]
> > [<0>] btrfs_qgroup_trace_subtree+0x280/0x7b0 [btrfs]
>
> This looks like the original subtree tracing has something wrong.
>
> Thanks for the report, I'll investigate it.

Btw, there's another deadlock with qgroups. I don't recall if I ever
reported it, but I still hit it with fstests (rarely happens) for at
least 1 year iirc:

[29845.732448] INFO: task kworker/u8:8:3898 blocked for more than 120 secon=
ds.
[29845.732852]       Not tainted 4.20.0-rc5-btrfs-next-40 #1
[29845.733248] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[29845.733558] kworker/u8:8    D    0  3898      2 0x80000000
[29845.733878] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs=
]
[29845.734183] Call Trace:
[29845.734499]  ? __schedule+0x3d4/0xbc0
[29845.734818]  schedule+0x39/0x90
[29845.735131]  btrfs_tree_read_lock+0xe7/0x140 [btrfs]
[29845.735430]  ? remove_wait_queue+0x60/0x60
[29845.735731]  find_parent_nodes+0x25e/0xe30 [btrfs]
[29845.736037]  btrfs_find_all_roots_safe+0xc6/0x140 [btrfs]
[29845.736342]  btrfs_find_all_roots+0x52/0x70 [btrfs]
[29845.736710]  btrfs_qgroup_trace_extent_post+0x37/0x80 [btrfs]
[29845.737046]  btrfs_add_delayed_data_ref+0x240/0x3d0 [btrfs]
[29845.737362]  btrfs_inc_extent_ref+0xb7/0x140 [btrfs]
[29845.737678]  __btrfs_mod_ref+0x174/0x250 [btrfs]
[29845.737999]  ? add_pinned_bytes+0x60/0x60 [btrfs]
[29845.738298]  update_ref_for_cow+0x26b/0x340 [btrfs]
[29845.738592]  __btrfs_cow_block+0x221/0x5b0 [btrfs]
[29845.738899]  btrfs_cow_block+0xf4/0x210 [btrfs]
[29845.739200]  btrfs_search_slot+0x583/0xa40 [btrfs]
[29845.739527]  ? init_object+0x6b/0x80
[29845.739823]  btrfs_lookup_file_extent+0x4a/0x70 [btrfs]
[29845.740119]  __btrfs_drop_extents+0x157/0xd70 [btrfs]
[29845.740524]  insert_reserved_file_extent.constprop.66+0x97/0x2f0 [btrfs]
[29845.740853]  ? start_transaction+0xa2/0x490 [btrfs]
[29845.741166]  btrfs_finish_ordered_io+0x344/0x810 [btrfs]
[29845.741489]  normal_work_helper+0xea/0x530 [btrfs]
[29845.741880]  process_one_work+0x22f/0x5d0
[29845.742174]  worker_thread+0x4f/0x3b0
[29845.742462]  ? rescuer_thread+0x360/0x360
[29845.742759]  kthread+0x103/0x140
[29845.743044]  ? kthread_create_worker_on_cpu+0x70/0x70
[29845.743336]  ret_from_fork+0x3a/0x50

It happened last friday again on 4.20-rcX. It's caused by a change
from 2017 (commit fb235dc06fac9eaa4408ade9c8b20d45d63c89b7 btrfs:
qgroup: Move half of the qgroup accounting time out of commit trans).
The task is deadlocking with itself.

thanks


> Qu
>
> > [<0>] do_walk_down+0x681/0xb20 [btrfs]
> > [<0>] walk_down_tree+0xf5/0x1c0 [btrfs]
> > [<0>] btrfs_drop_snapshot+0x43b/0xb60 [btrfs]
> > [<0>] btrfs_clean_one_deleted_snapshot+0xc1/0x120 [btrfs]
> > [<0>] cleaner_kthread+0xf8/0x170 [btrfs]
> > [<0>] kthread+0x121/0x140
> > [<0>] ret_from_fork+0x27/0x50
> >
> > and that's like 10th snapshot and ~3rd deltion. This is qgroup show:
> >
> > qgroupid         rfer         excl parent
> > --------         ----         ---- ------
> > 0/5         865.27MiB      1.66MiB ---
> > 0/257           0.00B        0.00B ---
> > 0/259           0.00B        0.00B ---
> > 0/260       806.58MiB    637.25MiB ---
> > 0/262           0.00B        0.00B ---
> > 0/263           0.00B        0.00B ---
> > 0/264           0.00B        0.00B ---
> > 0/265           0.00B        0.00B ---
> > 0/266           0.00B        0.00B ---
> > 0/267           0.00B        0.00B ---
> > 0/268           0.00B        0.00B ---
> > 0/269           0.00B        0.00B ---
> > 0/270       989.04MiB      1.22MiB ---
> > 0/271           0.00B        0.00B ---
> > 0/272       922.25MiB    416.00KiB ---
> > 0/273       931.02MiB      1.50MiB ---
> > 0/274       910.94MiB      1.52MiB ---
> > 1/1           1.64GiB      1.64GiB
> > 0/5,0/257,0/259,0/260,0/262,0/263,0/264,0/265,0/266,0/267,0/268,0/269,0=
/270,0/271,0/272,0/273,0/274
> >
> > No IO or cpu activity at this point, the stacktrace and show output
> > remains the same.
> >
> > So, considering this, I'm not going to add the patchset to 4.21 but wil=
l
> > keep it in for-next for testing, any fixups or updates will be applied.
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
