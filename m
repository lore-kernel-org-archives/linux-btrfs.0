Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33734 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750762AbbFHPtT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jun 2015 11:49:19 -0400
Message-ID: <5575B966.6050200@fb.com>
Date: Mon, 8 Jun 2015 11:48:54 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.1-rc6 - kernel crash after doing chattr +C
References: <a0a89c2461696c66da9b453d39967493@admin.virtall.com>
In-Reply-To: <a0a89c2461696c66da9b453d39967493@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/06/2015 02:07 AM, Tomasz Chmielewski wrote:
> 4.1-rc6, busy filesystem.
> 
> I was running mongo import which made quite a lot of IO.
> During the import, I did "chattr +C /var/lib/mongodb" - shortly after I
> saw this in dmesg and server died:
> 
> [57860.149839] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> [57860.149877] IP: [<ffffffffc0158b8e>]
> btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]

Sorry, it's not obvious where the 0000000000000008 is coming from, can
you turn btrfs_wait_pending_ordered+0x5e/0x110 into a line number?

Use list *btrfs_wait_pending_ordered+0x5e at the gdb prompt, after you
gdb btrfs.ko

-chris

