Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.univ-lille1.fr ([193.49.225.20]:44470 "EHLO
	smtp02.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319AbbDWSFb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 14:05:31 -0400
Message-ID: <5539345C.1040905@gnieh.org>
Date: Thu, 23 Apr 2015 20:05:16 +0200
From: Martin Monperrus <martin.monperrus@gnieh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: How to repair a BTRFS block?
References: <55320BAE.1030007@gnieh.org>
In-Reply-To: <55320BAE.1030007@gnieh.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

More on my issue, I have "uncorrectable errors"

# btrfs scrub status /
scrub status for e11013b3-b244-4d1a-a9c7-3956db1a699c
    scrub started at Thu Apr 23 19:07:45 2015 and finished after 372 seconds
    total bytes scrubbed: 167.13GiB with 13 errors
    error details: read=13
    corrected errors: 0, uncorrectable errors: 13, unverified errors: 0

Before going to my backups, how can know the files impacted by those
uncorrectable errors?

Best regards,

--Martin



On 04/18/2015 09:45 AM, Martin Monperrus wrote:
> Dear Btrfs developers,
>
> For some unknown reasons, my BTRFS filesystem is corrupted. dmesg prints
>
> |BTRFS critical (device sda2): corrupt leaf, slot offset bad:
> block=43231330304,root=1, slot=47|
>
> (more than 1000x in the dmesg trace).
>
> btrfs check --repair fails with:
>
> read block failed check_tree_block
> incorrect offset 12725 2298746482
> items overlap, can't fix
> cmds_check.c:2918: fix_item_offset: Assertion 'ret' failed
>
> How to list the files in block #43231330304 affected by the corruption?
> How to repair block #43231330304?
>
> Best regards,
>
> --Martin
>

