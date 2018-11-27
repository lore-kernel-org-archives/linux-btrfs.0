Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF17C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ECFF20989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:12:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ECFF20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbeK1BLA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 20:11:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:36750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbeK1BLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 20:11:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 041ADAE03;
        Tue, 27 Nov 2018 14:12:55 +0000 (UTC)
Subject: Re: [PATCH] Fix typos in docs (second try...)
To:     Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181127135615.22912-1-andrea.gelmini@gelma.net>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <28939b53-e2cb-9ff0-8458-a6d55913d670@suse.com>
Date:   Tue, 27 Nov 2018 16:12:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181127135615.22912-1-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.11.18 г. 15:56 ч., Andrea Gelmini wrote:
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  Documentation/DocConventions          | 4 ++--
>  Documentation/ReleaseChecklist        | 4 ++--
>  Documentation/btrfs-man5.asciidoc     | 8 ++++----
>  Documentation/btrfs-property.asciidoc | 2 +-
>  Documentation/btrfs-qgroup.asciidoc   | 4 ++--
>  Documentation/mkfs.btrfs.asciidoc     | 2 +-
>  6 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/DocConventions b/Documentation/DocConventions
> index e84ed7a..969209c 100644
> --- a/Documentation/DocConventions
> +++ b/Documentation/DocConventions
> @@ -23,7 +23,7 @@ Quotation in subcommands:
>  - command reference: bold *btrfs fi show*
>  - section references: italics 'EXAMPLES'
>  
> -- argument name in option desciption: caps in angle brackets <NAME>
> +- argument name in option description: caps in angle brackets <NAME>
>    - reference in help text: caps NAME
>      also possible: caps italics 'NAME'
>  
> @@ -34,6 +34,6 @@ Quotation in subcommands:
>    - optional parameter with argument: [-p <path>]
>  
>  
> -Refrences:
> +References:
>  - full asciidoc syntax: http://asciidoc.org/userguide.html
>  - cheatsheet: http://powerman.name/doc/asciidoc
> diff --git a/Documentation/ReleaseChecklist b/Documentation/ReleaseChecklist
> index d8bf50c..ebe251d 100644
> --- a/Documentation/ReleaseChecklist
> +++ b/Documentation/ReleaseChecklist
> @@ -4,7 +4,7 @@ Release checklist
>  Last code touches:
>  
>  * make the code ready, collect patches queued for the release
> -* look to mailinglist for any relevant last-minute fixes
> +* look to mailing list for any relevant last-minute fixes
>  
>  Pre-checks:
>  
> @@ -31,7 +31,7 @@ Release:
>  
>  Post-release:
>  
> -* write and send announcement mail to mailinglist
> +* write and send announcement mail to mailing list
>  * update wiki://Main_page#News
>  * update wiki://Changelog#btrfs-progs
>  * update title on IRC
> diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
> index 448710a..4a269e2 100644
> --- a/Documentation/btrfs-man5.asciidoc
> +++ b/Documentation/btrfs-man5.asciidoc
> @@ -156,7 +156,7 @@ under 'nodatacow' are also set the NOCOW file attribute (see `chattr`(1)).
>  NOTE: If 'nodatacow' or 'nodatasum' are enabled, compression is disabled.
>  +
>  Updates in-place improve performance for workloads that do frequent overwrites,
> -at the cost of potential partial writes, in case the write is interruted
> +at the cost of potential partial writes, in case the write is interrupted
>  (system crash, device failure).
>  
>  *datasum*::
> @@ -171,7 +171,7 @@ corresponding file attribute (see `chattr`(1)).
>  NOTE: If 'nodatacow' or 'nodatasum' are enabled, compression is disabled.
>  +
>  There is a slight performance gain when checksums are turned off, the
> -correspoinding metadata blocks holding the checksums do not need to updated.
> +corresponding metadata blocks holding the checksums do not need to be updated.
>  The cost of checksumming of the blocks in memory is much lower than the IO,
>  modern CPUs feature hardware support of the checksumming algorithm.
>  
> @@ -185,7 +185,7 @@ missing, for example if a stripe member is completely missing from RAID0.
>  Since 4.14, the constraint checks have been improved and are verified on the
>  chunk level, not an the device level. This allows degraded mounts of
>  filesystems with mixed RAID profiles for data and metadata, even if the
> -device number constraints would not be satisfied for some of the prifles.
> +device number constraints would not be satisfied for some of the profiles.
>  +
>  Example: metadata -- raid1, data -- single, devices -- /dev/sda, /dev/sdb
>  +
> @@ -649,7 +649,7 @@ inherent limit of btrfs is 2^64^ (16 EiB) but the linux VFS limit is 2^63^ (8 Ei
>  
>  maximum number of subvolumes::
>  2^64^ but depends on the available metadata space, the space consumed by all
> -subvolume metadata includes bookeeping of the shared extents can be large (MiB,
> +subvolume metadata includes bookkeeping of the shared extents can be large (MiB,
>  GiB)
>  
>  maximum number of hardlinks of a file in a directory::
> diff --git a/Documentation/btrfs-property.asciidoc b/Documentation/btrfs-property.asciidoc
> index b562717..4bad88b 100644
> --- a/Documentation/btrfs-property.asciidoc
> +++ b/Documentation/btrfs-property.asciidoc
> @@ -34,7 +34,7 @@ specify what type of object you meant. This is only needed when a
>  property could be set for more then one object type.
>  +
>  Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]', where
> -the first lettes is a shortcut.
> +the first letter is a shortcut.
>  +
>  Set the name of property by 'name'. If no 'name' is specified,
>  all properties for the given object are printed. 'name' is one of
> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
> index dff0867..dc4c93b 100644
> --- a/Documentation/btrfs-qgroup.asciidoc
> +++ b/Documentation/btrfs-qgroup.asciidoc
> @@ -52,7 +52,7 @@ assignment would lead to quota inconsistency. See 'QUOTA RESCAN' for more
>  information.
>  --no-rescan::::
>  Explicitly ask not to do a rescan, even if the assignment will make the quotas
> -inconsitent. This may be useful for repeated calls where the rescan would add
> +inconsistent. This may be useful for repeated calls where the rescan would add
>  unnecessary overhead.
>  
>  *create* <qgroupid> <path>::
> @@ -140,7 +140,7 @@ force sync of the filesystem identified by <path> before getting information.
>  
>  QUOTA RESCAN
>  ------------
> -The rescan reads all extent sharing metadata and updates the respective qgoups
> +The rescan reads all extent sharing metadata and updates the respective qgroups
>  accordingly.
>  
>  The information consists of bytes owned exclusively ('excl') or shared/referred
> diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
> index 2a1c359..84e9cc0 100644
> --- a/Documentation/mkfs.btrfs.asciidoc
> +++ b/Documentation/mkfs.btrfs.asciidoc
> @@ -314,7 +314,7 @@ layer between the logical and physical view of the device. The data lifetime
>  may be affected by frequent plugging. The memory cells could get damaged,
>  hopefully not destroying both copies of particular data in case of DUP.
>  
> -The wear levelling techniques can also lead to reduced redundancy, even if the
> +The wear leveling techniques can also lead to reduced redundancy, even if the
>  device does not do any deduplication. The controllers may put data written in
>  a short timespan into the same physical storage unit (cell, block etc). In case
>  this unit dies, both copies are lost. BTRFS does not add any artificial delay
> 
