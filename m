Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:60396 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdI3SRL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 14:17:11 -0400
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
 <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
 <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
Message-ID: <a6f89874-2048-6903-9ebc-d28991a00adc@applied-asynchrony.com>
Date: Sat, 30 Sep 2017 20:17:09 +0200
MIME-Version: 1.0
In-Reply-To: <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/17 19:56, Holger Hoffstätte wrote:
> shell hackery as alternative. Anyway, I was sure that at the time the
> other letters sounded even worse/were taken, but that may just have been
> in my head. ;-)
> 
> I just rechecked and -S is still available, so that's good.

Except that it isn't really, since there is already an 'S'
case in cmds-subvolume.c as shortcut to --sort:

--
        case 'S':
            ret = btrfs_list_parse_sort_string(optarg,
                               &comparer_set);
--

..which is why I picked P at the time.

Holger
