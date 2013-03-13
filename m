Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65085 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3CMFHk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 01:07:40 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq4so2438350wib.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 22:07:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513FDE67.1050907@redhat.com>
References: <201303131238.33692.russell@coker.com.au>
	<513FDE67.1050907@redhat.com>
Date: Wed, 13 Mar 2013 01:07:34 -0400
Message-ID: <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
Subject: Re: Debian 3.7.1 BTRFS crash
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: russell@coker.com.au, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 10:03 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> [   37.176790] BTRFS error (device dm-0) in __btrfs_free_extent:5143: IO failure
> [   37.176791] btrfs is forced readonly
> [   37.176793] btrfs: run_one_delayed_ref returned -5
>


It seems the SSD has bad blocks now, BTRFS seems to abuse SSD disks, I
burnt 1 SSD disk and 2 USB flash drive since I'm using BTRFS, in about
2 months for each. ddrescue'ing the SSD would probably give better
chances of recovery and give BTRFS/btrfsck a chance to write correctly
to the newly copied image.
